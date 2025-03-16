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
    var forecastWeather: WeatherModel?
    
    //MARK: UI Elements
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let locationBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "location"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets.left = -220
        button.titleEdgeInsets.left = -200
        button.titleLabel?.font = UIFont(name: "Avenir", size: 25)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir", size: 12)
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
        label.font = UIFont(name: "Avenir", size: 140)
        return label
    }()
    
    private let weatherBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont(name: "Avenir", size: 17)
        btn.setTitleColor(.white, for: .normal)
        btn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        return btn
    }()
    
    private let forecastView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupViews()
        setupConstraints()
        getData()
    }
    
    //MARK: Setup Methods
    func setupViews(){
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
        
        stackView2.addArrangedSubview(weatherBtn)
        
        stackView.addArrangedSubview(forecastView)
    }
    
    func setupConstraints(){
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
        weatherBtn.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        forecastView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.frameLayoutGuide).dividedBy(3)
        }
    }
    
    //MARK: Functions
    func getData(){
        Task{
            forecastWeather = try await weatherViewModel.getForecastWeather(lan: 48.8567, lon: 2.3508)
            if let tempC = forecastWeather?.current?.tempC as? Double,
               let weathertext = forecastWeather?.current?.condition?.text as? String,
               let city = forecastWeather?.location?.name as? String,
               let country = forecastWeather?.location?.country as? String{
                locationBtn.setTitle("\(city), \(country)", for: .normal)
                temperatureLabel.text = "\(tempC)°C"
                weatherBtn.setTitle(weathertext, for: .normal)
                print(forecastWeather?.forecast?.forecastday?[0].hour?[0].cloud)
            }
        }
    }
}

