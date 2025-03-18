//
//  TodayYesterdayCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 18.03.2025.
//

import UIKit
import SnapKit

class TodayYesterdayCollectionViewCell: UICollectionViewCell {
    
    //MARK: UI Elements
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir",
                            size: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let maxBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.up"),
                     for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    let minBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.down"),
                     for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup Methods
    func setupViews(){
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(maxBtn)
        stackView.addArrangedSubview(minBtn)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(3)
        }
        maxBtn.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(3)
        }
        minBtn.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
}
