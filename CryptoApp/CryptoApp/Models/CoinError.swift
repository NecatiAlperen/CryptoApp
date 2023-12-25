//
//  CoinError.swift
//  CryptoApp
//
//  Created by Necati Alperen IŞIK on 16.11.2023.
//

import Foundation


struct CoinStatus : Decodable {
    let status: CoinError
}


    struct CoinError  :Decodable {
        let errorCode : Int
        let errorMessage :String
    
    enum CodingKeys : String,CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
