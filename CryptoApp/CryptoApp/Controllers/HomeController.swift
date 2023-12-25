//
//  ViewController.swift
//  CryptoApp
//
//  Created by Necati Alperen IŞIK on 15.11.2023.
//

import UIKit

class HomeController: UIViewController, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    
    
        
    
    

    
    // MARK: - Variables
    
    private let viewModel: HomeControllerViewModel
    
    
    
    
    // MARK: - UI Components
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView : UITableView =  {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        return tv
    }()
    
    
    // MARK: - Lifecycle
    
    
    init(_ viewModel: HomeControllerViewModel = HomeControllerViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        self.setupUI()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel.onCoinsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        self.viewModel.onErrorMessage = {[weak self] error in
            
            DispatchQueue.main.async {
            
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: nil))
                
                switch error {
                case .serverError(let serverError):
                    alert.title = "Server Eroor \(serverError.errorCode)"
                    alert.message = serverError.errorMessage
                case .unknown(let string):
                    alert.title = "error fetching Coins"
                    alert.message = string
                case .decodingError(let string):
                    alert.title = "error parsing data"
                    alert.message = string
                }
                self?.present(alert,animated: true,completion: nil)
            }
        }
        
        }
    
    
    
    
    // MARK: - UI Setup
    
    private func setupUI(){
        self.navigationItem.title = "Crypto App"
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setupSearchController(){
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Coins"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

//MARK: - Search Controller Functions
    
    
    
    
    
    // MARK: - Selectors


}

    // MARK: - TableView Functions

extension HomeController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        return inSearchMode ? self.viewModel.filteredCoins.count:
            self.viewModel.allCoins.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier,for: indexPath) as? CoinCell else {
            fatalError("unable to dequeue CoinCell in HomeController")
        }
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        let coin = inSearchMode ? self.viewModel.filteredCoins[indexPath.row]:
        self.viewModel.allCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        let coin = inSearchMode ? self.viewModel.filteredCoins[indexPath.row]:
        self.viewModel.allCoins[indexPath.row]
        let vm = ViewCryptoControllerViewModel(coin)
        let vc = ViewCryptoController(vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


