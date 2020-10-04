//
//  APIClient.swift
//  MAFetch
//
//  Created by MohammadAkbari on 20/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import RxRelay


// MARK: - API CLIENT FOR BASE SERVICE
class APIClient {
    static let share = APIClient()
}


// MARK: - fetchSettings : use app delegate
class FetchSettings {
    
    static let defult = FetchSettings()
    public var fetchTimeoutIntervalForRequest:Double = 15
    // public var FetchTimeoutIntervalForUpload = Double()
    public var error_Show:Bool = true
}


// MARK: - service complations
public typealias Service<Response> = (_ completionHandler: @escaping (Response) -> Void) -> Void

// MARK: - is network or not
public var reachability = NetworkReachabilityManager()

// MARK: - settings for reguest
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




// MARK: - use propery wrapper make for easy use

@propertyWrapper
public class Fetch<T> where T: Codable {
    
    // MARK: - varibales
    
    private var url: String = ""
    private var path: String = ""
    private var method: HTTPMethod = .get
    private var headers: HTTPHeaders = .default
    private var parameters: [String:Any]? = nil
    private var encoding:ParameterEncoding = URLEncoding.default
    
    // MARK: - return value
    public var projectedValue: Fetch<T> { return self }
    
    // MARK: - init method and url
    public init(_ url: String,method:HTTPMethod? = .get) {
        self.url = url
        self.method = method!
    }
    
    
    // MARK: - set path if url not base
    @discardableResult
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    // MARK: - header for auth
    @discardableResult
    public func set(headers: HTTPHeaders) -> Self {
        self.headers = headers
        return self
    }
    
    // MARK: - parameters , query(url) , formData , body
    @discardableResult
    public func set(parameters: RequestParameters) -> Self {
        switch parameters {
        case .body(let value):
            self.parameters = value
            self.encoding = JSONEncoding.default
        case .url(let value):
            self.parameters = value
            self.encoding = URLEncoding.queryString
        case .form(let value):
            self.parameters = value
            self.encoding = URLEncoding.default
        }
        return self
    }
    
    
    // MARK: - value set
    public var wrappedValue: Service<T> {
        get {
            return { completion in
                self.skipNetwork { result in
                    completion(result)
                }
            }
        }
    }
    
    // MARK: - check network
    fileprivate func skipNetwork(completion:@escaping(T)->Void) {
        if reachability?.isReachable ?? true{
            
            self.fetchReguest { result in
                completion(result)
            }
        } else {
            
            let action =  UIAlertAction(title: "Try", style: .default, handler: { _ in
                self.skipNetwork { (result) in
                    completion(result)
                }
            })
            
            let cancel =  UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in})
            Alert.share.setAlertError(title: "Network Error", message: "Please Check Conections", action: [action,cancel])
        }
    }
    
    
    
    
    
    // MARK: - regsuet use AF from session
    fileprivate func fetchReguest(completion:@escaping(T)->Void) {
        FetchSession.session.request(self.url + self.path, method: self.method,parameters: self.parameters, encoding:self.encoding , headers: self.headers, interceptor: nil).responseData(queue:.main) { (response: AFDataResponse<Data>) in
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    // hide progress
                }
            }
            
            guard let statusCode = response.response?.statusCode else {return}
            if statusCode == 403 || statusCode == 401{
                print(statusCode)
            } else {
                print("statusCode: \(statusCode)")
                switch response.result {
                case .success(let data):
                    print(String(data: data, encoding: .utf8) ?? "")
                    do {
                        
                        let responseData = try JSONDecoder().decodeCheck(T.self, from: data)
                        
                        completion(responseData)

                    } catch let error {
                        print("catch_error: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    let action =  UIAlertAction(title: "Try", style: .default, handler: { _ in
                                                self.skipNetwork { (result) in
                            completion(result)
                        }
                    })
                     let cancel =  UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in})
                    Alert.share.setAlertError(title: "Error", message: error.localizedDescription, action: [action,cancel])
                    print("AF_Exit_Error: \(error)")
                }
            }
            
            
            
            
        }.responseJSON(queue: .main) { response in
            // MARK: - show alert
            if response.error?.errorDescription != nil {
                let action =  UIAlertAction(title: "Try", style: .default, handler: { _ in
                    self.skipNetwork { (result) in
                        completion(result)
                    }
                })
                 let cancel =  UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in})
                
                if response.error?.errorDescription == "URLSessionTask failed with error: A server with the specified hostname could not be found." {
                    Alert.share.setAlertError(title: "Error", message: "Please Checked Network.", action: [action,cancel])
                } else if response.error?.errorDescription == "URLSessionTask failed with error: The request timed out." {
                    Alert.share.setAlertError(title: "Error", message: "Please Checked Network.", action: [action,cancel])
                } else {
                    Alert.share.setAlertError(title: "Error", message: response.error?.errorDescription ?? "", action: [action,cancel])

                }
                print("Fetch Error:\(response.error?.errorDescription ?? "")")
            }
            
        }
    }
}

// MARK: - enumt params
public enum RequestParameters {
    
    case body([String:Any]?)
    case url([String: Any]?)
    case form([String: Any]?)
    
    var parameters: [String: Any]? {
        switch self {
        case .body(let parameters), .url(let parameters),.form(let parameters):
            return parameters
        }
    }
}


extension JSONDecoder {
    func decodeCheck<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable  {
       let result = try self.decode(type, from: data)

        if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: Any] {
            let mirror = Mirror(reflecting: result)
            let jsonKeys = json.map { return $0.0 }
            let objectKeys = mirror.children.enumerated().map { $0.element.label }

            jsonKeys.forEach { (jsonKey) in
                if !objectKeys.contains(jsonKey) {
                    print("\(jsonKey) is not used yet")
                }
            }
        }
        return result

    }
}


// MARK: - alert for easy use
class Alert {
    class share {
        
        class func setAlertError(title:String,message:String,action:[UIAlertAction]) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title:title, message: message == "" ? nil : message, preferredStyle: .alert)
                
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
                let alert = UIAlertController(title:title, message: message == "" ? nil : message, preferredStyle: .alert)
                if action?.isEmpty ?? true {
                    let actionOk = UIAlertAction(title: "OK", style: .destructive) { _ in
                        return
                    }
                    alert.addAction(actionOk)
                } else {
                    action?.forEach { actionAlert in
                        alert.addAction(actionAlert)
                    }
                    
                }
                
                if let keyWindow = UIWindow.key {
                    keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
                }
                
            }
            
            
        }
        
        class func sheet(title:String,message:String,action:[UIAlertAction]? = nil) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title:title, message: message == "" ? nil : message, preferredStyle: .actionSheet)
                
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






let app = UIApplication.shared.windows.first { $0.isKeyWindow }
extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}


@propertyWrapper
struct DefaultEmptyArray<T:Codable> {
    var wrappedValue: [T] = []
}

//codable extension to encode/decode the wrapped value
extension DefaultEmptyArray: Codable {
    
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode([T].self)
    }
    
}

extension KeyedDecodingContainer {
    func decode<T:Decodable>(_ type: DefaultEmptyArray<T>.Type,
                forKey key: Key) throws -> DefaultEmptyArray<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
