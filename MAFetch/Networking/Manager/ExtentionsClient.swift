//
//  ExtentionsClient.swift
//  MAFetch
//
//  Created by MohammadAkbari on 05/10/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension APIClient {
    
    @Fetch<Welcome>(BaseURL.defults.base,method:.get)
    static var fetchState: Service<Welcome>
    
    @Fetch<Welcome>(BaseURL.defults.base,method:.post)
    static var fetchStatePost: Service<Welcome>
    
}
