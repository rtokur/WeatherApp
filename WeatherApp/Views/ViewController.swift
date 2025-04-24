//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import UIKit
import SnapKit
import CoreLocation

class ViewController: UIViewController, SetLocation, OpenClose {
    
    //MARK: Properties
    var weatherViewModel = WeatherViewModel()
    var forecastWeather: ForecastWeatherModel?
    var historyWeather: HistoryWeatherModel?
    var hourlyWeather: [HourlyWeather]?
    var forecastExceptToday: [ForecastDay]?
    var selectedIndexPath: IndexPath?
    let locationManager = CLLocationManager()
    
    //MARK: UI Elements
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.spacing = 10
        return stack
    }()
    
    private let locationBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white,
                             for: .normal)
        button.setImage(UIImage(named: "location"),
                        for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .leading
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 0,
                                              right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 10,
                                              bottom: 0,
                                              right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
        button.titleLabel?.font = UIFont(name: "Avenir",
                                         size: 25)
        button.addTarget(self,
                         action: #selector(goToMap(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir",
                            size: 12)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir",
                            size: 150)
        return label
    }()
    
    private let degreeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "°C"
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir",
                            size: 50)
        return label
    }()
    
    private let weatherBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white,
                          for: .normal)
        btn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.contentHorizontalAlignment = .right
        btn.imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 10)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        return btn
    }()
    
    private let shortWeatherView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 22.5
        return view
    }()
    
    private let todayYesterdayCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.layer.borderColor = UIColor.lightGray.cgColor
        collection.layer.borderWidth = 1
        collection.layer.cornerRadius = 25
        return collection
    }()
    
    private let todayCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.layer.borderColor = UIColor.lightGray.cgColor
        collection.layer.borderWidth = 1
        collection.layer.cornerRadius = 40
        return collection
    }()
    
    private let stackVieww: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let maxBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.up"),
                     for: .normal)
        btn.tintColor = .lightGray
        btn.imageEdgeInsets.left = 5
        btn.titleEdgeInsets.left = 15
        return btn
    }()
    
    private let minBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.down"),
                     for: .normal)
        btn.tintColor = .lightGray
        btn.imageEdgeInsets.left = 5
        btn.titleEdgeInsets.left = 15
        return btn
    }()
    
    private let forecastView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView2: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 17
        return stack
    }()
    
    private let lineImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "line")?.withTintColor(.lightGray,
                                                                             renderingMode: .alwaysOriginal))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let labell: UILabel = {
        let label = UILabel()
        label.text = "Hourly Forecast"
        label.textColor = .black
        label.font = UIFont(name: "Avenir", size: 17)
        return label
    }()
    
    private let hourlyCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        return collection
    }()
    
    private let tomorrowLabel: UILabel = {
        let label = UILabel()
        label.text = "Tomorrow"
        label.textColor = .black
        label.font = UIFont(name: "Avenir",
                            size: 17)
        return label
    }()
    
    private let forecastCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        return collection
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Setup Methods
    func setupViews(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        view.backgroundColor = UIColor(named: "Color")
        view.addSubview(imageView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(locationBtn)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd HH:mm"
        let date = dateFormatter.string(from: Date())
        dateLabel.text = "Today, \(date)"
        stackView.addArrangedSubview(dateLabel)
        
        stackView.addArrangedSubview(temperatureLabel)
        
        view.addSubview(degreeLabel)
        
        view.addSubview(weatherBtn)
        
        view.addSubview(shortWeatherView)
        shortWeatherView.addSubview(stackVieww)
        stackVieww.addArrangedSubview(maxBtn)
        stackVieww.addArrangedSubview(minBtn)
        
        todayYesterdayCollection.delegate = self
        todayYesterdayCollection.dataSource = self
        todayYesterdayCollection.register(TodayYesterdayCollectionViewCell.self,
                                          forCellWithReuseIdentifier: "TodayYesterdayCollectionViewCell")
        stackView.addArrangedSubview(todayYesterdayCollection)
        
        todayCollection.delegate = self
        todayCollection.dataSource = self
        todayCollection.register(TodayCollectionViewCell.self,
                                 forCellWithReuseIdentifier: "TodayCollectionViewCell")
        stackView.addArrangedSubview(todayCollection)
        
        view.addSubview(forecastView)
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePan(_:)))
        forecastView.addGestureRecognizer(panGesture)
        
        forecastView.addSubview(scrollView2)
        
        scrollView2.addSubview(stackView2)
        
        view.addSubview(lineImage)
        
        stackView2.addArrangedSubview(labell)
        
        hourlyCollection.delegate = self
        hourlyCollection.dataSource = self
        hourlyCollection.register(HourlyCollectionViewCell.self,
                                  forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        stackView2.addArrangedSubview(hourlyCollection)
        
        stackView2.addArrangedSubview(tomorrowLabel)
        
        forecastCollection.delegate = self
        forecastCollection.dataSource = self
        forecastCollection.register(ForecastCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        stackView2.addArrangedSubview(forecastCollection)
    }
    
    func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(40)
            make.height.equalTo(465)
        }
        locationBtn.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(155)
        }
        degreeLabel.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(temperatureLabel)
            make.leading.equalTo(temperatureLabel).inset(155)
        }
        shortWeatherView.snp.makeConstraints { make in
            make.top.equalTo(220)
            make.leading.equalTo(225)
            make.height.equalTo(45)
            make.width.equalTo(150)
        }
        stackVieww.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        maxBtn.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
        }
        minBtn.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        weatherBtn.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalToSuperview().multipliedBy(1.85)
            make.centerY.equalToSuperview().multipliedBy(0.45)
        }
        todayYesterdayCollection.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        todayCollection.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        forecastView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView2.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(scrollView2.contentLayoutGuide)
            make.width.equalTo(scrollView2.frameLayoutGuide)
        }
        lineImage.snp.makeConstraints { make in
            make.top.equalTo(forecastView).inset(5)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        labell.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(lineImage.snp.bottom)
        }
        hourlyCollection.snp.makeConstraints { make in
            make.height.equalTo(107)
        }
        tomorrowLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        forecastCollection.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    //MARK: Functions
    func getData(lan: Double, lon: Double){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day,
                                              value: -1,
                                              to: Date())!
        let date = dateFormatter.string(from: yesterday)
        Task{
            forecastWeather = try await weatherViewModel.getForecastWeather(lan: lan,
                                                                            lon: lon)
            historyWeather = try await weatherViewModel.getHistoryWeather(lan: lan,
                                                                          lon: lon,
                                                                          dt: date)
            if let tempC = forecastWeather?.current?.tempC as? Double,
               let weathertext = forecastWeather?.current?.condition?.text as? String,
               let city = forecastWeather?.location?.name as? String,
               let country = forecastWeather?.location?.country as? String,
               let max = forecastWeather?.forecast?.forecastday?[0].day?.maxtempC as? Double,
               let min = forecastWeather?.forecast?.forecastday?[0].day?.mintempC as? Double{
                locationBtn.setTitle("\(city), \(country)",
                                     for: .normal)
                temperatureLabel.text = "\(Int(tempC))"
                if Int(tempC)<0 && abs(tempC) >= 10{
                    degreeLabel.snp.updateConstraints { make in
                        make.leading.equalTo(temperatureLabel).inset(225)
                    }
                }
                else if Int(tempC) < 10 && Int(tempC) >= 0 {
                    degreeLabel.snp.updateConstraints { make in
                        make.leading.equalTo(temperatureLabel).inset(75)
                    }
                }
                gradientLabel(label: temperatureLabel)
                gradientLabel(label: degreeLabel)

                weatherBtn.setTitle(weathertext,
                                    for: .normal)
                maxBtn.setTitle("\(Int(max))°",
                                for: .normal)
                minBtn.setTitle("\(Int(min))°",
                                for: .normal)
                var text2 = weathertext
                if text2.hasSuffix(" "){
                    text2.remove(at: text2.index(before: text2.endIndex))
                }
                if text2 == "Partly cloudy"{
                    weatherBtn.setImage(UIImage(named: "\(text2) 1")?.withTintColor(.white,
                                                                                          renderingMode: .alwaysOriginal),
                                        for: .normal)
                }else {
                    weatherBtn.setImage(UIImage(systemName: text2)?.withTintColor(.white,
                                                                                    renderingMode: .alwaysOriginal),
                                        for: .normal)
                }
                if let hours = forecastWeather?.forecast?.forecastday?[0].hour {
                    hourlyWeather = hours
                }
                let dateFormatterr = DateFormatter()
                dateFormatterr.dateFormat = "yyyy-MM-dd HH:mm"
                let date2 = dateFormatterr.string(from: Date())
                hourlyWeather = hourlyWeather?.filter{ $0.time! > date2}
                if hourlyWeather!.count < 12 {
                    let count = 12 - (hourlyWeather!.count)
                    if let hourr = forecastWeather?.forecast?.forecastday?[1].hour{
                        for i in 0..<count {
                            hourlyWeather?.append(hourr[i])
                        }
                    }
                }
                hourlyCollection.reloadData()
                todayYesterdayCollection.reloadData()
                todayCollection.reloadData()
                forecastExceptToday = forecastWeather?.forecast?.forecastday
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let datee = dateFormatter.string(from: Date())
                forecastExceptToday = forecastExceptToday?.filter { $0.date != datee }
                forecastCollection.reloadData()
                forecastCollection.snp.updateConstraints { make in
                    make.height.equalTo(self.forecastCollection.collectionViewLayout.collectionViewContentSize.height)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            getData(lan: latitude, lon: longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func setLocation(lan: Double, lon: Double){
        getData(lan: lan, lon: lon)
    }
    
    func gradientLabel(label: UILabel){
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = label.bounds
        gradiantLayer.colors = [UIColor.white.cgColor,
                                UIColor.clear.cgColor]
        gradiantLayer.startPoint = CGPoint(x: 0.5,
                                           y: 0.0)
        gradiantLayer.endPoint = CGPoint(x: 0.5,
                                         y: 1.0)
        
        label.layer.mask = gradiantLayer
    }
    
    func openClose(indexPath: IndexPath){
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        }else{
            selectedIndexPath = indexPath
        }
        forecastCollection.performBatchUpdates({
            forecastCollection.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
    //MARK: Actions
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        
    }

    
    @objc func goToMap(_ sender: UIButton){
        let lvc = LocationVC()
        lvc.delegate = self
        let nvc = UINavigationController(rootViewController: lvc)
        nvc.isModalInPresentation = true
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
}

//MARK: Delegates
extension ViewController: UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout,
                          CLLocationManagerDelegate{
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == todayYesterdayCollection {
            return 2
        } else if collectionView == hourlyCollection {
            return hourlyWeather?.count ?? 0
        } else if collectionView == forecastCollection {
            return forecastExceptToday?.count ?? 0
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == todayYesterdayCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayYesterdayCollectionViewCell",
                                                          for: indexPath) as! TodayYesterdayCollectionViewCell
            if indexPath.row == 0 {
                if let max = forecastWeather?.forecast?.forecastday?[0].day?.maxtempC as? Double,
                   let min = forecastWeather?.forecast?.forecastday?[0].day?.mintempC as? Double{
                    cell.label.text = "Today"
                    let maxInt = Int(max)
                    let minInt = Int(min)
                    cell.maxBtn.setTitle("\(maxInt)°",
                                         for: .normal)
                    cell.minBtn.setTitle("\(minInt)°",
                                         for: .normal)
                    let separatorLayer = CALayer()
                    separatorLayer.backgroundColor = UIColor.lightGray.cgColor
                    separatorLayer.frame = CGRect(x: cell.bounds.width - 1,
                                                  y: 15,
                                                  width: 1,
                                                  height: cell.bounds.height - 30)
                        
                    cell.layer.addSublayer(separatorLayer)
                }
            }else if indexPath.row == 1{
                if let max = historyWeather?.forecast?.forecastday?[0].day?.maxtempC as? Double,
                   let min = historyWeather?.forecast?.forecastday?[0].day?.mintempC as? Double {
                    cell.label.text = "Yesterday"
                    cell.maxBtn.setTitle("\(Int(max))°",
                                         for: .normal)
                    cell.minBtn.setTitle("\(Int(min))°",
                                         for: .normal)
                }
            }
            return cell
        }else if collectionView == hourlyCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell",
                                                          for: indexPath) as! HourlyCollectionViewCell
            if let time = hourlyWeather?[indexPath.row].time,
               let tempC = hourlyWeather?[indexPath.row].tempC,
               let text = hourlyWeather?[indexPath.row].condition?.text{
                let timee = time.components(separatedBy: " ")
                cell.hourLabel.text = timee[1]
                cell.temperatureLabel.text = "\(Int(tempC))°"
                var text2 = text
                if text2.hasSuffix(" "){
                    text2.remove(at: text2.index(before: text2.endIndex))
                }
                if text2 == "Partly cloudy"{
                    cell.weatherImage.image = UIImage(named: "\(text2) 1")?.withRenderingMode(.alwaysOriginal)
                }else {
                    cell.weatherImage.image = UIImage(named: "\(text2)")?.withRenderingMode(.alwaysOriginal)
                }
            }
            return cell
        }else if collectionView == forecastCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell",
                                                          for: indexPath) as! ForecastCollectionViewCell
            if let forecast = self.forecastExceptToday?[indexPath.row] {
                cell.forecastDay = forecast
            }
            cell.delegate = self
            cell.indexPath = indexPath
            if let max = forecastExceptToday?[indexPath.row].day?.maxtempC as? Double,
               let min = forecastExceptToday?[indexPath.row].day?.mintempC as? Double,
               let text = forecastExceptToday?[indexPath.row].day?.condition?.text as? String{
                cell.maxBtn.setTitle("\(Int(max))°",
                                     for: .normal)
                cell.minBtn.setTitle("\(Int(min))°",
                                     for: .normal)
                var text2 = text
                if text2.hasSuffix(" "){
                    text2.remove(at: text2.index(before: text2.endIndex))
                }
                if text2 == "Partly cloudy"{
                    cell.weatherIcon.image = UIImage(named: "\(text2) 1")?.withRenderingMode(.alwaysOriginal)
                }else {
                    cell.weatherIcon.image = UIImage(named: "\(text2)")?.withRenderingMode(.alwaysOriginal)
                }
            }
            if indexPath.row == 0 {
                cell.tomorrowLabel.text = "Tomorrow"
            } else {
                if let date = forecastExceptToday?[indexPath.row].date as? String {
                    let date2 = DateFormatter()
                    date2.dateFormat = "yyyy-MM-dd"
                    let datee = date2.date(from: date)!
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "EEEE, dd MMM"
                    let date3 = dateFormat.string(from: datee)
                    cell.tomorrowLabel.text = "\(date3)"
                }
            }
            if let text = forecastExceptToday?[indexPath.row].day?.condition?.text as? String {
                cell.weatherBtn.setTitle(text,
                                         for: .normal)
            }
            if selectedIndexPath == indexPath {
                cell.stackView3.isHidden = false
            }else{
                cell.stackView3.isHidden = true
            }
            cell.weatherBtn.titleEdgeInsets.left = 1
            cell.weatherBtn.imageEdgeInsets.right = 1
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell",
                                                      for: indexPath) as! TodayCollectionViewCell
        switch indexPath.row {
        case 0:
            if let chanceOfRain = forecastWeather?.forecast?.forecastday?[0].day?.dailyChanceOfRain as? Int{
                cell.label.text = "Slight chance of rain"
                cell.button.setImage(UIImage(named: "raindrop")?.withRenderingMode(.alwaysOriginal),
                                     for: .normal)
                cell.button.setTitle("\(chanceOfRain)%",
                                     for: .normal)
                
                let separatorLayer = CALayer()
                separatorLayer.backgroundColor = UIColor.lightGray.cgColor
                separatorLayer.frame = CGRect(x: cell.bounds.width - 1,
                                              y: 45,
                                              width: 1,
                                              height: cell.bounds.height - 90)
                    
                cell.layer.addSublayer(separatorLayer)
            }
        case 1:
            if let wind = forecastWeather?.current?.windKph as? Double{
                cell.label.text = "Gentle breeze now"
                cell.button.setImage(UIImage(systemName: "arrow.up.right"),
                                     for: .normal)
                cell.button.setTitle("\(Int(wind)) km/h",
                                     for: .normal)
                let separatorLayer = CALayer()
                separatorLayer.backgroundColor = UIColor.lightGray.cgColor
                separatorLayer.frame = CGRect(x: cell.bounds.width - 1,
                                              y: 45,
                                              width: 1,
                                              height: cell.bounds.height - 90)
                    
                cell.layer.addSublayer(separatorLayer)
            }
        case 2:
            if let uv = forecastWeather?.current?.uv as? Double{
                cell.label.text = "Low sunburn risk today"
                cell.button.setImage(UIImage(systemName: "sun.min.fill")?.withTintColor(.systemYellow,
                                                                                        renderingMode: .alwaysOriginal),
                                     for: .normal)
                cell.button.setTitle("UVI \(Int(uv))",
                                     for: .normal)
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == forecastCollection {
            let width = collectionView.frame.width
            if indexPath == selectedIndexPath {
                return CGSize(width: width,
                              height: 400)
            }else{
                return CGSize(width: width,
                              height: 100)
            }
            
        }else if collectionView == todayYesterdayCollection {
            let width = collectionView.frame.width / 2
            return CGSize(width: width,
                          height: 50)
        }else if collectionView == todayCollection {
            let width = collectionView.frame.width / 3
            return CGSize(width: width,
                          height: 130)
        }
        return CGSize(width: 55,
                      height: 107)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == forecastCollection {
            if selectedIndexPath == indexPath {
                selectedIndexPath = nil
            }else{
                selectedIndexPath = indexPath
            }
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)

        }
    }
}
