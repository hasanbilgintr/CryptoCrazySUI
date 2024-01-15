//
//  Webservice.swift
//  CryptoCrazySUI
//
//  Created by hasan bilgin on 3.11.2023.
//

import Foundation

class Webservice {
    
    
    //Continuation //devam ettirme // amacımız async olmayan bir function async yapma farklı bir fonsyionu yani ulaşamadığımız bir fonskyion olarak düşünelim ve duraklatıp devam ettirebilirizde bunla
    func dowloadCurrenciesContinuation(url : URL) async throws -> [CryptoCurrency] {
        //kontrol edilmiş devam edilen demek
        try await withCheckedThrowingContinuation { continuation in
            downloadCurrencies(url: url) { result in
                switch result {
                case .success(let cryptos):
                    //if lette girilebilir ?? [] yerine
                    continuation.resume(returning: cryptos ?? [])
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    //https://www.andyibanez.com/posts/understanding-async-await-in-swift/  async / await
    //async asenkron bir thread yapma // await ise işlem bitene kadar beklemesi duraklatması
    //amaç @escaping yerine kullanım sağlamış oluyoruz
    
    func downloadCurrenciesAsync(url: URL) async throws -> [CryptoCurrency] {
        let (data,response) = try await URLSession.shared.data(from: url)
        //response verilen cevaba göre birşeyler döndürğlebilir
        let currencies = try? JSONDecoder().decode([CryptoCurrency].self,from: data)
        return currencies ?? []
    }
    
    
    func downloadCurrencies(url: URL,completion: @escaping (Result<[CryptoCurrency]?,DownloaderError>) -> Void){
        
        //bu fonksiyon zaten arka planda otomatik yapıyor yani DispatchQ..Global oalrak çalışmaktadır
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            //error?(error opsional) olduğu if let yapıldı
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.badUrl))
            }
            
            //burda gelen data dataya aktarıldıysa yani nil değilse anlamında ve error nil ise elsede bu ihtimallerin tam tersini ele alır
            //guard let data = data ,....   let data derken o data kullanılmıcaksa _ diye yazılabilir
            guard let data = data , error == nil else{
                return completion(.failure(.noData))
            }
            
            //try? koyarak do catchten kurtulduk istenirse konulabilir
            guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else{
                return completion(.failure(.dataParseError))
            }
            
            completion(.success(currencies))
        }.resume()
        
    }
}

enum DownloaderError: Error {
    case badUrl
    case noData
    case dataParseError
}
