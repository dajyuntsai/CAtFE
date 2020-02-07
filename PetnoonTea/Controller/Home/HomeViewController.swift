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
    
    private lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    private let locationManager: CLLocationManager = CLLocationManager()
    let width = UIScreen.main.bounds.width
    let cafeManager = CafeManager()
    var phone: String?
    var selectedDest: String?
    var cafeList: [Cafe] = [] {
        didSet {
            self.createAnnotations(locations: cafeList, petType: "")
        }
    }
    
    let filterList = ["離我最近", "寵物篩選", "新增店家", "Wifi"]
    
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
    
    func createAnnotations(locations: [Cafe], petType: String) {
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
        for location in newPins {
            let annotations = MKPointAnnotation()
            annotations.title = location.name
            annotations.subtitle = location.address
            phone = location.tel
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
        cell.delegate = self
        cell.setData(title: filterList[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation: CLLocation = locations[0] as CLLocation
        let nowLocation = CLLocationCoordinate2D(latitude: 25.058734, longitude: 121.548898)
//            currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) // TODO: 用手機build再改回來
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: nowLocation,
        span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
        subTitle.text = view.annotation?.subtitle ?? ""
        subTitle.font = UIFont(name: "Helvetica-Neue", size: 14)
        
        for cafe in cafeList {
            if view.annotation?.title == cafe.name {
                self.phone = cafe.tel
                self.selectedDest = cafe.address
            }
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
        if let url = URL(string: "tel://0981110200"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func guideToCafe(destination: String) {
        geoCoder.geocodeAddressString("台北市信義區基隆路一段178號") { (place: [CLPlacemark]?, error) -> Void in
            let startLocation = place?.first
            // 1.2 创建圆形的覆盖层数据模型
            let circle1 = MKCircle(center: (startLocation?.location?.coordinate)!, radius: 100000)
            // 1.3 添加覆盖层数据模型到地图上
            self.mapView.addOverlay(circle1)

            self.geoCoder.geocodeAddressString(destination) { (place: [CLPlacemark]?, error) -> Void in
                // 2. 拿到上海地标对象
                let destination = place?.first
                // 2.2 创建圆形的覆盖层数据模型
                let circle2 = MKCircle(center: (destination?.location?.coordinate)!, radius: 100000)
                // 2.3 添加覆盖层数据模型到地图上
                self.mapView.addOverlay(circle2)

                // 3 大头针
                let annotation: MKPointAnnotation = MKPointAnnotation()
                annotation.title = "上海"
                annotation.coordinate = (place?.first?.location?.coordinate)!
                self.mapView.addAnnotation(annotation)
                //self.mapView.showAnnotations([annotation], animated: true)


                //45. 调用获取导航线路数据信息的方法
                self.getRouteMessage(startLocation!, endCLPL: destination!)
            }
        }
    }
    
    // - 導航 -
    // MARK: - ① 根据两个地标，发送网络请求给苹果服务器获取导航数据，请求对应的行走路线信息
    func getRouteMessage(_ startCLPL: CLPlacemark, endCLPL: CLPlacemark) {
        // 建请求导航路线数据信息
        let request: MKDirections.Request = MKDirections.Request()

        // 创建起点:根据 CLPlacemark 地标对象创建 MKPlacemark 地标对象
        let sourceMKPL: MKPlacemark = MKPlacemark(placemark: startCLPL)
        request.source = MKMapItem(placemark: sourceMKPL)

        let endMKPL: MKPlacemark = MKPlacemark(placemark: endCLPL)
        request.destination = MKMapItem(placemark: endMKPL)

        request.transportType = .automobile

        // 1. 创建导航对象，根据请求，获取实际路线信息
        let directions: MKDirections = MKDirections(request: request)

        // 2. 调用方法, 开始发送请求,计算路线信息
        directions.calculate { (response: MKDirections.Response?, error:Error?) in

            if let error = error {
                print("MKDirections.calculate err = \(error)")
            }

            if let response = response {
                print(response)

                // MARK: - ② 解析导航数据
                // 遍历 routes （MKRoute对象）：因为有多种路线
                for route: MKRoute in response.routes {

                    // 添加覆盖层数据模型,路线对应的几何线路模型（由很多点组成）
                    // 当我们添加一个覆盖层数据模型时, 系统绘自动查找对应的代理方法, 找到对应的覆盖层"视图"
                    // 添加折线
                    self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)

                    print(route.advisoryNotices)
                    print(route.name, route.distance, route.expectedTravelTime)
                    // 遍历每一种路线的每一个步骤（MKRouteStep对象）
                    for step in route.steps {
                        print(step.instructions) // 打印步骤说明
                    }
                }
            }
        }
    }

    // MARK: - ③ 添加导航路线到地图
    // MARK: - 当添加一个覆盖层数据模型到地图上时, 地图会调用这个方法, 查找对应的覆盖层"视图"(渲染图层)
    // 参数1（mapView）：地图    参数2（overlay）：覆盖层"数据模型"   returns: 覆盖层视图
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        var resultRender = MKOverlayRenderer()

        // 折线覆盖层
        if overlay is MKPolyline{

            // 创建折线渲染对象 (不同的覆盖层数据模型, 对应不同的覆盖层视图来显示)
            let render: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)

            render.lineWidth = 6                // 设置线宽
            render.strokeColor = UIColor.systemBlue    // 设置颜色

            resultRender = render

        }else if overlay is MKCircle {
            // 圆形覆盖层
            let circleRender: MKCircleRenderer = MKCircleRenderer(overlay: overlay)

            circleRender.fillColor = UIColor.lightGray // 设置填充颜色
            circleRender.alpha = 0.3               // 设置透明色
            circleRender.strokeColor = UIColor.blue
            circleRender.lineWidth = 2

            resultRender = circleRender
        }
        return resultRender
    }
}

extension HomeViewController: PetFilterDelegate {
    func showPetCategory(_ cell: HomeFilterCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if indexPath.item == 1 {
            let presentVC = UIStoryboard.popup.instantiateViewController(identifier: SinaLikePopupViewController.identifier) as? SinaLikePopupViewController
            presentVC?.selectedPet = { (title) in
                cell.filterBtn.setTitle(title, for: .normal)
                let allAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(allAnnotations)
                self.createAnnotations(locations: self.cafeList, petType: title)
            }
            presentVC?.modalPresentationStyle = .overFullScreen
            self.present(presentVC!, animated: false, completion: nil)
        }
    }
}
