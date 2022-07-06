//
//  ItensServices.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 28/06/22.
//

import Foundation

final class ItensServices {
    let apiClient = AlamofireApiClient()
    let baseUrl = "https://api.mercadolibre.com"
    
    func getCategoriesCode(of searchText: String, completion: @escaping ([Category]?) -> Void) {
        let categoriesURL = baseUrl + "/sites/MLB/domain_discovery/search?limit=1&q=\(searchText)"
        
        print(categoriesURL)
        apiClient.get(url: categoriesURL) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let categories = try JSONDecoder().decode([Category].self, from: data)
                        completion(categories)
                    }
                } catch {
                    print("ERRO getcatego")
                    completion(nil)
                }
            case .failure(let error):
                print("ERRO")
                print("❌", error)
                completion(nil)
            }
        }
    }
    
    func getTopTwentyByCategory(category_id: String, completion: @escaping (TopTwentyResponse?) -> Void) {
        let topTwentyURL = baseUrl + "/highlights/MLB/category/\(category_id)"
        
        apiClient.get(url: topTwentyURL) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let topTwenty = try JSONDecoder().decode(TopTwentyResponse.self, from: data)
                        completion(topTwenty)
                    }
                } catch(let error) {
                    print("❌", error)
                    completion(nil)
                }
            case .failure(let error):
                print("❌", error)
                completion(nil)
            }
            
        }
    }
    
    func getInfoByItemId(itemsIds: String, completion: @escaping ([BodyItemsResponse]?) -> Void) {
        let multiItemURL = baseUrl + "/items\(itemsIds)"
                
        apiClient.get(url: multiItemURL) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        print("data", data)
                        let itens = try JSONDecoder().decode([BodyItemsResponse].self, from: data)
                        completion(itens)
                    }
                } catch(let error) {
                    print("❌", error)
                    completion(nil)
                }
            case .failure(let error):
                print("❌", error)
                completion(nil)
            }
        }
    }
    
    func getItemDescription(itemId: String, completion: @escaping (DescriptionResponse?) -> Void) {
        let url = baseUrl + "/items/\(itemId)/description"

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
                print("❌", error)
                completion(nil)
            }
        }
    }
}
