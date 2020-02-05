//
//  PostAddLocationViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/4.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol DisplayCafeNameDelegate: AnyObject {
    func setCafeName(cafeName: String)
}

class PostAddLocationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    weak var delegate: DisplayCafeNameDelegate?
    
    let fullScreenSize = UIScreen.main.bounds.size
    let cafeList = [Cafe(name: "臺北市"), Cafe(name: "新北市"), Cafe(name: "桃園市"), Cafe(name: "臺中市")]
    var searchResults = [Cafe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        tableView.dataSource = self
        tableView.delegate = self

        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

}

extension PostAddLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
          return searchResults.count
        }
        return cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCafeCell", for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        let cafe: Cafe
        if searchController.isActive && searchController.searchBar.text != "" {
            cafe = searchResults[indexPath.row]
        } else {
            cafe = cafeList[indexPath.row]
        }
        cell.cafeNameLabel.text = cafe.name
        return cell
    }
}

extension PostAddLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.setCafeName(cafeName: cafeList[indexPath.row].name)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostAddLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
        }
    }
    
    func filterContent(for searchText: String) {
        searchResults = cafeList.filter { (cafe) in
            return cafe.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

struct Cafe { // ninn ninn test
    let name: String
}
