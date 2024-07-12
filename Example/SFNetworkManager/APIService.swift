//
//  APIService.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/7/3.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Moya

public enum APIService {
    case yourRequestName(parameters:[String:Any])
}

extension APIService: TargetType {
    public var baseURL: URL {
        return URL(string: "https://xxxx.xxxxxx.xx/")!
    }
    
    public var path: String {
        return "xxx/xxxx"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .yourRequestName(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String : String]? {
        var header: [String: String] = [:]
        
        header.updateValue("application/json", forKey: "Content-Type")
        
        return header
    }
    
    
}
