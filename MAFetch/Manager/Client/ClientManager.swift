//
//  ClientManager.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation

extension APIClient {

    
    // work
    @Fetch<Welcome>(url: BaseURL.defult.base + "/cities/state")
    static var fetchState: Service<Welcome>
        
}




