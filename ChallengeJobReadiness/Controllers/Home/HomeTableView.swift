//
//  HomeTableView.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 05/07/22.
//

import Foundation
import UIKit

//HomeViewController+Extension nomenclatura
// MARK: - TableView Configuration
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
        let item = items[indexPath.row]
        let findItemOnArray = favoriteItens?.first(where: {$0 == item.body.id})
        
        // MARK: - Cell configuration
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        cell.FavoriteButtonUIControl.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        cell.FavoriteButtonUIControl.layer.cornerRadius = 14.5
        cell.priceLabel.text = formatToCurrency(value: item.body.price)
        cell.heartImageView.image = findItemOnArray == nil ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        cell.titleLabel.text = item.body.title
        cell.descriptionOneLabel.text = "Vendidos: \(item.body.sold_quantity)"
        cell.descriptionTwoLabel.text = "Disponíveis: \(item.body.available_quantity)"
        cell.favoriteAction = {
            self.onHeartClick(cell, item)
        }
        if let url = URL(string: item.body.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                cell.itemUIImage.image = image
            }
        } 
        
        return cell
    }
    
    // MARK: - Favorite action
    private func onHeartClick(_ cell: ItemTableViewCell,_ item: BodyItemsResponse) {
        let favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
        let findItemOnArray = favoriteItens?.first(where: {$0 == item.body.id})
        
        if var favoriteItens = favoriteItens {
            if findItemOnArray == nil {
                cell.heartImageView.image = UIImage(systemName: "heart.fill")
                favoriteItens.append(item.body.id)
                self.userDefaults.set(favoriteItens, forKey: "favoriteItemsArray")
            } else {
                let index = favoriteItens.firstIndex(of: item.body.id)
                if let index = index {
                    favoriteItens.remove(at: index)
                    self.userDefaults.set(favoriteItens, forKey: "favoriteItemsArray")
                    cell.heartImageView.image = UIImage(systemName: "heart")
                }
            }
        } else {
            self.userDefaults.set([item.body.id], forKey: "favoriteItemsArray")
            cell.heartImageView.image = UIImage(systemName: "heart.fill")
        }
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
