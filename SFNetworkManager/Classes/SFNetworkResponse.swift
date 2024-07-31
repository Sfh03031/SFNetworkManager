//
//  SFNetworkResponse.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/3/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

/// 返回数据结构体，根据项目实际情况配置
public struct SFNetworkResponse: HandyJSON {
    /// 正常code = 200
    var code: Int = 0
    var results: SFNetworkResults?
    
    public init() {}
    
    public struct SFNetworkResults: HandyJSON {
        /// 正常ret = 100
        var ret: Int = 0
        var msg: String?
        var body: [String: Any]?
        
        public init() {}
    }
}
