//
//  HomeViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager: CLLocationManager = CLLocationManager()
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
        initMapView()
        setUpCollectionView()
        getCafeData()
        
//        updateCafeData()
//        createCafeData()
//        deleteCafeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpLocationAuthorization()
    }
    
    func initMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        mapView.showsUserLocation = true
    }
    
    func setUpLocationAuthorization() {
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            locationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
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
    
    func updateCafeData() {
        let cafeId = 4
        let cafe = Cafe(id: cafeId, name: "貓下去敦北俱樂部", tel: "02-27177596", address: "台北市松山區敦化北路218號", petType: "貓", latitude: 25.0587, longitude: 121.549, website: "", facebook: "", notes: "")
        cafeManager.updateCafeInList(cafeId: cafeId, cafeObj: cafe) { (result) in
            switch result {
            case .success:
                print("修改成功")
            case .failure(let error):
                print("=======update", error)
            }
        }
    }
    
    func createCafeData() {
        let cafe = Cafe(id: 111, name: "test", tel: "test", address: "test", petType: "test", latitude: 25.058734, longitude: 121.548898, website: "", facebook: "", notes: "")
        cafeManager.createCafeInList(cafeObj: cafe) { (result) in
            switch result {
            case .success:
                print("新增成功")
            case .failure(let error):
                print("=======create", error)
            }
        }
    }
    
    func deleteCafeData() {
        let cafe = Cafe(id: 5, name: "test", tel: "test", address: "test", petType: "test", latitude: 25.058734, longitude: 121.548898, website: "", facebook: "", notes: "")
        cafeManager.deleteCafeInList(cafeId: 5, cafeObj: cafe) { (result) in
            switch result {
            case .success:
                print("新增成功")
            case .failure(let error):
                print("=======create", error)
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

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation :CLLocation = locations[0] as CLLocation
        let nowLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: nowLocation,
        span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
    }
}
