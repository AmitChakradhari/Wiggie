//
//  ViewController.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 04/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit
import SDWebImage

enum Section: String, CaseIterable {
    case movies = "Movies"
}

enum CurrentLayout {
    case grid
    case list
}

class ViewController: UIViewController {

    var searchBar: UISearchBar! = nil
    var toggleButton: UIButton! = nil
    var collectionView: UICollectionView! = nil
    var emptyView: UILabel! = UILabel(frame: .zero)
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    let listTag = 11
    let gridTag = 22
    
    var searchKeyword = ""
    
    var debounce_timer:Timer?
    
    var currentLayout = CurrentLayout.list {
        didSet {
            configureDataSource(layout: currentLayout)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieItem>! = nil
    
    var movieDataSource: [MovieItem] = []
    
    lazy var gridLayout = generateGridLayout()
    lazy var listLayout = generateListLayout()
    
    var pageNumber: Int = 1
    var isPageRefreshing:Bool = false {
        didSet {
            if isPageRefreshing {
                spinner.isHidden = false
            } else {
                spinner.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        configureDataSource(layout: .list)
    }


    @objc func handleLayoutToggle(_ sender: UIButton) {
        if sender.tag == listTag {
            sender.tag = gridTag
            sender.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
            currentLayout = .grid
            self.collectionView.startInteractiveTransition(to: gridLayout)
            self.collectionView.finishInteractiveTransition()
        } else {
            sender.tag = listTag
            sender.setImage(UIImage(systemName: "rectangle.grid.2x2.fill"), for: .normal)
            currentLayout = .list
            self.collectionView.startInteractiveTransition(to: listLayout)
            self.collectionView.finishInteractiveTransition()
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func fetchMovies(searchText: String, page: Int) {
        self.isPageRefreshing = true
        NetworkWorker.getMovies(keyword: searchText, page: page, completion: { movieResponses, error in
            
            if let error = error {
                self.handle(error)
            }
            if let movies = movieResponses?.Search {
                self.applySnapshot(movieList: movies, page: page)
            } else {
                self.applySnapshot(movieList: nil, page: page)
            }
            self.isPageRefreshing = false
        })
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchKeyword = searchText
            fetchMovies(searchText: searchText, page: pageNumber)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounce_timer?.invalidate()
        debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { _ in
            if let searchText = searchBar.text {
                self.searchKeyword = searchText
                self.pageNumber = 1
                self.fetchMovies(searchText: searchText, page: self.pageNumber)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func configureView() {
        searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search movies..."
        searchBar.searchBarStyle = .prominent
        searchBar.sizeToFit()
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        toggleButton = UIButton(frame: .zero)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.tag = listTag
        toggleButton.setImage(UIImage(systemName: "rectangle.grid.2x2.fill"), for: .normal)
        toggleButton.addTarget(self, action: #selector(handleLayoutToggle(_:)), for: .touchUpInside)
        view.addSubview(toggleButton)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.cellReuseIdentifier)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.cellReuseIdentifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.text = "Empty"
        emptyView.textColor = .white
        emptyView.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        emptyView.isHidden = false
        collectionView.addSubview(emptyView)
        
        spinner.center = view.center
        spinner.color = .systemBlue
        view.addSubview(spinner)
        spinner.startAnimating()
        spinner.isHidden = true
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toggleButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            toggleButton.heightAnchor.constraint(equalToConstant: 44),
            toggleButton.widthAnchor.constraint(equalToConstant: 44),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            
        ])
    }
    
    func generateLayout() -> UICollectionViewLayout {
        return currentLayout == .list ? self.generateListLayout() : self.generateGridLayout()
    }
    
    func generateGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/2.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func generateListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(64)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource(layout: CurrentLayout) {
        dataSource = UICollectionViewDiffableDataSource<Section, MovieItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movieItem: MovieItem) -> UICollectionViewCell? in
            
            if layout == .list {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.cellReuseIdentifier, for: indexPath) as? ListCollectionViewCell else {
                    fatalError("could not create cell")
                }
                
                if let imageUrlString = movieItem.Poster, let imageUrl = URL(string: imageUrlString) {
                    cell.imageView.sd_setImage(with: imageUrl)
                }
                cell.imageLabel.text = movieItem.Title ?? ""
                
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.cellReuseIdentifier, for: indexPath) as? GridCollectionViewCell else {
                    fatalError("could not create cell")
                }
                if let imageUrlString = movieItem.Poster, let imageUrl = URL(string: imageUrlString) {
                    cell.imageView.sd_setImage(with: imageUrl)
                }
                cell.imageLabel.text = movieItem.Title ?? ""
                return cell
            }
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, MovieItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieItem>()
        
        snapshot.appendSections([Section.movies])
        snapshot.appendItems(movieDataSource)
        return snapshot
    }
    
    func applySnapshot(movieList: [MovieItem]?, page: Int) {
        var snapshot = dataSource.snapshot()
        if let movies = movieList {
            if page == 1 {
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: Section.movies))
                snapshot.appendItems(movies, toSection: Section.movies)
                movieDataSource = movies
                emptyView.isHidden = true
            } else {
                snapshot.appendItems(movies, toSection: Section.movies)
                movieDataSource.append(contentsOf: movies)
                emptyView.isHidden = true
            }
        } else {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: Section.movies))
            movieDataSource = []
            emptyView.isHidden = false
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                print(pageNumber, "pageNumber")
                pageNumber += 1
                fetchMovies(searchText: searchKeyword, page: pageNumber)
            }
        }
    }
}

private extension ViewController {
    func handle(_ error: Error) {
        let alert = UIAlertController(
            title: "An error occured",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default
        ))
        
        alert.addAction(UIAlertAction(
            title: "Retry",
            style: .default,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.fetchMovies(searchText: self.searchKeyword, page: self.pageNumber)
            }
        ))
        
        present(alert, animated: true)
    }
}
