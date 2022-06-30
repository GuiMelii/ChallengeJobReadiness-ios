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
    
    @IBAction func inputDidEndEditing(_ sender: Any) {
        print("eae")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        if let search = self.searchTextField.text {
            getItems(searchText: search)
        }
        textField.resignFirstResponder()
        return false
    }

    var items: [BodyItemsResponse] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems(searchText: "capa")

        self.searchTextField.delegate = self
        
        HeaderUIView.layer.shadowColor = UIColor.black.cgColor
        HeaderUIView.layer.shadowOpacity = 0.1
        HeaderUIView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        inputContainerView.layer.shadowColor = UIColor.black.cgColor
        inputContainerView.layer.shadowOpacity = 0.2
        inputContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        searchTextField.borderStyle = .none
        searchTextField.isEnabled = true
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        itemsTableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        itemsTableView.rowHeight = 150
        itemsTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        itemsTableView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func getItems(searchText: String) {
        let itensServices = ItensServices()
        
        itensServices.getCategoriesCode(of: searchText) { response in
            guard let response = response, response.count > 0 else { return }
            
            itensServices.getTopTwentyByCategory(category_id: response[0].category_id) { response in
                guard let response = response else { return }
                let url = self.reduceUrl(response)
                
                
                print("url", url)
                itensServices.getInfoByItemId(itemsIds: url) { response in
                    guard let response = response else { return }
                    
                    self.items = response
                    self.itemsTableView.reloadData()
                    print("produtitos", response)
                }
            }
        }
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
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("ItemTableViewCell", owner: self, options: nil)?.first as! ItemTableViewCell
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell

        let item = items[indexPath.row]
        
        cell.favoriteButtonView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        
        cell.titleLabel.text = item.body.title
        cell.priceLabel.text = "$\(item.body.price)"
        cell.descriptionOneLabel.text = "Vendidos: \(item.body.sold_quantity)"
        cell.descriptionTwoLabel.text = "Disponíveis: \(item.body.available_quantity)"
        
        if let url = URL(string: item.body.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                cell.itemUIImage.image = image
                cell.itemUIImage.contentMode = .scaleAspectFill
            }
        } else {
            cell.itemUIImage.image = UIImage(imageLiteralResourceName: "porsche")
        }
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewController = ItemViewController(nibName: "ItemViewController", bundle: nil)
        navigationController?.pushViewController(itemViewController, animated: true)
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
