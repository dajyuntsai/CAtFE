//
//  HomeViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    let width = UIScreen.main.bounds.width
    let cafeManager = CafeManager()
    var cafeList: [Cafe] = [] {
        didSet {
            self.createAnnotations(locations: cafeList)
        }
    }
    let filterList = ["離我最近", "寵物篩選", "新增店家", "隨便"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBarItem()
        setUpCollectionView()
        getCafeData()
    }

    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
    }
    
    func setUpTabBarItem() {
        let tabBarHome = self.tabBarController?.tabBar.items?[2]
        tabBarHome?.image = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBarHome?.selectedImage = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    func getCafeData() {
        cafeManager.getCafeList { (result) in
            switch result {
            case .success(let cafeData):
                self.cafeList = cafeData.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createAnnotations(locations: [Cafe]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotations)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell", for: indexPath) as? HomeFilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.filterBtn.setTitle(filterList[indexPath.row], for: .normal)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}
