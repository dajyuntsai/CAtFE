//
//  PostAddLocationViewController.swift
//  CAtFE
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
    var cafeId: ((Int) -> Void)?
    
    let fullScreenSize = UIScreen.main.bounds.size
    let cafeManager = CafeManager()
    var cafeList: [Cafe] = [] {
        didSet {
            DispatchQueue.main.async {
//                self.getCafeLocations() // 有需要嗎？？
                self.tableView.reloadData()
            }
        }
    }
    var searchResults = [Cafe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        getCafeLocations()
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

    func getCafeLocations() {
        cafeManager.getCafeList { (result) in
            switch result {
            case .success(let data):
                self.cafeList = data.results
            case.failure(let error):
                print("======= Add Location error: \(error)")
            }
            
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCafeCell",
                                                       for: indexPath) as? LocationTableViewCell else {
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
        let data = cafeList[indexPath.row]
        self.delegate?.setCafeName(cafeName: data.name)        
        cafeId?(cafeList[indexPath.row].id)
        
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
