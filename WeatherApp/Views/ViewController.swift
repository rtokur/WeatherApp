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
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir",
                            size: 12)
        return label
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir",
                            size: 140)
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
        btn.titleLabel?.font = UIFont(name: "Avenir",
                                      size: 17)
        btn.setTitleColor(.white,
                          for: .normal)
        btn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
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
        collection.layer.borderColor = UIColor.white.cgColor
        collection.layer.borderWidth = 1
        collection.layer.cornerRadius = 25
        return collection
    }()
    
    private let forecastView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        
        stackView.addArrangedSubview(stackView2)
        
        stackView2.addArrangedSubview(temperatureLabel)
        
        stackView2.addArrangedSubview(degreeLabel)
        
        stackView2.addArrangedSubview(weatherBtn)
        
        todayYesterdayCollection.delegate = self
        todayYesterdayCollection.dataSource = self
        todayYesterdayCollection.register(TodayYesterdayCollectionViewCell.self,
                                          forCellWithReuseIdentifier: "TodayYesterdayCollectionViewCell")
        stackView.addArrangedSubview(todayYesterdayCollection)
        
        view.addSubview(forecastView)
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
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        degreeLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(100)
        }
        weatherBtn.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        todayYesterdayCollection.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        forecastView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    //MARK: Functions
    func getData(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
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
               let country = forecastWeather?.location?.country as? String{
                locationBtn.setTitle("\(city), \(country)",
                                     for: .normal)
                temperatureLabel.text = "\(Int(tempC))"
                weatherBtn.setTitle(weathertext, for: .normal)
                todayYesterdayCollection.reloadData()
            }
        }
    }
}

//MARK: Delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    
}
