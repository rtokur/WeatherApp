//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 19.03.2025.
//

import UIKit
import SnapKit


class ForecastCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    var images: [UIImage] = [UIImage(named: "umbrella")!,
                             UIImage(named: "drop")!,
                             UIImage(named: "wind")!,
                             UIImage(named: "uv")!]
    var titles: [String] = ["Chance",
                            "Precipitation",
                            "Wind",
                            "UVI"]
    var values: [String]?
    var forecastDay: ForecastDay? {
        didSet {
            guard let forecast = forecastDay else { return }
            if let chance = forecast.day?.dailyChanceOfRain,
               let precipitation = forecast.day?.totalprecipMm ,
               let wind = forecast.day?.maxwindKph ,
               let uvi = forecast.day?.uv{
                   values = ["\(chance)%",
                             "\(precipitation)mm",
                             "\(Int(wind))km/h",
                             "\(Int(uvi))",]
                createStacks()
                self.forecastDay = forecast
                collection.reloadData()
            }
        }
    }
    
    //MARK: UI Elements
    let stackVieww: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    let weatherIcon: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(named: "lightgray")
        image.layer.cornerRadius = 27.5
        return image
    }()
    
    let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let tomorrowLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let weatherBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.lightGray,
                          for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir",
                                      size: 12)
        btn.setImage(UIImage(systemName: "chevron.down"),
                     for: .normal)
        btn.tintColor = .lightGray
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.minimumScaleFactor = 0.7
        btn.titleLabel?.numberOfLines = 1
        return btn
    }()
    
    let maxBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black,
                          for: .normal)
        btn.setImage(UIImage(systemName: "arrow.up"),
                     for: .normal)
        btn.tintColor = .lightGray
        btn.titleLabel?.font = UIFont(name: "Avenir",
                                      size: 13)
        return btn
    }()
    
    let minBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black,
                          for: .normal)
        btn.setImage(UIImage(systemName: "arrow.down"),
                     for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir",
                                      size: 13)
        btn.tintColor = .lightGray
        return btn
    }()
    
    let stackView3: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor(named: "lightgray")
        view.axis = .vertical
        return view
    }()
    
    let stackView4: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.backgroundColor = UIColor(named: "lightgray")
        return stack
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .lightgray
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.lightgray.cgColor
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup Methods
    func setupViews(){
        contentView.addSubview(stackVieww)
        stackVieww.addArrangedSubview(stackView)
        stackView.addArrangedSubview(weatherIcon)
        stackView.addArrangedSubview(stackView2)
        stackView2.addArrangedSubview(tomorrowLabel)
        stackView2.addArrangedSubview(weatherBtn)
        contentView.addSubview(maxBtn)
        contentView.addSubview(minBtn)
        contentView.addSubview(stackView3)
        stackView3.addArrangedSubview(stackView4)
        stackView3.addArrangedSubview(seperatorView)
        collection.delegate = self
        collection.dataSource = self
        collection.register(CollectionViewCell.self,
                            forCellWithReuseIdentifier: "CollectionViewCell")
        stackView3.addArrangedSubview(collection)
    }
    
    func setupConstraints(){
        stackVieww.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(22.5)
            make.height.equalTo(55)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        weatherIcon.snp.makeConstraints { make in
            make.width.equalTo(55)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        tomorrowLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        weatherBtn.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        maxBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22.5)
            make.height.width.equalTo(45)
            make.trailing.equalToSuperview().inset(77.5)
        }
        minBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(22.5)
            make.height.width.equalTo(45)
        }
        stackView3.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }
        stackView4.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview()
        }
        seperatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(1)
        }
        collection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22.5)
            make.top.equalTo(seperatorView).inset(1)
        }
    }
    
    func createStacks(){
        stackView4.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<4{
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView4.addArrangedSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.height.equalToSuperview()
                make.width.equalToSuperview().dividedBy(4)
            }
            
            let image = UIImageView(image: images[i])
            image.contentMode = .center
            image.backgroundColor = .white
            image.layer.cornerRadius = 29
            stackView.addArrangedSubview(image)
            
            image.snp.makeConstraints { make in
                make.height.width.equalTo(55)
                make.top.equalToSuperview().inset(22.5)
            }
            
            let label = UILabel()
            label.text = titles[i]
            label.textColor = .lightGray
            label.font = UIFont(name: "Avenir",
                                size: 12)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
            
            label.snp.makeConstraints { make in
                make.height.equalToSuperview().dividedBy(6)
            }
            
            let label2 = UILabel()
            label2.text = values?[i]
            label2.textColor = .black
            label2.font = .boldSystemFont(ofSize: 17)
            label2.textAlignment = .center
            stackView.addArrangedSubview(label2)
            
            label2.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
        }
    }
}

//MARK: Delegates
extension ForecastCollectionViewCell: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return forecastDay?.hour?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                      for: indexPath) as! CollectionViewCell
        cell.hour = forecastDay?.hour?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width / 6
        return CGSize(width: width, height: height)
    }
    
}
