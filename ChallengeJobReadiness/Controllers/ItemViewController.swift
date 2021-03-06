//
//  ItemViewController.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 29/06/22.
//

import UIKit

final class ItemViewController: UIViewController {
    
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var mainImageView: UIImageView!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var soldQuantityLabel: UILabel!
    @IBOutlet weak private var descriptionTextView: UILabel!
    @IBOutlet weak private var availableQuantityLabel: UILabel!
    @IBOutlet weak private var whatsappButton: UIControl! {
        didSet {
            whatsappButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak private var heartUIButton: UIButton! {
        didSet {
            heartUIButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    var item: InfoItem = InfoItem(id: "", title: "", price: 0, sold_quantity: 0, available_quantity: 0, pictures: [Picture(url: "", secure_url: "")])
    private let itensServices = ItensServices()
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
        let findItemOnArray = favoriteItens?.first(where: {$0 == item.id})
        
        self.heartUIButton.setImage(findItemOnArray != nil ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        getDescription()
    }
    
    private func setupView() {
        self.subtitleLabel.text = item.title
        self.titleLabel.text = item.title
        self.priceLabel.text = formatToCurrency(value: item.price)
        self.soldQuantityLabel.text = "Vendidos: \(item.sold_quantity)"
        self.availableQuantityLabel.text = "Disponíveis: \(item.available_quantity)"
        
        if let url = URL(string: item.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                self.mainImageView.image = image
            }
        } 
    }
    
    private func getDescription() {
        itensServices.getItemDescription(itemId: item.id) { response in
            guard let response = response else { return }
            self.descriptionTextView.text = response.plain_text
            
        }
    }
    
    @IBAction private func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func onHeartClick(_ sender: UIButton) {
        var favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
        let findItemOnArray = favoriteItens?.first(where: {$0 == item.id})
        
        if findItemOnArray != nil {
            let index = favoriteItens?.firstIndex(of: item.id)
            if let indexAux = index {
                favoriteItens?.remove(at: indexAux)
                self.userDefaults.set(favoriteItens, forKey: "favoriteItemsArray")
                self.heartUIButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        } else {
            favoriteItens?.append(item.id)
            self.userDefaults.set(favoriteItens, forKey: "favoriteItemsArray")
            self.heartUIButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}
