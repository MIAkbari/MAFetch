//
//  ViewController.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
    }
    
    
    func fetchData() {
        
        APIClient.login.fetchTodos { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }


}

