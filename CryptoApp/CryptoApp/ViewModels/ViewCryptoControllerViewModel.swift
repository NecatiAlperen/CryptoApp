//
//  ViewCryptoControllerViewModel.swift
//  CryptoApp
//
//  Created by Necati Alperen IŞIK on 16.11.2023.
//

import Foundation
import UIKit


class ViewCryptoControllerViewModel {
    var onImageLoaded: ((UIImage?) -> Void)?
    //MARK: - Variables
    let coin : Coin
    //MARK: - Initializer
    init(_ coin: Coin) {
        self.coin = coin
        self.loadİmage()
    }
    
    private func loadİmage(){
        DispatchQueue.global().async { [weak self] in
            if let logoURL = self?.coin.logoURL,
               let imageData = try? Data(contentsOf: logoURL),
               let logoImage = UIImage(data: imageData){
                self?.onImageLoaded?(logoImage)
            }
        }
    }
    
    //MARK: - Computed Properties
    var rankLabel :String {
        return "Rank:\(self.coin.rank) CAD"
    }
    var priceLabel :String {
        return "Price :$\(self.coin.pricingData.CAD.price) CAD"
    }
    var marketCapLabel :String {
        return "Market Cap:$\(self.coin.pricingData.CAD.market_cap) CAD"
    }
    var maxSupplyLabel :String {
        
        if let maxSupply = self.coin.maxSupply  {
            return " Max Supply :\(maxSupply)"
        }else{
            return  ""
        }
        
    }
    
    
}
