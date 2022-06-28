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

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    var items: [itemCellData] = [itemCellData(title: "Polenta Taycan 4s", price: "$ 2.000.000", descriptionOne: "2020 - 10.000km", descriptionTwo: "two", image: UIImage(imageLiteralResourceName: "porsche")), itemCellData(title: "Porsche Taycan 4s", price: "$ 2.000.000", descriptionOne: "2020 - 10.000km", descriptionTwo: "two", image: UIImage(imageLiteralResourceName: "porsche")),itemCellData(title: "Porsche Taycan 4s", price: "$ 2.000.000", descriptionOne: "2020 - 10.000km", descriptionTwo: "two", image: UIImage(imageLiteralResourceName: "porsche")), itemCellData(title: "Porsche Taycan 4s", price: "$ 2.000.000", descriptionOne: "2020 - 10.000km", descriptionTwo: "two", image: UIImage(imageLiteralResourceName: "porsche")),itemCellData(title: "Porsche Taycan 4s", price: "$ 2.000.000", descriptionOne: "2020 - 10.000km", descriptionTwo: "two", image: UIImage(imageLiteralResourceName: "porsche")), itemCellData(title: "Porsche Taycan 4s", price: "$ 2.000.000", descriptionOne: "2020 - 10.000km", descriptionTwo: "two", image: UIImage(imageLiteralResourceName: "porsche"))]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.borderStyle = .none
        searchTextField.isEnabled = true
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        itemsTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        itemsTableView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        let cell = Bundle.main.loadNibNamed("ItemTableViewCell", owner: self, options: nil)?.first as! ItemTableViewCell

        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.priceLabel.text = item.price
        cell.descriptionOneLabel.text = item.descriptionOne
        cell.descriptionTwoLabel.text = item.descriptionTwo
        cell.itemUIImage.image = item.image
        //        let item = items[indexPath.row]
        //        var configuration = UIListContentConfiguration.cell()
        //        configuration.text = item
        //        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        //let item = items[indexPath.row]
    //        //        navigateToSuggestionViewController(categoryType: category)
    //    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    
}
