//
//  FavoritesTableView.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 05/07/22.
//

import Foundation
import UIKit

// MARK: - TableView Configuration
extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        let item = items[indexPath.row]
                
        cell.FavoriteButtonUIControl.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        cell.FavoriteButtonUIControl.layer.cornerRadius = 14.5
        cell.heartImageView.image = UIImage(systemName: "heart.fill")
        cell.titleLabel.text = item.body.title
        cell.priceLabel.text = formatToCurrency(value: item.body.price)
        cell.descriptionOneLabel.text = "Vendidos: \(item.body.sold_quantity)"
        cell.descriptionTwoLabel.text = "Disponíveis: \(item.body.available_quantity)"
        if let url = URL(string: item.body.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                cell.itemUIImage.image = image
            }
        }
        cell.favoriteAction = {
            self.onHeartClick(indexPath.row)
        }

        return cell
    }
    
    private func onHeartClick(_ rowIndexPath: Int) {
        var favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
        
        var correctIndex = 0
        for (index, favorite) in favoriteItens!.enumerated() {
            if favorite == self.items[rowIndexPath].body.id {
                correctIndex = index
            }
        }
        
        favoriteItens?.remove(at: correctIndex)
        self.items.remove(at: rowIndexPath)
        self.userDefaults.set(favoriteItens, forKey: "favoriteItemsArray")
        self.favoritesTableView.reloadData()
        
        if (favoriteItens?.count == 0) {
            self.emptyUIView.isHidden = false
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewController = ItemViewController(nibName: "ItemViewController", bundle: nil)
        itemViewController.item = items[indexPath.row].body
        navigationController?.pushViewController(itemViewController, animated: true)
    }
}
