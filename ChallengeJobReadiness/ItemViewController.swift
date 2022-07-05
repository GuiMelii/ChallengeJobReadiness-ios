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
        
        let favoriteItens = self.userDefaults.array(forKey: "favoriteItemsArray") as! [String]?
        let findItemOnArray = favoriteItens?.first(where: {$0 == item.id})
        
        if findItemOnArray != nil {
            self.heartUIButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        self.subtitleLabel.text = item.title
        self.titleLabel.text = item.title
        self.priceLabel.text = "$\(item.price)"
        self.soldQuantityLabel.text = "Vendidos totales: \(item.sold_quantity)"
        self.availableQuantityLabel.text = "Disponibles: \(item.available_quantity)"
        
        if let url = URL(string: item.pictures[0].secure_url) {
            UIImage.loadFrom(url: url) { image in
                self.mainImageView.image = image
            }
        } else {
            self.mainImageView.image = UIImage(imageLiteralResourceName: "porsche")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDescription()
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
    
    @IBAction private func onClickWhatsapp(_ sender: Any) {}
    
    
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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
