//
//  Defults.swift
//  MAFetch
//
//  Created by MohammadAkbari on 01/08/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa



extension APIClient {
    
    
    func state(complation:@escaping (Welcome)->Void) {
        APIClient.$fetchState
            .set(path: "/cities/state")
        
        APIClient.fetchState { model in
            complation(model)
        }
    }
    
    
    func postState(id:Int,complation:@escaping (Welcome)->Void) {
        APIClient.$fetchStatePost
            .set(path: "/cities/post/state")
            .set(headers: ["ApplicationJson":"ContentType"])
            .set(parameters: .body(["name":id])) // with URL and Form
        
        APIClient.fetchStatePost { model in
            complation(model)
        }
    }
    
   
    
}
