//
//  Item.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 05/07/22.
//

import Foundation
import UIKit

struct Category: Codable {
    let category_id: String
}

struct TopTwentyResponse: Codable {
    let content: [Item]
}

struct Item: Codable {
    let id: String
}

struct BodyItemsResponse: Codable {
    let body: InfoItem
}

struct InfoItem: Codable {
    let id: String
    let title: String
    let price: Double
    let sold_quantity: Int
    let available_quantity: Int
    let pictures: [Picture]
}

struct Picture: Codable {
    let url: String
    let secure_url: String
}

struct DescriptionResponse: Codable {
    let plain_text: String
}

struct itemCellData {
    let title: String
    let price: String
    let descriptionOne: String
    let descriptionTwo: String
    let image: UIImage
}
