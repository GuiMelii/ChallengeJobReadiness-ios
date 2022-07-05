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
        "Authorization": "Bearer APP_USR-2299496188847258-070509-4ef51a58d44d2b2783066776ba73fc6b-1073987558",
        "Accept": "application/json"
    ]
    
    func get(url: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url, headers: headers).response { response in
            completion(response.result)
        }
    }
}
