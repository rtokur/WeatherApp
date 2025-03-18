//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    //MARK: Properties
    var weatherViewModel = WeatherViewModel()
    var forecastWeather: ForecastWeatherModel?
    var historyWeather: HistoryWeatherModel?
    var hourlyWeather: [HourlyWeather]?
    
    //MARK: UI Elements
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .clear
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
        button.imageEdgeInsets.left = -220
        button.titleEdgeInsets.left = -200
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
        btn.titleEdgeInsets.right = 80
        btn.imageEdgeInsets.right = 90
        return btn
    }()
        
    private let todayYesterdayCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 200,
                                 height: 50)
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
        layout.itemSize = CGSize(width: 130,
                                 height: 130)
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.layer.borderColor = UIColor.lightGray.cgColor
        collection.layer.borderWidth = 1
        collection.layer.cornerRadius = 40
        return collection
    }()
    
    private let shortWeatherView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 22.5
        return view
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
        stack.spacing = 15
        return stack
    }()
    
    private let lineImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "line")?.withTintColor(UIColor(named: "lightgray")!,
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
        layout.itemSize = CGSize(width: 55,
                                 height: 107)
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        getData()
    }
    
    //MARK: Setup Methods
    func setupViews(){
        view.backgroundColor = UIColor(named: "Color")
        view.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(locationBtn)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd HH:mm"
        let date = dateFormatter.string(from: Date())
        dateLabel.text = "Today, \(date)"
        stackView.addArrangedSubview(dateLabel)
        
        stackView.addArrangedSubview(temperatureLabel)
        
        view.addSubview(degreeLabel)
        
        view.addSubview(weatherBtn)
        
        todayYesterdayCollection.delegate = self
        todayYesterdayCollection.dataSource = self
        todayYesterdayCollection.register(TodayYesterdayCollectionViewCell.self,
                                          forCellWithReuseIdentifier: "TodayYesterdayCollectionViewCell")
        stackView.addArrangedSubview(todayYesterdayCollection)
        todayCollection.delegate = self
        todayCollection.dataSource = self
        todayCollection.register(TodayCollectionViewCell.self,
                                 forCellWithReuseIdentifier: "TodayCollectionViewCell")
        view.addSubview(todayCollection)
        view.addSubview(shortWeatherView)
        shortWeatherView.addSubview(stackVieww)
        stackVieww.addArrangedSubview(maxBtn)
        stackVieww.addArrangedSubview(minBtn)
        
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
    }
    
    func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(forecastView)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
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
            make.width.equalTo(170)
            make.height.equalTo(30)
            make.top.equalTo(210)
            make.leading.equalTo(320)
        }
        todayYesterdayCollection.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        todayCollection.snp.makeConstraints { make in
            make.height.equalTo(130)
            make.leading.trailing.equalTo(stackView)
            make.top.equalTo(todayYesterdayCollection.snp.bottom).offset(40)
        }
        forecastView.snp.makeConstraints { make in
            make.height.equalTo(360)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
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
    }
    
    //MARK: Functions
    func getData(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day,
                                              value: -1,
                                              to: Date())!
        let date = dateFormatter.string(from: yesterday)
        Task{
            forecastWeather = try await weatherViewModel.getForecastWeather(lan: 48.8567,
                                                                            lon: 2.3508)
            historyWeather = try await weatherViewModel.getHistoryWeather(lan: 48.8567,
                                                                          lon: 2.3508,
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
                if Int(tempC) < 10{
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
                switch weathertext {
                case "Sunny":
                    weatherBtn.setImage(UIImage(systemName: "sun.max")?.withTintColor(.white,
                                                                                      renderingMode: .alwaysOriginal),
                                        for: .normal)
                case "Cloudy":
                    weatherBtn.setImage(UIImage(systemName: "cloud")?.withTintColor(.white,
                                                                                    renderingMode: .alwaysOriginal),
                                        for: .normal)
                default:
                    break
                }
                if let hours = forecastWeather?.forecast?.forecastday?[0].hour {
                    hourlyWeather = hours
                }
                hourlyCollection.reloadData()
                todayYesterdayCollection.reloadData()
                todayCollection.reloadData()
            }
        }
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
    
    //MARK: Actions
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: forecastView)
        let todayCollection = self.todayCollection.frame.height + self.todayYesterdayCollection.frame.height + 90
        let firstHeight: CGFloat = 360
        if sender.state == .changed {
            let newHeight = max(firstHeight,
                                forecastView.frame.height - translation.y)
            
            UIView.animate(withDuration: 0.2) {
                self.forecastView.snp.updateConstraints { make in
                    make.height.equalTo(newHeight)
                }
            }
            sender.setTranslation(.zero,
                                  in: forecastView)
        }
        if sender.state == .ended {
            let velocity = sender.velocity(in: forecastView).y
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut) {
                if velocity < 0{
                    self.forecastView.snp.updateConstraints { make in
                        make.height.equalTo(firstHeight + todayCollection)
                    }
                    self.weatherBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                    self.weatherBtn.snp.updateConstraints { make in
                        make.top.equalTo(270)
                        make.leading.equalTo(225)
                    }
                    self.shortWeatherView.isHidden = false
                    self.tomorrowLabel.text = "Next 14 days"
                }else{
                    self.forecastView.snp.updateConstraints { make in
                        make.height.equalTo(firstHeight)
                    }
                    self.weatherBtn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                    self.weatherBtn.snp.updateConstraints { make in
                        make.top.equalTo(210)
                        make.leading.equalTo(320)
                    }
                    self.shortWeatherView.isHidden = true
                    self.tomorrowLabel.text = "Tomorrow"
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func goToMap(_ sender: UIButton){
        let lvc = LocationVC()
        let nvc = UINavigationController(rootViewController: lvc)
        nvc.isModalInPresentation = true
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
}

//MARK: Delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == todayYesterdayCollection {
            return 2
        } else if collectionView == hourlyCollection {
            return hourlyWeather?.count ?? 0
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
               let tempC = hourlyWeather?[indexPath.row].tempC{
                let timee = time.components(separatedBy: " ")
                cell.hourLabel.text = timee[1]
                cell.temperatureLabel.text = "\(Int(tempC))°"
            }
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
}
