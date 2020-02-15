//
//  LocationSearchTable.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    weak var handleMapSearchDelegate: HandleMapSearch?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension LocationSearchTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationSearchTableViewCell.identifier,
                                                       for: indexPath) as? LocationSearchTableViewCell else {
            return UITableViewCell()
        }
        let selectedItem = matchingItems[indexPath.row].placemark
        // swiftlint:disable:next line_length
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.setData(title: selectedItem.name ?? "??", desc: address)
        // swiftlint:disable:previous line_length
        return cell
    }
}

extension LocationSearchTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
