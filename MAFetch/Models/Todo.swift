//
//  Todo.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation


struct Todo: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
