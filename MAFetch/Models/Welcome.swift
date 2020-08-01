//
//  Todo.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let message: Message
    let data: [String]
}

// MARK: - Message
struct Message: Codable {
    let status: Int
    let text: String
}

