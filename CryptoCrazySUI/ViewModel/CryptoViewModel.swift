//
//  CryptoViewModel.swift
//  CryptoCrazySUI
//
//  Created by hasan bilgin on 3.11.2023.
//

import Foundation
//hata alırsak eklenebilir
//import Combine

//ObservableObject Combine Fireworks den çıkan bir teknoloji
//ObservableObject gözlemlenebilir object

//Actors konulan yerde işlemlerin main threadde çalışmasını sağlar DispatchQueue.main.async { buna gerek kalmadan tabi sadece yapılan işlem bu ise global maindede yapılan işlem varsa olmaz // class başına gelerek  @MainActor yazılır
@MainActor
class CryptoListViewModel : ObservableObject{
    
    let webservice = Webservice()
    //bunu  mvvm stormboard da denemedik buda bir dinleme şekli
    //cryptoList gözlemliceğimiz değişken her gözlemlendiğinde yenilencek aslında zaten ondna ObservableObject dendi
    @Published var cryptoList = [CryptoCurrencyViewModel]()
    
    func downloadCryptoContinuation(url : URL) async {
        do {
            let cryptos = try await webservice.dowloadCurrenciesContinuation(url: url)
            //DispatchQueue.main.async {
            //MainActor eklendiği için pasife alındı
                self.cryptoList = cryptos.map(CryptoCurrencyViewModel.init)
            //}
        }catch{
            print(error)
        }
    }
    
    func downloadCryptoAsync(url: URL) async {
        do{
            let cryptos = try await webservice.downloadCurrenciesAsync(url: url)
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoCurrencyViewModel.init)
            }
        }catch{
            print(error)
        }
    }
    
    
    
    func downloadCryptos(url: URL){
        webservice.downloadCurrencies(url: url) { result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let cryptos):
                //opsinal den çıkardık
                if let cryptos = cryptos {
                    DispatchQueue.main.async {
                        //ikiside aynı ama map demek şart
                        self.cryptoList = cryptos.map(CryptoCurrencyViewModel.init)
                    }
                }
            }
        }
    }
    
}

struct CryptoCurrencyViewModel {
    let crypto : CryptoCurrency
    
    //id yi UUID olucak opsinal den çıkarmak için crypto.id den al demekmiş
    var id : UUID? {
        crypto.id
    }
    
    var currency : String {
        crypto.currency
    }
    
    var price : String {
        crypto.price
    }
}
