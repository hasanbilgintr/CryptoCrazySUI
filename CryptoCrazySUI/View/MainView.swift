//
//  ContentView.swift
//  CryptoCrazySUI
//
//  Created by hasan bilgin on 31.10.2023.
//

import SwiftUI

struct MainView: View {
    //Gözlemlenen Object demek
    @ObservedObject var cryptoListViewModel: CryptoListViewModel
    
    //preview hatası gidermek için çünkü değişken oluşturduk o olmadığını sölüyor ondna doalyı init yaptık
    init(){
        self.cryptoListViewModel = CryptoListViewModel()
    }
    var body: some View {
        VStack {
            NavigationView{
                //List id istediği için getirdik böle
                List(cryptoListViewModel.cryptoList,id :\.id){crypto in
                    VStack{
                        //frame(maxWidth: .infinity, alignment: .leading) en sol tarafa sıfırlanlanmış oldu
                        Text(crypto.currency).font(.title3).foregroundStyle(.blue).frame(maxWidth: .infinity, alignment: .leading)
                        Text(crypto.price).foregroundStyle(.black).frame(maxWidth: .infinity,alignment: .leading)
                    }
                }
                //toolbar eklemnesi ve butonu
                .toolbar(content: {
                    Button {
                        print("tıklandı")
                        //async { aynı
                        //task { aynı
                        //günceli bu
                        Task.init {
                            //güncellendiğini görmek için yaptık yoruma aldık
                            //cryptoListViewModel.cryptoList = []
                            await cryptoListViewModel.downloadCryptoContinuation(url: URL(string: "\(Constants.url)/master/crypto.json")!)
                        }
                    } label: {
                        Text("Refresh")
                    }

                })
                
                .navigationTitle(Text("Crypto Crazy"))
            }
            //task direk asencron çalışır ondna böle çalıştırdık
        }.task{
            
            
            await cryptoListViewModel.downloadCryptoContinuation(url: URL(string: "\(Constants.url)/master/crypto.json")!)
            
            //await cryptoListViewModel.downloadCryptoAsync(url: URL(string: "\(Constants.url)/master/crypto.json")!)
        }
        
        /*.onAppear{
            cryptoListViewModel.downloadCryptos(url: URL(string: "\(Constants.url)/master/crypto.json")!)
        }
         */
    }
}

#Preview {
    MainView()
}


