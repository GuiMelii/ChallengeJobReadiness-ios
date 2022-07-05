//
//  HomeViewController.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 27/06/22.
//

import UIKit

struct itemCellData {
    let title: String
    let price: String
    let descriptionOne: String
    let descriptionTwo: String
    let image: UIImage
}

final class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var HeaderUIView: UIView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emptyResultView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    let userDefaults = UserDefaults.standard
    var items: [BodyItemsResponse] = []
    let itensServices = ItensServices()
    
    @IBAction func inputDidEndEditing(_ sender: Any) {
        print("eae")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        if let search = self.searchTextField.text {
            self.emptyResultView.isHidden = true
            getItems(searchText: search)
        }
        textField.resignFirstResponder()
        return false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        itemsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getItems(searchText: "celular")

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
    
    private func reduceUrl(_ response: TopTwentyResponse) -> String {
        var url = "?ids="
        
        for (index, item) in response.content.enumerated() {
            if (index == response.content.count - 1) {
                url += item.id
            } else {
                url += "\(item.id),"
            }
        }
        
        return url
    }
    
    private func getItems(searchText: String) {
        self.errorView.isHidden = true
        self.loadingActivityIndicatorView.isHidden = false
        
        itensServices.getCategoriesCode(of: searchText) { response in
            guard let response = response, response.count > 0 else {
                self.loadingActivityIndicatorView.isHidden = true
                self.emptyResultView.isHidden = false
                return
            }

            self.itensServices.getTopTwentyByCategory(category_id: response[0].category_id) { response in
                guard let response = response else {
                    self.loadingActivityIndicatorView.isHidden = true
                    self.errorView.isHidden = false
                    return
                }
                let url = self.reduceUrl(response)
                
                
                print("url", url)
                self.itensServices.getInfoByItemId(itemsIds: url) { response in
                    guard let response = response else {
                        self.loadingActivityIndicatorView.isHidden = true
                        self.errorView.isHidden = false
                        return
                    }
                    
                    self.itemsTableView.isHidden = false
                    self.loadingActivityIndicatorView.isHidden = true
                    self.items = response
                    self.itemsTableView.reloadData()
                    print("produtitos", response)
                }
            }
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("ItemTableViewCell", owner: self, options: nil)?.first as! ItemTableViewCell
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell

        let favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?

        let item = items[indexPath.row]
        
        let findItemOnArray = favoriteItens?.first(where: {$0 == item.body.id})
        
        //cell.favoriteButtonView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        cell.FavoriteButtonUIControl.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        cell.FavoriteButtonUIControl.layer.cornerRadius = 14.5
        
        cell.heartImageView.image = findItemOnArray == nil ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        cell.titleLabel.text = item.body.title
        cell.priceLabel.text = "$\(item.body.price)"
        cell.descriptionOneLabel.text = "Vendidos: \(item.body.sold_quantity)"
        cell.descriptionTwoLabel.text = "Disponíveis: \(item.body.available_quantity)"
        cell.favoriteAction = {
            onHeartClick()
        }
        
        if let url = URL(string: item.body.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                cell.itemUIImage.image = image
            }
        } else {
            cell.itemUIImage.image = UIImage(imageLiteralResourceName: "porsche")
        }
        
        func onHeartClick() {
            let favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
            let findItemOnArray = favoriteItens?.first(where: {$0 == item.body.id})
            
            if var auxArray = favoriteItens {
                if findItemOnArray == nil {
                    cell.heartImageView.image = UIImage(systemName: "heart.fill")
                    auxArray.append(item.body.id)
                    self.userDefaults.set(auxArray, forKey: "favoriteItemsArray")
                } else {
                    //                    let aux = auxArray
                    let index = auxArray.firstIndex(of: item.body.id)
                    if let indexAux = index {
                        auxArray.remove(at: indexAux)
                        self.userDefaults.set(auxArray, forKey: "favoriteItemsArray")
                        cell.heartImageView.image = UIImage(systemName: "heart")
                    }
                }
            } else {
                self.userDefaults.set([item.body.id], forKey: "favoriteItemsArray")
                cell.heartImageView.image = UIImage(systemName: "heart.fill")
            }
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewController = ItemViewController(nibName: "ItemViewController", bundle: nil)
        itemViewController.item = items[indexPath.row].body
        navigationController?.pushViewController(itemViewController, animated: true)
        itemsTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIImage {
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
