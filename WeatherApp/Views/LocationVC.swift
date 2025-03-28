//
//  LocationVC.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 18.03.2025.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

protocol SetLocation {
    func setLocation(lan: Double,lon: Double)
}

class LocationVC: UIViewController, CLLocationManagerDelegate {
    
    var delegate: SetLocation?
    let locationManager = CLLocationManager()
    
    //MARK: UI Elements
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchTextField.textColor = .lightGray
        bar.tintColor = .white
        bar.searchTextField.font = UIFont(name: "Avenir",
                                          size: 16)
        bar.backgroundColor = UIColor(named: "Darkgray2")
        bar.searchBarStyle = .minimal
        bar.layer.cornerRadius = 35
        bar.layer.borderColor = UIColor.lightGray.cgColor
        bar.layer.borderWidth = 1
        bar.showsCancelButton = false
        return bar
    }()
    
    let currentBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "location 1")?.withRenderingMode(.alwaysOriginal),
                     for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(currentLocation(_:)), for: .touchUpInside)
        return btn
    }()
    
    let map: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.tintColor = UIColor(named: "Darkgray2")
        map.backgroundColor = UIColor(named: "Darkgray2")
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    let placeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Color 1")
        view.layer.cornerRadius = 35
        view.isHidden = true
        return view
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        return stack
    }()
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "location")?.withRenderingMode(.alwaysOriginal))
        image.contentMode = .center
        return image
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir", size: 20)
        return label
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?
            .withTintColor(.white,
                           renderingMode: .alwaysOriginal),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(backButtonAction(_:)))
        let label = UILabel()
        label.text = "Search For City"
        label.textColor = .white
        label.font = UIFont(name: "Avenir",
                            size: 20)
        navigationItem.titleView = label
        navigationController?.navigationBar.isTranslucent = true
        view.backgroundColor = UIColor(named: "Darkgray")
        setupViews()
        setupConstraints()
    }
    
    //MARK: Setup Methods
    func setupViews(){
        view.addSubview(map)
        map.delegate = self
        view.addSubview(searchBar)
        searchBar.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 50,
                                               height: self.searchBar.searchTextField.frame.height))
        paddingView.backgroundColor = .blue
        searchBar.searchTextField.leftView = paddingView
        searchBar.searchTextField.leftViewMode = .always
//        searchBar.setImage(UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        view.addSubview(currentBtn)
        view.addSubview(placeView)
        placeView.addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(locationLabel)
        locationManager.delegate = self
    }
    
    func setupConstraints(){
        map.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(120)
            make.height.equalTo(70)
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(230)
            make.width.height.equalTo(40)
        }
        placeView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(100)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        image.snp.makeConstraints { make in
            make.width.equalTo(35)
        }
        locationLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    //MARK: Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text else { return }
        searchBar.resignFirstResponder()
        findLocation(locationName: location,
                     location: nil)
    }
    
    func findLocation(locationName: String?, location: CLLocation?){
        placeView.isHidden = false
        let geocoder = CLGeocoder()
        if let locationname = locationName {
            geocoder.geocodeAddressString(locationname,
                                          in: nil,
                                          preferredLocale: Locale(identifier: "en_US")) { placemark, error in
                guard error == nil,
                      let placemarkfirst = placemark?.first else {
                    print(error?.localizedDescription)
                    return
                }
                self.pickLocation(placemark: placemarkfirst)
            }
        }else if let locationn = location{
            geocoder.reverseGeocodeLocation(locationn, preferredLocale: Locale(identifier: "en_US")) { placemark, error in
                guard error == nil,
                      let placemarkfirst = placemark?.first else {
                    print(error?.localizedDescription)
                    return
                }
                self.pickLocation(placemark: placemarkfirst)
            }
        }
    }
    
    func pickLocation(placemark: CLPlacemark){
        if let center = (placemark.region as? CLCircularRegion)?.center,
           let city = placemark.locality{
            let region = MKCoordinateRegion(center: center,
                                            span: MKCoordinateSpan(latitudeDelta: 0.1,
                                                                   longitudeDelta: 0.1))
            self.map.setRegion(region,
                               animated: true)
            self.locationLabel.text = city
            if let first = self.map.annotations.first {
                self.map.removeAnnotation(first)
            }
            
            self.addAnnotation(latitude: center.latitude,
                               longitude: center.longitude,
                               title: city)
            self.delegate?.setLocation(lan: center.latitude,
                                       lon: center.longitude)
        }
    }
    
    func addAnnotation(latitude: Double,
                       longitude: Double,
                       title: String){
        let cllocation = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = cllocation
        annotation.title = title
        self.map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            findLocation(locationName: nil,
                         location: location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    //MARK: Actions
    @objc func backButtonAction(_ sender: UIButton){
        dismiss(animated: true)
    }
    
    
    @objc func currentLocation(_ sender: UIButton){
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

//MARK: Delegates
extension LocationVC: UISearchBarDelegate,
                      MKMapViewDelegate {
    
}
