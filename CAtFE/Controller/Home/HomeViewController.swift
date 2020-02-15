//
//  HomeViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: AnyObject {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createCafeBtnView: UIView!

    var resultSearchController: UISearchController?
    private lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    private let locationManager: CLLocationManager = CLLocationManager()
    let width = UIScreen.main.bounds.width
    let cafeManager = CafeManager()
    var phone: String?
    var selectedDest: String?
    var selectedPin: MKPlacemark?
    var cafeList: [Cafe] = [] {
        didSet {
            self.createAnnotations(locations: cafeList)
        }
    }
    
    let filterList = ["離我最近", "寵物篩選", "Wifi"]
    let iconList = ["", "filter", ""]

    @IBAction func backToUserLocation(_ sender: Any) {
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }

    @IBAction func createCafeBtn(_ sender: Any) {
        createNewCafe()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBarItem()
        initMapView()
        setSearchBar()
        setUpCollectionView()
        getCafeData()
        
//        updateCafeData()
//        deleteCafeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpLocationAuthorization()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func setUpTabBarItem() {
        let tabBarHome = self.tabBarController?.tabBar.items?[2]
        tabBarHome?.image = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBarHome?.selectedImage = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    func initMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        createCafeBtnView.layer.cornerRadius = createCafeBtnView.frame.width / 2
    }

    func setSearchBar() {
        let locationSearchTable = UIStoryboard.home
            .instantiateViewController(identifier: LocationSearchTable.identifier)
            as? LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable!.mapView = mapView
        locationSearchTable?.handleMapSearchDelegate = self

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
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
                title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCafeData() {
        cafeManager.getCafeList { (result) in
            switch result {
            case .success(let cafeData):
                self.cafeList = cafeData.data
            case .failure(let error):
                print("======= getCafeData error: \(error)")
            }
        }
    }
    
    func updateCafeData() {
        let cafeId = 4
        let cafe = Cafe(id: cafeId,
                        name: "貓下去敦北俱樂部",
                        tel: "02-27177596",
                        address: "台北市松山區敦化北路218號",
                        petType: "貓",
                        latitude: 25.0587, longitude: 121.549,
                        wifi: false,
                        website: "",
                        facebook: "",
                        notes: "")
        cafeManager.updateCafeInList(cafeId: cafeId, cafeObj: cafe) { (result) in
            switch result {
            case .success:
                print("修改成功")
            case .failure(let error):
                print("=======update", error)
            }
        }
    }
    
    func deleteCafeData() {
        let cafe = Cafe(id: 5,
                        name: "test",
                        tel: "test",
                        address: "test",
                        petType: "test",
                        latitude: 25.058734, longitude: 121.548898,
                        wifi: false,
                        website: "",
                        facebook: "",
                        notes: "")
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
            annotations.subtitle = location.address
            phone = location.tel
            annotations.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotations)
        }
    }

    func createNewCafe() {
        let presentVC = UIStoryboard.createCafe
            .instantiateViewController(identifier: CreateCafeViewController.identifier)
            as? CreateCafeViewController
        presentVC?.modalPresentationStyle = .formSheet
        self.present(presentVC!, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell",
                                                            for: indexPath) as? HomeFilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.setData(title: filterList[indexPath.item], icon: iconList[indexPath.item])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation: CLLocation = locations[0] as CLLocation
        let nowLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                                 longitude: currentLocation.coordinate.longitude)
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: nowLocation,
        span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "CatAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.annotation = annotation
        annotationView?.image = UIImage(named: "catAnnotation")
        annotationView?.sizeToFit()
        annotationView?.centerOffset = CGPoint(x: 0, y: 0)// 设置大头针中心偏移量
        annotationView?.canShowCallout = true
        annotationView?.calloutOffset = CGPoint(x: 10, y: 0)// 设置弹框的偏移量
//        annotationView?.isDraggable = true// 设置大头针可以拖动
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let subTitle = UILabel()
        subTitle.numberOfLines = 0
        subTitle.text = view.annotation?.subtitle ?? ""
        subTitle.font = UIFont(name: "Helvetica-Neue", size: 14)
        
        for cafe in cafeList where view.annotation?.title == cafe.name {
            self.phone = cafe.tel
            self.selectedDest = cafe.address
        }
        
        let infoBtn = UIButton(type: .detailDisclosure)
        infoBtn.addTarget(self, action: #selector(infoDetail), for: .touchUpInside)
        view.rightCalloutAccessoryView = infoBtn
    }
    
    @objc func infoDetail() {
        let alertController = UIAlertController(title: "選擇功能", message: nil, preferredStyle: .actionSheet)
        let callOutAction = UIAlertAction(title: phone, style: .default) { (_) in
            self.callOutToCafe(phoneNumber: self.phone ?? "")
        }
        let guideAction = UIAlertAction(title: "導航路線", style: .default) { (_) in
            self.guideToCafe(destination: self.selectedDest ?? "")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(callOutAction)
        alertController.addAction(guideAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func callOutToCafe(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func guideToCafe(destination: String) {
        geoCoder.geocodeAddressString("台北市信義區基隆路一段178號") { (place: [CLPlacemark]?, _) -> Void in
            let startLocation = place?.first
            self.geoCoder.geocodeAddressString(destination) { (place: [CLPlacemark]?, _) -> Void in
                let destination = place?.first
                self.beginNav(startLocation!, endPLCL: destination!)
            }
        }
    }
    
    // - 導航 -
    func beginNav(_ startPLCL: CLPlacemark, endPLCL: CLPlacemark) {
        let startplMK: MKPlacemark = MKPlacemark(placemark: startPLCL)
        let startItem: MKMapItem = MKMapItem(placemark: startplMK)
        
        let endplMK: MKPlacemark = MKPlacemark(placemark: endPLCL)
        let endItem: MKMapItem = MKMapItem(placemark: endplMK)
        
        let mapItems: [MKMapItem] = [startItem, endItem]
        
        let dic: [String: AnyObject] = [
            // 导航模式:驾驶
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving as AnyObject,
            // 地图样式：标准样式
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue as AnyObject,
            // 显示交通：显示
            MKLaunchOptionsShowsTrafficKey: true as AnyObject]
        
        // 根据 MKMapItem 的起点和终点组成数组, 通过导航地图启动项参数字典, 调用系统的地图APP进行导航
        MKMapItem.openMaps(with: mapItems, launchOptions: dic)
    }
}

extension HomeViewController: PetFilterDelegate {
    func showPetCategory(_ cell: HomeFilterCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        switch indexPath.item {
        case 0:
            nearestCafe(cell)
        case 1:
            petFilterClick(cell)
        default:
            wifiFilterClick(locations: cafeList)
        }

    }

    func nearestCafe(_ cell: HomeFilterCollectionViewCell) {

    }

    func petFilterClick(_ cell: HomeFilterCollectionViewCell) {
        let presentVC = UIStoryboard.popup
            .instantiateViewController(identifier: SinaLikePopupViewController.identifier)
            as? SinaLikePopupViewController
        presentVC?.selectedPet = { (title) in
            cell.filterBtn.setTitle(title, for: .normal)
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            self.petFilterSelected(locations: self.cafeList, petType: title)
        }
        presentVC?.modalPresentationStyle = .overFullScreen
        self.present(presentVC!, animated: false, completion: nil)
    }

    func petFilterSelected(locations: [Cafe], petType: String) {
        var newPins: [Cafe] = []
        switch petType {
        case "貓":
            newPins = locations.filter({ $0.petType == "貓"})
        case "狗":
            newPins = locations.filter({ $0.petType == "狗"})
        case "其他":
            newPins = locations.filter({ $0.petType != "貓" && $0.petType != "狗"})
        default:
            newPins = locations
        }
        createAnnotations(locations: newPins)
    }

    func wifiFilterClick(locations: [Cafe]) {
        var newPins: [Cafe] = []
        newPins = locations.filter({ $0.wifi == true})
        createAnnotations(locations: newPins)
    }
}

extension HomeViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
