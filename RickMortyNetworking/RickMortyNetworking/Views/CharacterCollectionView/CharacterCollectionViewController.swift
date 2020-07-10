//
//  CharacterCollectionViewController.swift
//  RickMortyNetworking
//
//  Created by Shawn Gee on 7/9/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit


class CharacterCollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    
    private let apiController = RickAndMortyController()
    
    private var gender: Gender?
    private var status: Status?
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            NSLayoutConstraint(
                item: label,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: collectionView,
                attribute: .centerY,
                multiplier: 0.7, constant: 0
            )
        ])
        
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        apiController.filteredCharacterSearch(queryItems: []) { _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a character"
        searchController.searchBar.delegate = self
        searchController.
        self.navigationItem.searchController = searchController
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let filterTVC = navController.topViewController as? FilterTableViewController {
            filterTVC.delegate = self
            filterTVC.gender = gender
            filterTVC.status = status
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let characterCount = apiController.characters.count
        noResultsLabel.isHidden = characterCount != 0
        return characterCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as? CharacterCell else {
                fatalError("Unable to cast cell as \(CharacterCell.self)")
        }
        
        cell.layer.cornerRadius = 8
        cell.apiController = apiController
        cell.character = apiController.characters[indexPath.row]
        
        return cell
    }
    
}

// MARK: - Flow Layout Delegate

private let padding: CGFloat = 10
private let numRows: CGFloat = 2

extension CharacterCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding = padding * (numRows + 1)
        let width = (collectionView.frame.width - totalPadding) / numRows
        
        return CGSize(width: width, height: width * 1.35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

// MARK: - Search Delegate

extension CharacterCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        noResultsLabel.text = "No results found for \(searchTerm)"
        noResultsLabel.isHidden = true
        let queryItems = apiController.getFilterQueryItems(name: searchTerm, status: status, gender: gender)
        apiController.filteredCharacterSearch(queryItems: queryItems) { (error) in
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "Network Error", message: "Check your internet connection", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        self.navigationItem.searchController?.isActive = false
    }
    
}

// MARK: - Filter Delegate

extension CharacterCollectionViewController: FilterDelegate {
    func filterDidSelect(gender: Gender?) {
        self.gender = gender
    }
    
    func filterDidSelect(status: Status?) {
        self.status = status
    }
}
