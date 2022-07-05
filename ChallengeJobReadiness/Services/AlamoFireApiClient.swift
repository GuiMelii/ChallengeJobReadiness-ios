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
        "Authorization": "Bearer APP_USR-2299496188847258-070515-47ef9fa4726485ec11d198dec4d91d8a-1073987558",
        "Accept": "application/json"
    ]
    
    func get(url: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url, headers: headers).response { response in
            completion(response.result)
        }
    }
}
