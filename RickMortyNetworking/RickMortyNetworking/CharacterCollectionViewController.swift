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
        return apiController.characters.count
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
        let queryItems = apiController.getFilterQueryItems(name: searchBar.text, status: status, gender: gender)
        apiController.filteredCharacterSearch(queryItems: queryItems) { (error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
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
