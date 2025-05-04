//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import UIKit
import SnapKit
import CoreLocation
import Kingfisher

class WeatherViewController: UIViewController, SetLocation, OpenClose{
    
    
    //MARK: - Properties
    private var weatherViewModel = WeatherViewModel()
    private var forecastWeather: ForecastWeatherModel?
    private var historyWeather: HistoryWeatherModel?
    private var hourlyWeather: [HourlyWeather]?
    private var forecastExceptToday: [ForecastDay]?
    private var selectedIndexPath: IndexPath?
    private let locationManager = CLLocationManager()
    private var forecastHeightConstraint: Constraint?
    private var isForecastExpanded = false
    
    enum SnapPosition {
        static let collapsedHeight: CGFloat = UIScreen.main.bounds.height / (2.4)
        static let expandedHeight: CGFloat = UIScreen.main.bounds.height / (1.5)
    }
    
    //MARK: - UI Elements
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
    
    private let locationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "location"),
                        for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.imagePadding = 5
        button.configuration = configuration
        button.addTarget(self,
                         action: #selector(goToMap),
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
    
    private let weatherButton: UIButton = {
        let button = UIButton()
        button.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.contentInsets = .zero
        button.contentHorizontalAlignment = .leading
        button.configuration = configuration
        return button
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
    
    private let maxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"),
                        for: .normal)
        button.tintColor = .lightGray
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.imagePadding = 3
        button.configuration = configuration
        return button
    }()
    
    private let minButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down"),
                        for: .normal)
        button.tintColor = .lightGray
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.imagePadding = 3
        button.configuration = configuration
        return button
    }()
    
    private let forecastView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView2: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = false
        return scroll
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 17
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = UIFont(name: "Avenir",
                            size: 17)
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
        collection.isScrollEnabled = true
        return collection
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Setup Methods
    private func setupViews(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        view.backgroundColor = UIColor(named: "Color")
        view.addSubview(imageView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(locationButton)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd HH:mm"
        let date = dateFormatter.string(from: Date())
        dateLabel.text = "Today, \(date)"
        stackView.addArrangedSubview(dateLabel)
        
        stackView.addArrangedSubview(temperatureLabel)
        
        view.addSubview(degreeLabel)
        
        view.addSubview(weatherButton)
        
        view.addSubview(shortWeatherView)
        shortWeatherView.addSubview(stackVieww)
        stackVieww.addArrangedSubview(maxButton)
        stackVieww.addArrangedSubview(minButton)
        
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
        forecastView.addSubview(scrollView2)
        
        scrollView2.addSubview(stackView2)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        lineImage.isUserInteractionEnabled = true
        lineImage.addGestureRecognizer(tap)
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
    
    private func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(40)
            make.height.equalTo(465)
        }
        locationButton.snp.makeConstraints { make in
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
        maxButton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
        }
        minButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        weatherButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalToSuperview().multipliedBy(1.85)
            make.centerY.equalToSuperview().multipliedBy(0.3)
        }
        todayYesterdayCollection.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        todayCollection.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        forecastView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            forecastHeightConstraint = make.height.equalTo(SnapPosition.collapsedHeight).constraint
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
            make.height.equalTo(SnapPosition.collapsedHeight)
        }
    }
    
    // MARK: - Data Fetching
    
    private func getData(lan: Double,
                         lon: Double){
        let date = getYesterdayDateString()
        Task {
            await fetchWeatherData(lan: lan,
                                   lon: lon,
                                   date: date)
            updateUI()
        }
    }
    
    private func fetchWeatherData(lan: Double,
                                  lon: Double,
                                  date: String) async {
        do {
            forecastWeather = try await weatherViewModel.getForecastWeather(lan: lan,
                                                                            lon: lon)
            historyWeather = try await weatherViewModel.getHistoryWeather(lan: lan,
                                                                          lon: lon,
                                                                          dt: date)
        } catch {
            print("Weather info didn't get: \(error)")
        }
    }
    
    // MARK: - Date Helpers
    
    private func getYesterdayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day,
                                              value: -1,
                                              to: Date())!
        return dateFormatter.string(from: yesterday)
    }
    
    private func getTodayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        guard let forecast = forecastWeather,
              let current = forecast.current,
              let conditionText = current.condition?.text,
              let conditionIcon = current.condition?.iconURL,
              let location = forecast.location,
              let todayForecast = forecast.forecast?.forecastday?.first?.day else { return }
        
        if let name = location.name,
           let country = location.country {
            updateLocationInfo(city: name,
                               country: country)
            updateTemperatureInfo(tempC: current.tempC,
                                  maxTemp: todayForecast.maxtempC,
                                  minTemp: todayForecast.mintempC)
            updateWeatherCondition(text: conditionText,
                                   url: conditionIcon)
            configureHourlyWeather()
            configureForecastWeather()
        }
    }
    
    // MARK: - Location Info Update
    
    private func updateLocationInfo(city: String,
                                    country: String) {
        locationButton.setTitle("\(city), \(country)",
                                for: .normal)
    }
    
    // MARK: - Temperature Info Update
    
    private func updateTemperatureInfo(tempC: Double?,
                                       maxTemp: Double?,
                                       minTemp: Double?) {
        guard let tempC = tempC,
              let max = maxTemp,
              let min = minTemp else { return }
        temperatureLabel.text = "\(Int(tempC))"
        adjustDegreeLabelPosition(for: tempC)
        gradientLabel(label: temperatureLabel)
        gradientLabel(label: degreeLabel)
        let attributes : [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13),
                                                          .foregroundColor: UIColor.white]
        maxButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(Int(max))°",
                                                                                       attributes: attributes))
        minButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(Int(min))°",
                                                                                       attributes: attributes))
    }
    
    private func adjustDegreeLabelPosition(for temperature: Double) {
        if Int(temperature) < 0 || abs(temperature) >= 10 {
            degreeLabel.snp.updateConstraints { make in
                make.leading.equalTo(temperatureLabel).inset(175)
            }
        } else {
            degreeLabel.snp.updateConstraints { make in
                make.leading.equalTo(temperatureLabel).inset(75)
            }
        }
    }
    
    // MARK: - Weather Condition Update
    
    private func updateWeatherCondition(text: String, url: URL) {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 16),
                                                         .foregroundColor: UIColor.white]
        weatherButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: text,
                                                                                           attributes: attributes))
        weatherButton.kf.setImage(with: url,
                                  for: .normal)
        
    }
    
    // MARK: - Configure Collections
    
    private func configureHourlyWeather() {
        guard let hours = forecastWeather?.forecast?.forecastday?.first?.hour else { return }
        
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentTimeString = dateFormatter.string(from: currentDateTime)
        
        hourlyWeather = hours.filter { $0.time! > currentTimeString }
        
        if let nextDayHours = forecastWeather?.forecast?.forecastday?[1].hour,
           hourlyWeather!.count < 12 {
            let missingCount = 12 - hourlyWeather!.count
            for i in 0..<missingCount {
                hourlyWeather?.append(nextDayHours[i])
            }
        }
        
        hourlyCollection.reloadData()
        todayYesterdayCollection.reloadData()
        todayCollection.reloadData()
    }
    
    private func configureForecastWeather() {
        forecastExceptToday = forecastWeather?.forecast?.forecastday
        let todayDate = getTodayDateString()
        forecastExceptToday = forecastExceptToday?.filter { $0.date != todayDate }
        
        forecastCollection.reloadData()
    }
    
    private func attributedTextStyle() -> [NSAttributedString.Key: Any] {
        return [.font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.white]
    }
    
    private func addSeparator(to cell: UICollectionViewCell, topPadding: CGFloat){
        let seperator = CALayer()
        seperator.backgroundColor = UIColor.lightGray.cgColor
        seperator.frame = CGRect(x: cell.bounds.width - 1, y: topPadding, width: 1, height: cell.bounds.height - 2 * topPadding )
        cell.layer.addSublayer(seperator)
    }
    // MARK: - Public Methods
    
    func setLocation(lan: Double,
                     lon: Double) {
        getData(lan: lan,
                lon: lon)
    }
    
    func openClose(indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        forecastCollection.performBatchUpdates({
            forecastCollection.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
    func gradientLabel(label: UILabel) {
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
    
    //MARK: - Actions
    @objc func goToMap(_ sender: UIButton){
        let lvc = LocationViewController()
        lvc.delegate = self
        let nvc = UINavigationController(rootViewController: lvc)
        nvc.isModalInPresentation = true
        nvc.modalPresentationStyle = .fullScreen
        present(nvc,
                animated: true)
    }
    
    @objc private func handleTap() {
        isForecastExpanded.toggle()
        var newHeight: CGFloat
        switch isForecastExpanded{
        case false:
            newHeight = SnapPosition.collapsedHeight
            shortWeatherView.isHidden = true
        case true:
            newHeight = SnapPosition.expandedHeight
            shortWeatherView.isHidden = false
        }
        forecastHeightConstraint?.update(offset: newHeight)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Delegates
extension WeatherViewController: UICollectionViewDelegate,
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
            
            guard let max = forecastWeather?.forecast?.forecastday?[0].day?.maxtempC,
                  let min = forecastWeather?.forecast?.forecastday?[0].day?.mintempC else {
                return cell
            }
            
            let attributes = attributedTextStyle()
            cell.maxButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(Int(max))°",
                                                                                                attributes: attributes))
            cell.minButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(Int(min))°",
                                                                                                attributes: attributes))
            
            if indexPath.row == 0 {
                cell.label.text = "Today"
                addSeparator(to: cell,
                             topPadding: 15)
            } else if indexPath.row == 1 {
                cell.label.text = "Yesterday"
            }
            
            return cell
            
        } else if collectionView == hourlyCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell",
                                                          for: indexPath) as! HourlyCollectionViewCell
            
            if let hourly = hourlyWeather?[indexPath.row],
               let time = hourly.time,
               let tempC = hourly.tempC,
               let url = hourly.condition?.iconURL {
                
                let hourText = time.components(separatedBy: " ").last ?? time
                cell.hourLabel.text = hourText
                cell.temperatureLabel.text = "\(Int(tempC))°"
                cell.weatherImage.kf.setImage(with: url)
            }
            return cell
            
        } else if collectionView == forecastCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell",
                                                          for: indexPath) as! ForecastCollectionViewCell
            
            if let forecast = forecastExceptToday?[indexPath.row] {
                cell.forecastDay = forecast
                cell.delegate = self
                cell.indexPath = indexPath
                
                if let max = forecast.day?.maxtempC,
                   let min = forecast.day?.mintempC,
                   let url = forecast.day?.condition?.iconURL {
                    
                    cell.maxButton.setTitle("\(Int(max))°",
                                            for: .normal)
                    cell.minButton.setTitle("\(Int(min))°",
                                            for: .normal)
                    cell.weatherIcon.kf.setImage(with: url)
                }
                
                if indexPath.row == 0 {
                    cell.tomorrowLabel.text = "Tomorrow"
                } else if let dateStr = forecast.date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if let date = formatter.date(from: dateStr) {
                        formatter.dateFormat = "EEEE, dd MMM"
                        cell.tomorrowLabel.text = formatter.string(from: date)
                    }
                }
                
                if let text = forecast.day?.condition?.text {
                    let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]
                    cell.weatherButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: text, attributes: attr))
                }
                
                cell.stackView3.isHidden = (selectedIndexPath != indexPath)
            }
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
        let attributes = attributedTextStyle()
        
        switch indexPath.row {
        case 0:
            if let rainChance = forecastWeather?.forecast?.forecastday?[0].day?.dailyChanceOfRain {
                cell.label.text = "Slight chance of rain"
                cell.button.setImage(UIImage(named: "drop")?.withRenderingMode(.alwaysOriginal), for: .normal)
                cell.button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(rainChance) %", attributes: attributes))
                addSeparator(to: cell, topPadding: 45)
            }
        case 1:
            if let wind = forecastWeather?.current?.windKph {
                cell.label.text = "Gentle breeze now"
                cell.button.setImage(UIImage(systemName: "arrow.up.right"), for: .normal)
                cell.button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(Int(wind)) km/h", attributes: attributes))
                addSeparator(to: cell, topPadding: 45)
            }
        case 2:
            if let uv = forecastWeather?.current?.uv {
                cell.label.text = "Low sunburn risk today"
                cell.button.setImage(UIImage(systemName: "sun.min.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal), for: .normal)
                cell.button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "UVI \(Int(uv))", attributes: attributes))
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            getData(lan: latitude, lon: longitude)
            locationManager.stopUpdatingLocation()
        }
    }
}
