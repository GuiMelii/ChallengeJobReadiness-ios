//
//  ItemTableViewCell.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 28/06/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemUIImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionOneLabel: UILabel!
    @IBOutlet weak var descriptionTwoLabel: UILabel!
    @IBOutlet weak var FavoriteButtonUIControl: UIControl!
    @IBOutlet weak var heartImageView: UIImageView!
    
    var favoriteAction: (() -> Void)? = nil

    @IBAction func onFavoriteClick(_ sender: Any) {
        favoriteAction?()
    }
}
