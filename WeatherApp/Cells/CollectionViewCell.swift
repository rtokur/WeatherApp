//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 22.03.2025.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    var hour: HourlyWeather? {
        didSet {
            guard let hourr = hour else { return }
            hour = hourr
            setData()
        }
    }
    
    //MARK: UI Elements
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    let hourLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir",
                            size: 11)
        label.textAlignment = .center
        return label
    }()
    
    let image : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let chanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir",
                            size: 12)
        label.textAlignment = .center
        return label
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        contentView.backgroundColor = .lightgray
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(image)

        stackView.addArrangedSubview(chanceLabel)
        stackView.addArrangedSubview(degreeLabel)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(21.5).priority(.high)
        }
        hourLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        image.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        chanceLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        degreeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    func setData(){
        if let time = hour?.time,
           let chance = hour?.chanceOfRain,
           let degree = hour?.tempC,
           let text = hour?.condition?.text{
            let times = time.components(separatedBy: " ")
            print(times[1],"timess")
            hourLabel.text = times[1]
            chanceLabel.text = "\(chance)%"
            degreeLabel.text = "\(Int(degree))°"
            var text2 = text
            if text2.hasSuffix(" "){
                text2.remove(at: text2.index(before: text2.endIndex))
            }
            if text2 == "Partly cloudy"{
                image.image = UIImage(named: "\(text2) 1")?.withRenderingMode(.alwaysOriginal)
            }else {
                image.image = UIImage(named: "\(text2)")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}
