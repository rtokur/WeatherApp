//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 19.03.2025.
//

import UIKit
import SnapKit


class ForecastCollectionViewCell: UICollectionViewCell {
    
    //MARK: UI Elements
    let stackVieww: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
        btn.addTarget(self,
                      action: #selector(openBar(_:)),
                      for: .touchUpInside)
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
        view.axis = .horizontal
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "sdfdksjfkjsdkhf"
        label.textColor = .black
        return label
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
        stackVieww.addArrangedSubview(stackView3)
        stackView3.addArrangedSubview(label)
    }
    
    func setupConstraints(){
        stackVieww.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(22.5)
            make.width.equalTo(280)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        weatherIcon.snp.makeConstraints { make in
            make.height.width.equalTo(55)
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
            make.height.equalTo(0)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    //MARK: Actions
    @objc func openBar(_ sender: UIButton){

    }
}
