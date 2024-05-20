//
//  ProfileHeader.swift
//  Cut
//
//  Created by Kyle Satti on 3/18/24.
//

import SwiftUI

struct ProfileHeader: View {
    let profile: CutGraphQL.ProfileInterfaceFragment
    @Environment(\.openURL) private var openURL
    @State private var imageState: ProfileImage.ViewState
    @State private var isAlertPresented = false
    @State private var profileSource: ImagePicker.Source?
    @State private var presentProfilePopover = false

    init(profile: CutGraphQL.ProfileInterfaceFragment) {
        self.profile = profile
        self._imageState = .init(initialValue: .loaded(profile.imageUrl))
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name).font(.cut_title3.bold())
                    Text(profile.username).font(.cut_footnote)
                    Text(profile.bio ?? "").font(.cut_footnote)
                }
                Spacer(minLength: 18)
                HStack(spacing: 10) {
                    NavigationLink {
                        FollowTable(userId: profile.id, direction: .followers)
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(profile.followerCount)").font(.cut_footnote).bold()
                            Text("follower\(profile.followerCount > 1 ? "s" : "")").font(.cut_footnote)
                        }
                    }
                    NavigationLink {
                        FollowTable(userId: profile.id, direction: .following)
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(profile.followingCount)").font(.cut_footnote).bold()
                            Text("following").font(.cut_footnote)
                        }
                    }
                    if let url = formattedProfileUrl {
                        Circle().frame(width: 6, height: 6)
                        Button {
                            openURL(url.0)
                        } label: {
                            Text(url.1)
                                .font(.cut_footnote)
                                .lineLimit(1)
                        }
                    }
                }
            }
            Spacer()
            Button {
                presentProfilePopover.toggle()
            } label: {
                ProfileImage(state: imageState)
                    .popover(isPresented: $presentProfilePopover) {
                        VStack {
                            Button("Camera") {
                                presentProfilePopover = false
                                profileSource = .camera
                            }
                            Divider()
                            Button("Photo Library") {
                                presentProfilePopover = false
                                profileSource = .library
                            }
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    }
            }
            .disabled(!profile.isCurrentUser)

        }
        .fixedSize(horizontal: false, vertical: true)
        .sheet(item: $profileSource, content: { source in
            ImagePicker(source: source) { data in
                profileSource = nil
                guard let data = data else {
                    return
                }
                guard data.count <= 10_000_000 else {
                    isAlertPresented = true
                    return
                }
                imageState = .uploading(UIImage(data: data)!)
                imageUpload(data: data) { url in
                    imageState = .loaded(url)
                }
            }
            .ignoresSafeArea()
        })
        .alert("Image must be below 10mb", isPresented: $isAlertPresented) {
            Button("okay", role: .cancel) {
                isAlertPresented = false
            }
        }
    }

    var formattedProfileUrl: (URL, String)? {
        guard let url = profile.bio_url else  {
            return nil
        }

        return (
            url,
            "\(url.host()!)\(url.path())"
        )
    }

    // written by ChatGPT
    func mimeType(for data: Data) -> String {
        let bytes = [UInt8](data.prefix(12))
        let signatures: [String: String] = [
            "89504E47": "image/png",
            "47494638": "image/gif",
            "FFD8FF": "image/jpeg",
            "49492A00": "image/tiff",
            "4D4D002A": "image/tiff",
            "25504446": "application/pdf",
            "504B0304": "application/zip",
            "52494646": "image/webp", // WEBP files start with "RIFF"
            "00000020": "image/avif"  // AVIF files start with a unique brand "ftypavif"
        ]

        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02X", byte)
        }

        for (signature, mimeType) in signatures {
            if hexString.hasPrefix(signature) {
                return mimeType
            }
        }

        return "application/octet-stream" // default MIME type if no match found
    }

    func imageUpload(data: Data, completion: @escaping (URL?) -> ()) {
        AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetImageUploadUrlQuery(), cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result.parseGraphQL() {
            case .success(let response):
                var fields = [String : String]()
                response.imageUploadUrl.headers.forEach {
                    fields[$0.key] = $0.value
                }
                imageUpload(
                    data: data,
                    url: response.imageUploadUrl.url,
                    fileName: response.imageUploadUrl.fileName,
                    fields: fields,
                    completion: completion
                )
            case .failure(let error):
                print(error)
            }
        }
    }

    func imageUpload(data: Data, url: URL, fileName: String, fields: [String : String], completion: @escaping (URL?) -> ()) {
        let boundary = UUID().uuidString
        var body = Data()

        let mimeType = mimeType(for: data)

        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        var request = URLRequest(url: url)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.ProfileImageUploadResponseMutation(response: responseString)) { result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            if let imageUrl = data.profileImageUploadResponse.imageUrl {
                                KingfisherManager.shared.retrieveImage(with: imageUrl, options:  [.cacheOriginalImage]) { _ in
                                    completion(imageUrl)
                                }
                            } else {
                                completion(nil)
                            }
                            print(data)
                        case .failure(let error):
                            print(error)
                            completion(nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

#Preview {
    ProfileHeader(profile: Mocks.profileInterface)
        .padding(.horizontal, 18)
}

import PhotosUI
import Kingfisher
struct ImagePicker: UIViewControllerRepresentable {
    let source: Source
    private let delegate: ImagePickerCaptureDelegate

    enum Source: Identifiable {
        case camera, library
        var id: String {
            switch self {
            case .camera:
                return "camera"
            case .library:
                return "library"
            }
        }
    }

    init(source: Source, completion: @escaping (Data?) -> Void) {
        delegate = ImagePickerCaptureDelegate(completion: completion)
        self.source = source
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIViewController {
        switch source {
        case .camera, .library:
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source == .camera ? .camera : .photoLibrary
//            imagePicker.sourceType = .camera
            imagePicker.delegate = delegate
            return imagePicker
            // Sadly, although UIImagePickerController is going to depreate its .photoLibrary picker in favor of 
            // PHPickerViewController, the latter is not able to edit the crop on image and we'd have to implement that ourselves
//        case .library:
//            var config = PHPickerConfiguration()
//            config.selectionLimit = 1
//            config.filter = .images
//            let picker = PHPickerViewController(configuration: config)
//            picker.delegate = delegate
//            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}

class ImagePickerCaptureDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    let completion: (Data?) -> Void

    init(completion: @escaping (Data?) -> Void) {
        self.completion = completion
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img

        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }

        completion(image?.jpegData(compressionQuality: 1.0))
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            completion(nil)
            return
        }
        _ = result.itemProvider.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                self.completion(data)
            case .failure(_):
                self.completion(nil)
            }
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        append(string.data(using: .utf8)!)
    }
}

