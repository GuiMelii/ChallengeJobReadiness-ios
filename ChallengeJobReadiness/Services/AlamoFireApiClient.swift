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
        "Authorization": "Bearer APP_USR-2299496188847258-062909-2260ecc2ee6f25186ebe951998947222-1073987558",
        "Accept": "application/json"
    ]
    
    func get(url: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url, headers: headers).response { response in
            completion(response.result)
        }
    }
}
