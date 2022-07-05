//
//  FavoritesViewController.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 27/06/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var favoritesContainerView: UIView!
    @IBOutlet weak var emptyUIView: UIView!
    var items: [BodyItemsResponse] = []
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        favoritesContainerView.layer.masksToBounds = false
        favoritesContainerView.layer.shadowColor = UIColor.black.cgColor
        favoritesContainerView.layer.shadowOpacity = 0.2
        favoritesContainerView.layer.shadowOffset = CGSize(width: 0, height: 5)

        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.rowHeight = 150
        favoritesTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0);
        favoritesTableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        favoritesTableView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyUIView.isHidden = true
        loadingActivityIndicatorView.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        let favorites = userDefaults.array(forKey: "favoriteItemsArray")
        
        if let favorites = favorites {
            let aux = favorites as! [String]
            let formattedString = aux.joined(separator: ",")
            getFavoriteItems(itemsIds: formattedString)
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    private func getFavoriteItems(itemsIds: String) {
        let itensServices = ItensServices()
        let url = "?ids=\(itemsIds)"
        
        itensServices.getInfoByItemId(itemsIds: url) { response in
            print(response)
            guard let response = response else {
                print("olá")
                self.loadingActivityIndicatorView.isHidden = true
                self.emptyUIView.isHidden = false
                return
            }

//            self.itemsTableView.isHidden = false
//            self.loadingActivityIndicatorView.isHidden = true
            self.loadingActivityIndicatorView.isHidden = true
            self.items = response
            self.favoritesTableView.reloadData()
            print("produtitos", response)
        }
    }

}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell

        var favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?

        let item = items[indexPath.row]
                
        cell.FavoriteButtonUIControl.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        cell.FavoriteButtonUIControl.layer.cornerRadius = 14.5
        
        cell.heartImageView.image = UIImage(systemName: "heart.fill")
        cell.titleLabel.text = item.body.title
        cell.priceLabel.text = "$\(item.body.price)"
        cell.descriptionOneLabel.text = "Vendidos: \(item.body.sold_quantity)"
        cell.descriptionTwoLabel.text = "Disponíveis: \(item.body.available_quantity)"
        cell.favoriteAction = {
            var correctIndex = 0
            for (index, favorite) in favoriteItens!.enumerated() {
                if favorite == self.items[indexPath.row].body.id {
                    correctIndex = index
                }
            }
            self.items.remove(at: indexPath.row)
            favoriteItens?.remove(at: correctIndex)
            self.userDefaults.set(favoriteItens, forKey: "favoriteItemsArray")
            self.favoritesTableView.reloadData()
            
            if (favoriteItens?.count == 0) {
                self.emptyUIView.isHidden = false
            }
        }

        
        if let url = URL(string: item.body.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                cell.itemUIImage.image = image
            }
        } else {
            cell.itemUIImage.image = UIImage(imageLiteralResourceName: "porsche")
        }
        
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewController = ItemViewController(nibName: "ItemViewController", bundle: nil)
        itemViewController.item = items[indexPath.row].body
        navigationController?.pushViewController(itemViewController, animated: true)
    }
}
