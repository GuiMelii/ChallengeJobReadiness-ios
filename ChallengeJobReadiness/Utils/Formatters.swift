//
//  Utils.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 05/07/22.
//

import Foundation


func formatToCurrency (value: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "pt-BR") 
    formatter.numberStyle = .currency
    if let formattedTipAmount = formatter.string(from: value as NSNumber) {
        return formattedTipAmount
    }
    
    return nil
}

func reduceUrl(_ response: TopTwentyResponse) -> String {
    var url = "?ids="
    
    for (index, item) in response.content.enumerated() {
        if (index == response.content.count - 1) {
            url += item.id
        } else {
            url += "\(item.id),"
        }
    }
    
    return url
}
