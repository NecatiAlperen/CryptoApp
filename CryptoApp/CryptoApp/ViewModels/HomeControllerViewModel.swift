//
//  HomeControllerViewModel.swift
//  CryptoApp
//
//  Created by Necati Alperen IŞIK on 16.11.2023.
//


import UIKit


class HomeControllerViewModel {
    
    var onCoinsUpdated : (()->Void)?
    var onErrorMessage : ((CoinServiceError)->Void)?
    private(set) var allCoins: [Coin] = [] {
        didSet{
            self.onCoinsUpdated?()
        }
    }
    private(set) var filteredCoins : [Coin] = []
    init(){
        self.fetchCoins()
    }
    
    
    public func fetchCoins(){
        let endpoint = Endpoint.fetchCoins()
        CoinService.fetchCoins(wiith: endpoint) { [weak self] result in
            switch result{
            case .success(let coins):
                self?.allCoins = coins
                print("debug print: ","\(coins.count) coins fetched")
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}



extension HomeControllerViewModel {
    public func inSearchMode (_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController (searchBarText: String?) {
        self.filteredCoins = allCoins
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onCoinsUpdated?(); return}
            self.filteredCoins = self.filteredCoins.filter({ $0.name.lowercased().contains(searchText) })
        }
        self.onCoinsUpdated?()
    }
    
}
