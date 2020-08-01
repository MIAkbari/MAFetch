//
//  Defults.swift
//  MAFetch
//
//  Created by MohammadAkbari on 01/08/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation


extension APIClient {
    
    class state {
        
        class func state(complation:@escaping (Welcome)->Void) {
            APIClient.fetchState { result in
                switch result {
                case .success(let model):
                    complation(model)
                case .failure(let err):
                    print("AF_Exit \(err)")
                }
            }
        }

    }
}
