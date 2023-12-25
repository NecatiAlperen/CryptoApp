//
//  CoinCell.swift
//  CryptoApp
//
//  Created by Necati Alperen IŞIK on 15.11.2023.
//
import UIKit

class CoinCell : UITableViewCell{
    static let identifier = "CoinCell"
    
    private(set) var coin: Coin!
    
    private let coinLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .black
        return iv
    }()
    
    private let coinName : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22,weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    public func configure(with coin: Coin){
        self.coin = coin
        self.coinName.text = coin.name
        self.coinLogo.sd_setImage(with: coin.logoURL)
        
    }
    
    
    private func setupUI(){
        self.addSubview(coinLogo)
        self.addSubview(coinName)
        
        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        coinName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            coinLogo.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            coinLogo.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier:  0.75),
            coinLogo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier:  0.75),
            
            coinName.leadingAnchor.constraint(equalTo: coinLogo.trailingAnchor,constant: 16),
            coinName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
