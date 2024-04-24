//
//  ReorderableCollectionView.swift
//  Cut
//
//  Created by Kyle Satti on 4/2/24.
//

import UIKit
import SwiftUI
import Combine
import Apollo

class FavoriteMovieEditorViewController: UIViewController {
    private var _movies: [any FavoriteMovie]
    private var movies: [any FavoriteMovie] {
        set { updateMovies(newValue) }
        get { _movies }
    }
    let moviesLayout = OneLineCollectionViewLayout()
    let placeholderLayout = PlaceholderLayout()

    lazy var moviesCollectionView = {
        let c = SelfSizingCollectionView(frame: .zero, collectionViewLayout: moviesLayout)
        c.dataSource = self
        c.dragDelegate = self
        c.dropDelegate = self
        c.isScrollEnabled = false
        c.dragInteractionEnabled = true
        c.clipsToBounds = false
        c.backgroundColor = .clear
        c.reorderingCadence = .fast
        c.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: "TEST")
        return c
    }()
    lazy var placeholderCollectionView = {
        let c = SelfSizingCollectionView(frame: .zero, collectionViewLayout: placeholderLayout)
        c.dataSource = self
        c.isScrollEnabled = false
        c.backgroundColor = .clear
        c.dragInteractionEnabled = false
        c.register(PlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: "TEST")
        return c
    }()
    lazy var searchBar = {
        let searchBar = UITextField()
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        searchBar.leftViewMode = .always
        searchBar.placeholder = "Search..."
        searchBar.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        searchBar.layer.cornerRadius = 5
        searchBar.returnKeyType = .done
        searchBar.keyboardType = .asciiCapable
        searchBar.delegate = self
        searchBar.clearButtonMode = .always
        searchBar.addAction(UIAction(handler: { [weak self] _ in
            self?.searchViewModel.searchTerm = searchBar.text ?? ""
        }), for: .editingChanged)
        self.searchCancellable = self.searchViewModel.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            self?.updateView(state)
        }
        return searchBar
    }()
    lazy var resultsTableView = {
        let resultsTable = UITableView()
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.dragDelegate = self
        return resultsTable
    }()
    lazy var loadingIndicator = UIActivityIndicatorView(style: .large)
    lazy var infoView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    lazy var infoLabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        l.textColor = .lightGray
        l.font = .systemFont(ofSize: 24)
        return l
    }()
    private let searchViewModel = SearchViewModel()
    private var searchCancellable: AnyCancellable?
    private var inFlightRequest: Apollo.Cancellable? {
        didSet {

        }
    }
    let dismiss: () -> Void

    init(movies: [any FavoriteMovie], dismiss: @escaping () -> Void) {
        _movies = []
        self.dismiss = dismiss
        super.init(nibName: nil, bundle: nil)
        updateMovies(movies)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateMovies(_ newValue: [any FavoriteMovie]) {
        _movies = Array(newValue[0..<min(FavoriteMovieEditorConfig.maxItems, newValue.count)])
        updateView(searchViewModel.state)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moviesCollectionView.reloadData()
        placeholderCollectionView.reloadData()
    }

    class CollectionViewContainer: UIView {
        override var intrinsicContentSize: CGSize {
            return subviews[1].intrinsicContentSize
        }
    }

    class SelfSizingCollectionView: UICollectionView {
        override var intrinsicContentSize: CGSize {
            return collectionViewLayout.collectionViewContentSize
        }
    }

    override func loadView() {
        let collectionViewContainer = CollectionViewContainer(frame: .zero)

        collectionViewContainer.addSubview(placeholderCollectionView)
        collectionViewContainer.addSubview(moviesCollectionView)
        collectionViewContainer.disableAutoresizing()
        collectionViewContainer.setContentHuggingPriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            collectionViewContainer.leadingAnchor.constraint(equalTo: moviesCollectionView.leadingAnchor),
            collectionViewContainer.trailingAnchor.constraint(equalTo: moviesCollectionView.trailingAnchor),
            collectionViewContainer.topAnchor.constraint(equalTo: moviesCollectionView.topAnchor),
            collectionViewContainer.bottomAnchor.constraint(equalTo: moviesCollectionView.bottomAnchor),

            collectionViewContainer.leadingAnchor.constraint(equalTo: placeholderCollectionView.leadingAnchor),
            collectionViewContainer.trailingAnchor.constraint(equalTo: placeholderCollectionView.trailingAnchor),
            collectionViewContainer.topAnchor.constraint(equalTo: placeholderCollectionView.topAnchor),
            collectionViewContainer.bottomAnchor.constraint(equalTo: placeholderCollectionView.bottomAnchor),
        ])

        let rootView = UIView()

        let bottomContainer = UIView()
        bottomContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomContainer.layer.cornerRadius = 15
        bottomContainer.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        bottomContainer.layer.shadowColor = UIColor.black.cgColor

        let saveButtonConfig = UIHostingConfiguration {
            StatedPrimaryButton(text: "Save") { button in
                let update = CutGraphQL.UpdateAccountInput(favoriteMovies: .some(self.movies.map { $0.id }))
                button.state = .loading
                self.inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UpdateAccountMutation(params: update), resultHandler: { result in
                    button.state = .notLoading
                    switch result.parseGraphQL() {
                    case .success:
                        self.dismiss()
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "okay", style: .cancel))
                        self.present(alert, animated: true)
                    }
                })
            }
        }
        let saveButton = saveButtonConfig.margins([.all], 0).makeContentView()

        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        let color = UIColor { traits in traits.userInterfaceStyle == .dark ? .white : .black }
        cancelButton.setTitleColor(color, for: .normal)
        cancelButton.addAction(UIAction(handler: { _ in
            self.dismiss()
        }), for: .touchUpInside)

        [loadingIndicator, infoLabel].forEach { infoView.addSubview($0) }
        [collectionViewContainer, saveButton].forEach { bottomContainer.addSubview($0) }
        [searchBar, cancelButton, resultsTableView, bottomContainer, infoView].forEach { rootView.addSubview($0) }
        infoView.disableAutoresizing()
        bottomContainer.disableAutoresizing()
        rootView.disableAutoresizing()

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 24),
            searchBar.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 24),
            searchBar.heightAnchor.constraint(equalToConstant: 38),

            cancelButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            cancelButton.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -24),
            cancelButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),

            resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            resultsTableView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),

            infoView.topAnchor.constraint(equalTo: resultsTableView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: resultsTableView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: resultsTableView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: resultsTableView.bottomAnchor),

            infoLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 24),
            infoLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),

            bottomContainer.topAnchor.constraint(equalTo: resultsTableView.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            bottomContainer.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),

            collectionViewContainer.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 24),
            collectionViewContainer.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 24),
            collectionViewContainer.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),

            saveButton.topAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor, constant: 24),
            saveButton.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: -24),
            saveButton.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
            saveButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
        ])

        view = rootView
    }

    private func updateView(_ state: SearchViewModel.State) {
        loadingIndicator.stopAnimating()
        resultsTableView.reloadData()
        guard movies.count < 5 else {
            infoView.isHidden = false
            infoLabel.isHidden = false
            loadingIndicator.isHidden = true
            infoLabel.text = "Remove a film to add a new one 👇"
            return
        }
        switch state {
        case .searching:
            infoView.isHidden = false
            infoLabel.isHidden = true
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        case .results(let results):
            if results.isEmpty {
                infoView.isHidden = false
                infoLabel.isHidden = false
                loadingIndicator.isHidden = true
                infoLabel.text = searchViewModel.searchTerm.isEmpty ? "Search to add films ☝️" : "No results"
            } else {
                infoView.isHidden = true
                infoLabel.isHidden = true
                loadingIndicator.isHidden = true
            }
        case .error(let error):
            infoView.isHidden = false
            infoLabel.isHidden = false
            loadingIndicator.isHidden = true
            infoLabel.text = error.localizedDescription
        }
    }
}

extension FavoriteMovieEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesCollectionView {
            return movies.count
        } else {
            return max(FavoriteMovieEditorConfig.maxItems - movies.count, 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == moviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TEST", for: indexPath) as! PosterCollectionViewCell
            let movie = movies[indexPath.item]
            cell.movie = movie
            cell.removeAction = { [weak collectionView, weak self] in
                guard let `self` = self, let removedIndex = collectionView?.indexPath(for: cell) else {
                    return
                }
                let removedMovie = self.movies.remove(at: removedIndex.item)
                if let tableIndex = searchViewModel.state.results.firstIndex(where: { movie in
                    removedMovie.allIds.contains(movie.id)
                }) {
                    self.resultsTableView.reloadRows(at: [IndexPath(row: tableIndex, section: 0)], with: .none)
                }
                collectionView?.performBatchUpdates {
                    collectionView?.deleteItems(at: [removedIndex])
                }
                self.placeholderCollectionView.performBatchUpdates { [weak self] in
                    guard let `self` = self else { return }
                    // 5 to 4 -> insert 0, 4 -> 3 -> insert 1
                    let insertIndex = max(4 - self.movies.count, 0)
                    self.placeholderCollectionView.insertItems(at: [IndexPath(item: insertIndex, section: 0)])
                }
            }
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TEST", for: indexPath)
        }
    }


    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension FavoriteMovieEditorViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = movies[indexPath.item]
        let provider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension FavoriteMovieEditorViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        if let _ = session.items.first?.localObject as? any FavoriteMovie {
            if movies.count >= 5 {
                return  UICollectionViewDropProposal(operation: .forbidden)
            }
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: movies.count, section: 0)
        guard let item = coordinator.items.first else {
            return
        }
        if let sourceIndex = item.sourceIndexPath {
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            collectionView.performBatchUpdates {
                let movie = movies.remove(at: sourceIndex.item)
                collectionView.deleteItems(at: [sourceIndex])
                movies.insert(movie, at: destinationIndexPath.item)
                collectionView.insertItems(at: [destinationIndexPath])
            }
        } else if let movie = item.dragItem.localObject as? any FavoriteMovie {
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            movies.insert(movie, at: destinationIndexPath.item)
            collectionView.performBatchUpdates {
                collectionView.insertItems(at: [destinationIndexPath])
            }
            placeholderCollectionView.performBatchUpdates {
                placeholderCollectionView.deleteItems(at: [IndexPath(item: 5 - self.movies.count, section: 0)])
            }

        }
    }

}

extension FavoriteMovieEditorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.state.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "test"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Optional<ContentRowCell> ?? ContentRowCell()
        let movie = searchViewModel.state.results[indexPath.row]
        let isIncluded = movies.contains { $0.allIds.contains(movie.id) }
        cell.update(movie: movie, isIncluded: isIncluded)
        cell.action = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.searchBar.resignFirstResponder()
            if let index = self.movies.firstIndex(where: { $0.allIds.contains(movie.id) }) {
                self.movies.remove(at: index)
                self.moviesCollectionView.performBatchUpdates {
                    self.moviesCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }
                self.placeholderCollectionView.performBatchUpdates {
                    let index = max(4 - self.movies.count, 0)
                    self.placeholderCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                }
            } else {
                self.movies.append(movie)
                self.moviesCollectionView.performBatchUpdates {
                    let index = self.movies.count - 1
                    self.moviesCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                }
                self.placeholderCollectionView.performBatchUpdates {
                    let index = max(5 - self.movies.count, 0)
                    self.placeholderCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }
            }
        }
        return cell
    }
}

extension FavoriteMovieEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension FavoriteMovieEditorViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension FavoriteMovieEditorViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        searchBar.resignFirstResponder()
        let item = searchViewModel.state.results[indexPath.row]
        let provider = NSItemProvider(object: URL(string: item.url)! as NSURL)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = item
        let frame = CGRect(origin: .zero, size: FavoriteMovieEditorConfig.calculateItemSize(frame: moviesCollectionView.frame))
        dragItem.previewProvider = {
            let imageView = UIImageView(frame: frame)
            imageView.kf.setImage(with: item.parsedPosterUrl)
            return UIDragPreview(view: imageView)
        }
        dragItem.localObject = item
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        guard let movie = session.items.first?.localObject as? (any FavoriteMovie) else {
            return
        }
        guard let index = searchViewModel.state.results.firstIndex(where: { $0.id == movie.id }) else {
            return
        }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

#Preview {
    FavoriteMovieEditor(movies: [Mocks.favoriteMovie, Mocks.favoriteMovie, Mocks.favoriteMovie], isPresented: Binding.constant(true))
}
