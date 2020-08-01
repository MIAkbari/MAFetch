//
//  APIClient.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation
import Alamofire


class APIClient {}

class FetchSettings {
    
    static let defult = FetchSettings()
    public var fetchTimeoutIntervalForRequest = Double()
   // public var FetchTimeoutIntervalForUpload = Double()
    public var error_Show:Bool = false
}


public typealias Service<Response> = (_ completionHandler: @escaping (Result<Response, Error>) -> Void) -> Void

public var reachability = NetworkReachabilityManager()

class FetchSession: Session {
    static let session: FetchSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = FetchSettings.defult.fetchTimeoutIntervalForRequest // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = FetchSettings.defult.fetchTimeoutIntervalForRequest // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return FetchSession(configuration: configuration)
    }()
}



@propertyWrapper
public struct Fetch<T> where T: Codable {
    
    fileprivate var url: URL
    fileprivate var parameters:[String:Any] = [:]
    fileprivate var headers:HTTPHeaders = [:]
    fileprivate var method:HTTPMethod = .get
    fileprivate var encoding:ParameterEncoding = URLEncoding.default
    
    public init(url: String,body:[String:Any]? = nil,headers:HTTPHeaders? = nil,method:HTTPMethod? = .get,encoding:ParameterEncoding = URLEncoding.default) {
        self.url = URL(string: url)!
        self.parameters = body ?? ["":""]
        self.headers = headers ?? ["":""]
        self.method = method!
        self.encoding = encoding
    }
    
    public var wrappedValue: Service<T> {
        get {
            return { completion in
                self.skipNetwork { result in
                    completion(result)
                }
            }
        }
    }
    
   fileprivate func skipNetwork(completion:@escaping(Result<T, Error>)->Void) {
        if reachability?.isReachable ?? true{
            self.fetchReguest { result in
                completion(result)
            }
        } else {
            let action =  UIAlertAction(title: "ok", style: .default, handler: { _ in
                self.skipNetwork { (result) in
                    completion(result)
                }
            })
            Alert.share.setAlertError(title: "Network Error", message: "Please Check Conections", action: [action])
        }
    }
    
    
    fileprivate func fetchReguest(completion:@escaping(Result<T, Error>)->Void) {
        FetchSession.session.request(self.url, method: self.method,parameters: self.parameters, encoding:self.encoding , headers: self.headers, interceptor: nil).responseData(queue:.main) { (response: AFDataResponse<Data>) in
            guard let statusCode = response.response?.statusCode else {return}
            if statusCode == 403 || statusCode == 401{
                print(statusCode)
            } else {
                print("statusCode: \(statusCode)")
                switch response.result {
                case .success(let data):
                    
                    do {
                        let responseData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(responseData))
                    } catch let error {
                        let action =  UIAlertAction(title: "ok", style: .default, handler: { _ in
                            self.skipNetwork { (result) in
                                completion(result)
                            }
                        })
                        Alert.share.setAlertError(title: "Error", message: error.localizedDescription, action: [action])
                        print("catch_error: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    let action =  UIAlertAction(title: "ok", style: .default, handler: { _ in
                        self.skipNetwork { (result) in
                            completion(result)
                        }
                    })
                    Alert.share.setAlertError(title: "Request Error", message: error.localizedDescription, action: [action])
                    print("AF_Exit_One \(error)")
                    completion(.failure(error))
                }
            }
        }.responseJSON(queue: .main) { response in
            
            if response.error?.errorDescription != nil {
                let action =  UIAlertAction(title: "ok", style: .default, handler: { _ in
                    self.skipNetwork { (result) in
                        completion(result)
                    }
                })
                Alert.share.setAlertError(title: "Request Error", message: response.error?.errorDescription ?? "Empty", action: [action])
                print("Fetch Error:\(response.error.debugDescription)")
            }
            
        }
    }
}

class Alert {
    class share {
        
        class func setAlertError(title:String,message:String,action:[UIAlertAction]) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
                
                action.forEach { actionAlert in
                    alert.addAction(actionAlert)
                }
                if let keyWindow = UIWindow.key {
                    if FetchSettings.defult.error_Show {
                        keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        class func alert(title:String,message:String,action:[UIAlertAction]? = nil) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
                
                action?.forEach { actionAlert in
                    alert.addAction(actionAlert)
                }
                if let keyWindow = UIWindow.key {
                    keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            
            
        }
        
    }
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
