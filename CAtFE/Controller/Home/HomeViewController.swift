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

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createCafeBtnView: UIView!
    @IBOutlet weak var createBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var createBtnRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func filterBtn(_ sender: Any) {
        petFilterBtn()
    }
    
//    var resultSearchController: UISearchController?
    private lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    private let locationManager: CLLocationManager = CLLocationManager()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let cafeManager = CafeManager()
    var userLocation: CLLocationCoordinate2D?
    var phone: String?
    var selectedDest: String?
    var selectedPin: MKPlacemark?
    var currentPlaceMark: CLPlacemark?
    var searchResult = ""
    var searching = false
    var zoomInSearchLocation: ((String) -> Void)?
    var locationList: [[String: String]] = []
    var searchedList: [[String: String]] = []
    var cafeList: [Cafe] = [] {
        didSet {
            self.createAnnotations(locations: cafeList)
        }
    }
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
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

        initView()
        initMapView()
        setUpTabBarItem()
//        setUpCollectionView()
        getCafeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpLocationAuthorization()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initView() {
        createBtnRightConstraint.constant = width * 0.05
        createBtnBottomConstraint.constant = width * 0.05
        
        searchTextField.delegate = self
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.registerCellWithNib(identifier: String(describing: SearchLocationTableViewCell.self), bundle: nil)
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func setUpTabBarItem() {
        let tabBarHome = self.tabBarController?.tabBar.items?[1]
        tabBarHome?.image = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBarHome?.selectedImage = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    @objc func petFilterBtn() {
        let presentVC = UIStoryboard.popup
            .instantiateViewController(identifier: SinaLikePopupViewController.identifier)
            as? SinaLikePopupViewController
        presentVC?.selectedPet = { (title) in
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            self.petFilterSelected(locations: self.cafeList, petType: title)
        }
        presentVC?.modalPresentationStyle = .overFullScreen
        self.present(presentVC!, animated: false, completion: nil)
    }
    
    func initMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        let center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.0477505, longitude: 121.5148712), latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(center, animated: true)

        createCafeBtnView.layer.cornerRadius = createCafeBtnView.frame.width / 2
    }
    
    func createNaviRightBtn() {
        let filterBtn = UIBarButtonItem(image: UIImage(named: "filter"),
        style: .plain,
        target: self,
        action: #selector(petFilterBtn))
        navigationItem.rightBarButtonItem = filterBtn
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
                self.cafeList = cafeData.results
                self.getLocationList(data: cafeData.results)
            case .failure(let error):
                print("======= getCafeData error: \(error)")
            }
        }
    }
    
    func getLocationList(data: [Cafe]) {
        for location in cafeList {
            locationList.append(["title": location.name, "address": location.address])
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
        self.show(presentVC!, sender: nil)
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
        userLocation = nowLocation
        geoCoder.reverseGeocodeLocation(currentLocation) { (placeMark, _) in
            self.currentPlaceMark = placeMark?.first
        }
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        zoomInSearchLocation = { location in
            let target = self.cafeList.filter({ $0.name == location})
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: target[0].latitude, longitude: target[0].longitude), span: span)
            mapView.setRegion(region, animated: true)
        }
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
        self.geoCoder.geocodeAddressString(destination) { (place: [CLPlacemark]?, _) -> Void in
            let destination = place?.first
            guard let currentPlaceMark = self.currentPlaceMark else { return }
            self.beginNav(currentPlaceMark, endPLCL: destination!)
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
        MKMapItem.openMaps(with: mapItems, launchOptions: dic)
    }
}

extension HomeViewController: PetFilterDelegate {
    func showPetCategory(_ cell: HomeFilterCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        switch indexPath.item {
        case 0:
            petFilterClick(cell)
        default:
            wifiFilterClick(locations: cafeList)
        }
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
            newPins = locations.filter({ $0.petType == "CAT"})
        case "狗":
            newPins = locations.filter({ $0.petType == "DOG"})
        case "其他":
            newPins = locations.filter({ $0.petType != "CAT" && $0.petType != "DOG"})
        default:
            newPins = locations
        }
        createAnnotations(locations: newPins)
    }

    func wifiFilterClick(locations: [Cafe]) {
//        var newPins: [Cafe] = []
//        newPins = locations.filter({ $0.wifi == true})
//        createAnnotations(locations: newPins)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.petFilterBtn()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.createNaviRightBtn()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedList.count
        } else {
            return locationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchLocationTableViewCell.identifier,
                                                       for: indexPath) as? SearchLocationTableViewCell else {
            return UITableViewCell()
        }
        if searching {
            cell.setData(data: searchedList[indexPath.row])
        } else {
            cell.setData(data: locationList[indexPath.row])
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResult = locationList[indexPath.row]["title"]!
        zoomInSearchLocation?(searchResult)
        self.tableView.isHidden = true
        self.view.endEditing(true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setUpTableView()
        searchedList.removeAll()
        tableView.isHidden = false
        searching = false
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText  = textField.text! + string

        if searchText.count >= 3 {
            searchedList = self.locationList.filter { (($0["title"]!).localizedCaseInsensitiveContains(searchText)) }
            if searchedList.count == 0 {
                searching = false
            } else {
                searching = true
            }
        } else {
            searchedList = []
        }
        tableView.reloadData()
        return true
    }
}
