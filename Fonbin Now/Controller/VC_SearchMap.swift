//
//  VC_SearchMap.swift
//  Business Search Solution
//
//  Created by Sarmad Ashfaq on 2/4/1399 AP.
//  Copyright © 1399 Softgear. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds
import DropDown

class VC_SearchMap: UIViewController  , UITextFieldDelegate {
    
    //MARK:-IBoutlets

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var onlineSwitch: UISwitch!
    @IBOutlet weak var lblGoOnline: UILabel!
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        return label
    }()
    let subtitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Testing for description"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let ilabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "I"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let Olabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "O"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageView:UIImageView = {
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    lazy var NavigateButton : UIButton = {
        let button = UIButton()
        button.setTitle("Navigate", for: .normal)
        button.setTitleColor(.appBlack, for: .normal)
        button.backgroundColor = .appRed
        button.addTarget(self, action: #selector(navigateButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let bottomContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var favButton : UIButton = {
       let button = UIButton()
        button.setTitle("Following", for: .selected)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(favButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let blurView : UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView()
        adBannerView.alpha = 0
        adBannerView.backgroundColor = .white
        adBannerView.delegate = self
        adBannerView.adUnitID = Constant.adMobsId
        adBannerView.rootViewController = self
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        return adBannerView
    }()
    //MARK:-Properties
    var locationManager = CLLocationManager()
    var menuVC: Menu_VC!
    var storeData = [locationDataModel]()
    var filteredStoreData = [locationDataModel]()
    var storeUUID: String = ""
    var currentLocation = CLLocationCoordinate2D()
    var navigationLatlong = CLLocationCoordinate2D()
    var showCurrentLocation : Bool = false
    lazy var dropDown : DropDown = {
       let dropdown = DropDown()
        dropdown.anchorView = searchBar
        dropdown.dismissMode = .onTap
        return dropdown
    }()
    
    //MARK:-ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.searchTextField.backgroundColor = .black
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.returnKeyType = .default
        searchBar.delegate = self
        searchBar.searchTextField.changePlaceHolder(PlaceHoldertxt: "Search Store", Color: UIColor.Primary_Blue)
        DesignStatusBar()
        addRightBarButton()
        initLocationManager()
        addLeftNavButton()
        SideMenuGesture()
        menuVC = self.storyboard?.instantiateViewController(withIdentifier: "Menu_VC") as? Menu_VC
        navigationItem.title = "Fonbin"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupViews()
        getAllOnlineStores()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideBlurView))
        blurView.isUserInteractionEnabled = true
        tapGesture.delegate = self
        blurView.addGestureRecognizer(tapGesture)
        adBannerView.load(GADRequest())
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkDataforNotificationStore),
            name: Notification.Name(Constant.storeIdNotification),
            object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDataforNotificationStore()
        menuClose()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func setupViews(){
        view.addSubview(blurView)
        
        blurView.addSubview(bottomContainer)
        bottomContainer.addSubview(imageView)
        bottomContainer.addSubview(titleLabel)
        bottomContainer.addSubview(subtitleLabel)
        bottomContainer.addSubview(favButton)
        bottomContainer.addSubview(NavigateButton)
        view.addSubview(adBannerView)
        let spacing:CGFloat = 8.0
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: adBannerView.topAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 300),
            
            imageView.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: spacing),
            imageView.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: spacing),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),

            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: spacing * 2),
            titleLabel.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor, constant: -spacing),

            subtitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            subtitleLabel.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: spacing),
            subtitleLabel.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor, constant: -spacing),

            favButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor ,constant:  20),
            favButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor ,constant:  -20),
            
            NavigateButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            NavigateButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            NavigateButton.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
            NavigateButton.heightAnchor.constraint(equalToConstant: 50),
            
            adBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adBannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            adBannerView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func DesignStatusBar(){
         let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
         let statusBarColor = UIColor.white
         statusBarView.backgroundColor = statusBarColor
         view.addSubview(statusBarView)
     }
    func addLeftNavButton(){
        let newBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(LeftMenu))
        self.navigationItem.hidesBackButton = true
        newBtn.setBackgroundImage(UIImage(named: "sideManuIcon")?.withTintColor(.white), for: .normal, barMetrics: .default)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
    }

    //MARK:- Side Menu
    func SideMenuGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(response(gesture:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(response(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func response(gesture : UISwipeGestureRecognizer){
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            print("swipe Right")
            menuShow()
        case UISwipeGestureRecognizer.Direction.left:
            print("swipe Left")
            closeOnSwipe()
        default:
            break
        }
    }
    func closeOnSwipe(){
        if AppDelegate.menuBool {
            //menuShow()
        }
        else {
            menuClose()
        }
    }
    func menuShow(){

        UIView.animate(withDuration: 0.3) {
            self.menuVC.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.addChild(self.menuVC)
            self.view.addSubview(self.menuVC.view)
            AppDelegate.menuBool = false
        }
    }
    func menuClose(){
        UIView.animate(withDuration: 0.5, animations: {
            self.menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            self.menuVC.view.removeFromSuperview()
        }
        AppDelegate.menuBool = true
    }
    
    @objc func LeftMenu(){
        if AppDelegate.menuBool {
                menuShow()
            }
        else {
            menuClose()
            }
        }
    func addRightBarButton(){
        let righButton = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(openProfile))
        navigationItem.rightBarButtonItem = righButton
    }
    
    @objc func openProfile(){
        openVC("ProfileViewController")
    }
    @objc func favButtonPressed(_ sender: UIButton){
        
        if sender.isSelected == true {
            ApiManager.shared.removeFromFavList(storeUUID) { [weak self] message, error in
                if let message = message {
                    self?.showAlertView(message: message, title: "Alert")
                }
                if let error = error {
                    self?.showAlertView(message: error, title: "Alert")
                }
            }
        }else{
            ApiManager.shared.addToFavList(storeUUID) { [weak self] message, error in
                if let message = message {
                    self?.showAlertView(message: message, title: "Alert")
                }
                if let error = error {
                    self?.showAlertView(message: error, title: "Alert")
                }
            }
        }
        
        sender.isSelected = !sender.isSelected


    }
    
    @IBAction func goOnlineSwitchToggled(_ sender: UISwitch) {
        guard let user = DataManager().getUserData() else { return }
        showLoadingView()
        ApiManager.shared.goOnline(userId: user.userId, lat: currentLocation.latitude, long: currentLocation.longitude, isOnline: sender.isOn) { [weak self] message, error in
            self?.hideLoadingView()
            if let error = error {
                self?.showAlertView(message: error, title: "Alert")
            }
            if let message = message {
                
                if sender.isOn == false {
                    self?.showAlertView(message: message, title: "Offline")
                    return
                }else{
                    self?.showAlertView(message: message, title: "Online")
                }
                //get Fcm devices users
                ApiManager.shared.getFCMDeviceUsers { userlist in
                    if let userList = userlist {
                        ApiManager.shared.getUpdatedFCMSOFUsers(usersList: userList) { fcmList in
                            if let fcmlist = fcmList {
                                ApiManager.shared.broadcastFCM(fcmlist, "", String(format: "%@ %@", user.name.capitalized , "is online want to visit? tap to navigate!!!"), user.userId)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAllOnlineStores(){
        showLoadingView()
        ApiManager.shared.getStores { [weak self] storeData in
            self?.hideLoadingView()
            if let data = storeData {
                self?.storeData = data
                if let localUser = DataManager().getUserData() {
                    let userOnlineStatus = self?.storeData.filter({ data in
                        return data.userId == localUser.userId
                    })
                    if let user = userOnlineStatus {
                        if user.count > 0 {
                            if user.first!.isOnline == false {
                                self!.mapView.isMyLocationEnabled = true
                                self!.mapView.settings.myLocationButton = true
                                self?.onlineSwitch.isOn = false
                                self?.showCurrentLocation = true
                            }else{
                                self!.mapView.isMyLocationEnabled = false
                                self!.mapView.settings.myLocationButton = false
                                self?.onlineSwitch.isOn = user.first!.isOnline
                                self?.showCurrentLocation = false
                            }
                        }else{
                            self!.mapView.isMyLocationEnabled = true
                            self!.mapView.settings.myLocationButton = true
                            self?.onlineSwitch.isOn = false
                            self?.showCurrentLocation = true
                        }

                    }
                }
                
                let onlineStores = self?.storeData.filter({ data in
                    return data.isOnline == true
                })
                
                self?.showStoresOnMap(onlineStores ?? [])
            }
        }
    }
    func showStoresOnMap(_ storeData : [locationDataModel]){
            mapView.clear()
//       let localUser = DataManager().getUserData()
            for data in storeData {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
                marker.userData = data
                marker.map = mapView
                marker.icon = UIImage(named: "currentLocation")
                marker.setIconSize(scaledToSize: .init(width: 40, height: 40))
//                if data.userId == localUser?.userId ?? "" {
//                    marker.icon = UIImage(named: "currentLocation")
//                    marker.setIconSize(scaledToSize: .init(width: 40, height: 40))
//                }else{
//                    marker.icon = UIImage(named: "placeholder")
//                    marker.setIconSize(scaledToSize: .init(width: 40, height: 40))
//                }

            }
        
          locationManager.startUpdatingLocation()
        }
}


extension VC_SearchMap : CLLocationManagerDelegate , GMSMapViewDelegate , UIGestureRecognizerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
//            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }else{
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        currentLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let data = marker.userData as? locationDataModel {
         showAnotationData(data: data)
        }
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.blurView.alpha = 0
        }
    }
    
    func navigateToMap(coordinates: CLLocationCoordinate2D) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(coordinates.latitude),\(coordinates.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(coordinates.latitude),\(coordinates.longitude)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    func showAnotationData(data: locationDataModel){
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.blurView.alpha = 1
            self?.imageView.downloadImage(url: data.imageUrl)
            self?.titleLabel.text = data.name
            self?.subtitleLabel.text = data.bio
            self?.navigationLatlong = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
            self?.storeUUID = data.userId
        }
        ApiManager.shared.checkIfUserExistInFavList(storeUUID) { [weak self] exist in
            if exist {
                self?.favButton.isSelected = true
            }else{
                self?.favButton.isSelected = false
            }
        }
    }
    
    @objc func checkDataforNotificationStore(){
        if Constant.notificationStoreId != "" {
            showLoadingView()
            ApiManager.shared.getStoreData(Constant.notificationStoreId) {[weak self] data in
                self?.hideLoadingView()
                if let data = data {
                    self?.showAnotationDataForNotificationStore(data: data.first!)
                }
            }
        }
    }
    
    func showAnotationDataForNotificationStore(data: locationDataModel){
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.blurView.alpha = 1
            self?.imageView.downloadImage(url: data.imageUrl)
            self?.titleLabel.text = data.name
            self?.subtitleLabel.text = data.bio
            self?.navigationLatlong = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
            self?.storeUUID = data.userId
        }
    }
    @objc func hideBlurView(){
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.blurView.alpha = 0
        }
    }
    @objc func navigateButton(){
        navigateToMap(coordinates: navigationLatlong)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view?.isDescendant(of: blurView) == true {
            return true
        }
        if touch.view?.isDescendant(of: mapView) == true {
            return true
        }
        return false
    }
}

extension VC_SearchMap : GADBannerViewDelegate , UISearchBarDelegate{

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
    }
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
        
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStoreData = storeData.filter({ data in
            return data.name.lowercased().contains(searchText.lowercased()) || data.bio.lowercased().contains(searchText.lowercased())
        })
        var dataSource = [String]()
        dataSource.removeAll()
        for name in filteredStoreData {
            dataSource.append(name.name)
        }
        
        showDropDown(dataSource)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func showDropDown(_ dataSource: [String]){
        dropDown.dataSource = dataSource
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! - 10 )
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            let storeToshow = self?.storeData.filter { store in
                return store.name.lowercased().contains(item.lowercased())
            }
            self?.searchBar.searchTextField.text = ""
            if let store = storeToshow?.first {
                self?.showAnotationDataForNotificationStore(data: store)
            }
            
        }
    }
}
