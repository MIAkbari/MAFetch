//
//  ClientManager.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation

extension APIClient {
    
    class login {
        
        // work
          @Fetch<[Todo]>(url: "https://jsonplaceholder.typicode.com/todos")
          static var fetchTodos: Service<[Todo]>
          
          // you add any method for post
          @Fetch<Todo>(url: "https://jsonplaceholder.typicode.com/todos",body:["id":10], method:.post)
          static var fetchMusic: Service<Todo>
          
          // you add any method for post
          @Fetch<Todo>(url: "https://jsonplaceholder.typicode.com/todos",body:["id":10], method:.delete)
          static var fetchdelete: Service<Todo>
    }
}
