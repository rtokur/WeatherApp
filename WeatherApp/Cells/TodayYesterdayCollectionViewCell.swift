//
//  TodayYesterdayCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 18.03.2025.
//

import UIKit
import SnapKit

class TodayYesterdayCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
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
    
    let maxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"),
                        for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.imagePadding = 3
        configuration.contentInsets = .zero
        button.contentHorizontalAlignment = .leading
        button.configuration = configuration
        button.tintColor = .lightGray
        return button
    }()
    
    let minButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down"),
                        for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.imagePadding = 3
        configuration.contentInsets = .zero
        button.contentHorizontalAlignment = .leading
        button.configuration = configuration
        button.tintColor = .lightGray
        return button
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
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(maxButton)
        stackView.addArrangedSubview(minButton)
    }
    
    private func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(3)
        }
        maxButton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(3)
        }
        minButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
}
