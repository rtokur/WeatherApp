//
//  TodayCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 18.03.2025.
//

import UIKit
import SnapKit

class TodayCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.titleEdgeInsets.left = 10
        btn.imageEdgeInsets.right = 10
        btn.contentHorizontalAlignment = .leading
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return btn
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Avenir",
                            size: 12)
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
    
    //MARK: - Setup Methods
    private func setupViews(){
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)
    }
    
    private func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(25)
        }
        button.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
