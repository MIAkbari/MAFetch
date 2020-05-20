//
//  APIClient.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
  

}




public typealias Service<Response> = (_ completionHandler: @escaping (Result<Response, Error>) -> Void) -> Void

@propertyWrapper
public struct Fetch<T> where T: Codable {
    
    private var url: URL
    var parameters:[String:Any] = [:]
    var method:HTTPMethod = .get
    
    public init(url: String,body:[String:Any]? = nil,method:HTTPMethod? = .get) {
        self.url = URL(string: url)!
        parameters = body ?? ["":""]
        self.method = method!
    }
    
    public var wrappedValue: Service<T> {
        get {
            return { completion in
                AF.request(self.url, method: self.method, parameters: self.parameters, headers: nil, interceptor: nil).responseData { (response: AFDataResponse<Data>) in
                    switch response.result {
                    case .success(let data):
                        if response.response?.statusCode == 200 {
                            let responseData = try! JSONDecoder().decode(T.self, from: data)
                            completion(.success(responseData))
                        } else {
                            /////
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                }
            }
        }
    }
}
