//
//  AlamoFireApiClient.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 28/06/22.
//

import Foundation
import Alamofire

class AlamofireApiClient {
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer your_token",
        "Accept": "application/json"
    ]
    
    func get(url: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url, headers: headers).response { response in
            completion(response.result)
        }
    }
}
