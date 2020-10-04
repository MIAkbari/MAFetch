//
//  ViewController.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay



class ViewController: UIViewController {

    let label = UILabel()
        .forgroundColor(color: .black)
        .alignment(.center)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    
    
    func fetchData() {
        
        APIClient.share.state { model in
            print(model.data)
        }
        
    }

    
}


extension UILabel {
    
    @discardableResult
    public func forgroundColor(color:UIColor)->Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment:NSTextAlignment)->Self {
        self.textAlignment = alignment
        return self
    }

}




// MARK: CD - USE APPDELEGATE
class Application {
    
    private var rootController:UIViewController = UIViewController()
    private var isNavigation:Bool = false
    
    
    @discardableResult
    func viewController(_ viewController:UIViewController)->Self {
        self.rootController = viewController
        return self
    }
    
    @discardableResult
    func addNavigation()->Self {
        self.isNavigation.toggle()
        return self
    }
    @discardableResult
    func start(_ window:UIWindow?)->Self {
        if isNavigation {
            let navigation = UINavigationController(rootViewController: rootController)
            window?.rootViewController = navigation
        } else {
            window?.rootViewController = rootController
        }
        window?.makeKeyAndVisible()
        return self
    }

    
}
