//
//  HeadersManager.swift
//  MAFetch
//
//  Created by MohammadAkbari on 01/08/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation
import Alamofire

class FetchHeaders {
    
    static let share = FetchHeaders()
    
    func Golobal()->HTTPHeaders {
        let headers:HTTPHeaders = ["one":"two"]
        return headers
    }
}
