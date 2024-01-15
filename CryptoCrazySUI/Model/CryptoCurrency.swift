//
//  CryptoCurrency.swift
//  CryptoCrazySUI
//
//  Created by hasan bilgin on 31.10.2023.
//

import Foundation

struct CryptoCurrency : Hashable, Decodable , Identifiable {
    let id  = UUID()
    let currency : String
    let price : String
    
    
    //bazen çekilcek olan veri abuk subuk olabilir mesela 12currency olsaydı gibi
    
    private enum CodingKeys : String , CodingKey {
//        case currency = "12currency"
        case currency = "currency"
        case price = "price"
    }
    
    //codingkeys kullanırken Hashable yanında kullanılabilir onla ilgili işlem yapmadık tavsiye edilir
}
