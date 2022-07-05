//
//  ItensServices.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 28/06/22.
//

import Foundation

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


class ItensServices {
    let apiClient = AlamofireApiClient()
    
    
    func getCategoriesCode(of searchText: String, completion: @escaping ([Category]?) -> Void) {
        let categoriesURL = "https://api.mercadolibre.com/sites/MLM/domain_discovery/search?limit=1&q=\(searchText)"
        
        apiClient.get(url: categoriesURL) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let categories = try JSONDecoder().decode([Category].self, from: data)
                        print("CATEGORIES ✅", categories)
                        completion(categories)
                    }
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getTopTwentyByCategory(category_id: String, completion: @escaping (TopTwentyResponse?) -> Void) {
        let topTwentyURL = "https://api.mercadolibre.com/highlights/MLM/category/\(category_id)"
        
        print(topTwentyURL)
        apiClient.get(url: topTwentyURL) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let topTwenty = try JSONDecoder().decode(TopTwentyResponse.self, from: data)
                        completion(topTwenty)
                    }
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
            
        }
    }
    
    func getInfoByItemId(itemsIds: String, completion: @escaping ([BodyItemsResponse]?) -> Void) {
        let multiItemURL = "https://api.mercadolibre.com/items\(itemsIds)"
                
        apiClient.get(url: multiItemURL) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        print("data", data)
                        let itens = try JSONDecoder().decode([BodyItemsResponse].self, from: data)
                        completion(itens)
                    }
                } catch {
                    print("error")

                    completion(nil)
                }
            case .failure(let error):
                print("error", error)
                completion(nil)
            }
        }
    }
    
    func getItemDescription(itemId: String, completion: @escaping (DescriptionResponse?) -> Void) {
        let url = "https://api.mercadolibre.com/items/\(itemId)/description"

        apiClient.get(url: url) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let itens = try JSONDecoder().decode(DescriptionResponse.self, from: data)
                        completion(itens)
                    }
                } catch {
                    print("error")
                    completion(nil)
                }
            case .failure(let error):
                print("error", error)
                completion(nil)
            }
        }
    }
}
