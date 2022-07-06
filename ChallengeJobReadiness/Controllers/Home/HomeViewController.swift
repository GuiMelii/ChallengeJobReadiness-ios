//
//  HomeViewController.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 27/06/22.
//

import UIKit

final class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak private var HeaderUIView: UIView!
    @IBOutlet weak private var inputContainerView: UIView!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var emptyResultView: UIView!
    @IBOutlet weak private var errorView: UIView!
    
    let userDefaults = UserDefaults.standard
    var items: [BodyItemsResponse] = []
    private let itensServices = ItensServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getItems(searchText: "celular")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        itemsTableView.reloadData()
    }
    
    private func setupView() {
        self.searchTextField.delegate = self
        
        emptyResultView.isHidden = true
        errorView.isHidden = true
        
        HeaderUIView.layer.shadowColor = UIColor.black.cgColor
        HeaderUIView.layer.shadowOpacity = 0.1
        HeaderUIView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        inputContainerView.layer.shadowColor = UIColor.black.cgColor
        inputContainerView.layer.shadowOpacity = 0.2
        inputContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        searchTextField.borderStyle = .none
        searchTextField.isEnabled = true
        
        itemsTableView.isHidden = true
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        itemsTableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        itemsTableView.rowHeight = 150
        itemsTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        itemsTableView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let search = self.searchTextField.text, self.searchTextField.text != "" {
            self.emptyResultView.isHidden = true
            getItems(searchText: search)
        } else {
            let resultAlert = UIAlertController(title: "O campo de busca está vazio.", message: "Preencha com o produto no campo de busca, por favor.",
                                                preferredStyle: .alert)
            resultAlert.addAction(UIAlertAction(
                title: "Fechar",
                style: .cancel))
            present(resultAlert, animated: true)
        }
        
        textField.resignFirstResponder()
        return false
    }
    
    func setupViewError() {
        self.loadingActivityIndicatorView.isHidden = true
        self.errorView.isHidden = false
    }
    
    
    // MARK: - Request to API
    private func getItems(searchText: String) {
        self.errorView.isHidden = true
        self.loadingActivityIndicatorView.isHidden = false
        
        itensServices.getCategoriesCode(of: searchText) { response in
            guard let response = response, response.count > 0 else { return self.setupViewError() }
            
            self.itensServices.getTopTwentyByCategory(category_id: response[0].category_id) { response in
                guard let response = response else { return self.setupViewError() }
                
                let url = reduceUrl(response)
                self.itensServices.getInfoByItemId(itemsIds: url) { response in
                    guard let response = response else { return self.setupViewError() }
                    
                    self.itemsTableView.isHidden = false
                    self.loadingActivityIndicatorView.isHidden = true
                    self.items = response
                    self.itemsTableView.reloadData()
                }
            }
        }
    }
    
}
