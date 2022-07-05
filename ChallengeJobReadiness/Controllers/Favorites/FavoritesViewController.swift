//
//  FavoritesViewController.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 27/06/22.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak private var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var favoritesContainerView: UIView!
    @IBOutlet weak var emptyUIView: UIView!
    
    var items: [BodyItemsResponse] = []
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyUIView.isHidden = true
        loadingActivityIndicatorView.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let favorites = userDefaults.array(forKey: "favoriteItemsArray")  as! [String]?
        if let favorites = favorites {
            let formattedString = favorites.joined(separator: ",")
            getFavoriteItems(itemsIds: formattedString)
        }
    }
    
    private func setupView() {
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
    
    // MARK: - Request to API
    private func getFavoriteItems(itemsIds: String) {
        let itensServices = ItensServices()
        let url = "?ids=\(itemsIds)"
        
        itensServices.getInfoByItemId(itemsIds: url) { response in
            guard let response = response else {
                self.loadingActivityIndicatorView.isHidden = true
                self.emptyUIView.isHidden = false
                return
            }

            self.loadingActivityIndicatorView.isHidden = true
            self.items = response
            self.favoritesTableView.reloadData()
        }
    }

}
