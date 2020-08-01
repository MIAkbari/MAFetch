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
        self.view.backgroundColor = .red
    }
    
    
    
    func fetchData() {
        
        APIClient.state.state { model in
            print("model:\(model)")
        }
        
    }

    
}
