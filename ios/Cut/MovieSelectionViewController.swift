//
//  MovieSelectionViewController.swift
//  Cut
//
//  Created by Kyle Satti on 4/27/24.
//

import UIKit
import Combine

class MovieSelectionViewController: KeyboardAnimationVC {
    private var keyboardConstraint: NSLayoutConstraint?
    private let searchViewModel = SearchViewModel()
    private var searchSubscription: AnyCancellable?
    private var tableView: UITableView!
    lazy var searchBar = {
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.tintColor = .lightGray
        let leftView = UIView()
        leftView.addSubview(searchIcon)
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 6),
            searchIcon.centerXAnchor.constraint(equalTo: leftView.centerXAnchor),
            searchIcon.topAnchor.constraint(equalTo: leftView.topAnchor),
            searchIcon.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
            searchIcon.heightAnchor.constraint(equalToConstant: 22),
            searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor),
        ])
        let searchBar = UITextField()
        searchBar.leftView = leftView
        searchBar.leftViewMode = .always
        searchBar.placeholder = "Search..."
        searchBar.layer.borderColor = Theme.current.lightgray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.backgroundColor = Theme.current.background
        searchBar.layer.cornerRadius = 15
        searchBar.returnKeyType = .done
        searchBar.keyboardType = .asciiCapable
        searchBar.delegate = self
        searchBar.clearButtonMode = .always
        searchBar.addAction(UIAction(handler: { [weak self] _ in
            self?.searchViewModel.searchTerm = searchBar.text ?? ""
        }), for: .editingChanged)
        return searchBar
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
    lazy var searchBarContainer = UIView()
    lazy var bottomView = UIView()
    let movieSelected: (Movie) -> Void

    init(movieSelected: @escaping (Movie) -> Void) {
        self.movieSelected = movieSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()

        let item = UINavigationItem(title: "Add movie")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAnimated))
        item.rightBarButtonItem = cancelButton

        let nav = UINavigationBar()
        nav.delegate = self
        nav.items = [item]

        tableView = UITableView()
        tableView.estimatedRowHeight = 140
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 0)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.addSubview(searchBar)

        let fillerView = UIView()
        fillerView.backgroundColor = Theme.current.background

        [loadingIndicator, infoLabel].forEach { infoView.addSubview($0) }
        [searchBarContainer, fillerView].forEach { bottomView.addSubview($0) }
        [tableView, infoView, nav, bottomView].forEach { view.addSubview($0) }
        bottomView.disableAutoresizing()
        infoView.disableAutoresizing()
        view.disableAutoresizing()

        let keyboardConstraint = searchBarContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        self.keyboardConstraint = keyboardConstraint

        NSLayoutConstraint.activate([
            nav.topAnchor.constraint(equalTo: view.topAnchor),
            nav.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nav.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nav.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            infoView.topAnchor.constraint(equalTo: tableView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),

            infoLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 24),
            infoLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),

            searchBarContainer.topAnchor.constraint(equalTo: bottomView.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            keyboardConstraint,

            fillerView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor),
            fillerView.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            fillerView.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            fillerView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),

            searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor, constant: 24),
            searchBar.centerXAnchor.constraint(equalTo: searchBarContainer.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor, constant: 12),
            searchBar.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),

            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        searchSubscription = searchViewModel.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            self?.updateView(state)
        }
    }

    private func updateView(_ state: SearchViewModel.State) {
        loadingIndicator.stopAnimating()
        tableView.reloadData()
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
                infoLabel.text = searchViewModel.searchTerm.isEmpty ? "Search for a film" : "No results"
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

    override func keyboardAnimations(to keyboardHeight: CGFloat) {
        keyboardConstraint?.isActive = false
        if keyboardVisible {
            keyboardConstraint = searchBarContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight)
        } else {
            keyboardConstraint = searchBarContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        }
        keyboardConstraint?.isActive = true
    }

    @objc private func dismissAnimated() {
        dismiss(animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let _ = searchBarContainer.layer.sublayers?[0] as? CAGradientLayer {
            searchBarContainer.layer.sublayers?[0].removeFromSuperlayer()
        }

        let gradient = CAGradientLayer()

        gradient.frame = searchBarContainer.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.8)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.1)

        searchBarContainer.layer.insertSublayer(gradient, at: 0)

        var edgeInsets = tableView.contentInset
        edgeInsets.bottom = bottomView.frame.height
        tableView.contentInset = edgeInsets
    }
}

extension MovieSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension MovieSelectionViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension MovieSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.state.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "movie-cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Optional<ContentRowCell> ?? ContentRowCell()
        let movie = searchViewModel.state.results[indexPath.row]
        cell.set(movie)
        return cell
    }
}

extension MovieSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        keyboardConstraint?.isActive = false
        movieSelected(searchViewModel.state.results[indexPath.row])
    }
}

