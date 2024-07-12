//
//  ExampleService.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/3/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Moya

/// 接口枚举，建议带参的一律用字典来传参
public enum ExampleService {
    /// 底部导航信息
    case tabbarInfo(parameters:[String:Any])
    /// 轮播图信息
    case bannerInfo(parameters:[String:Any])
    /// 分类菜单
    case categoryInfo(parameters:[String:Any])
    /// 分类菜单下内容列表
    case listInfo(parameters:[String:Any])
    /// 分页信息
    case pageListInfo(parameters:[String:Any])
    /// 版本升级
    case upgradeInfo(parameters:[String:Any])
    /// 上传图片
    /// - Parameters:
    ///   - files: 图片对象数组
    ///   - name: 名字
    ///   - parameters: 其它参数
    case uploadImgs(files: [UIImage], name: String, parameters: [String: Any])
}

extension ExampleService: TargetType {
    
    static let hostUrl = "https://www.XXXXXX.com"
    
    /// 请求根地址
    public var baseURL: URL {
        return URL(string: Self.hostUrl)!
    }
    
    /// 接口名
    public var path: String {
        switch self {
        case .tabbarInfo:
            return "gwapi/workbenchserver/api/workbench/navgation"
        case .bannerInfo:
            return "gwapi/workbenchserver/api/workbench/getplaypic"
        case .categoryInfo:
            return "gwapi/workbenchserver/api/workbench/navgation"
        case .listInfo:
            return "gwapi/workbenchserver/api/workbench/first/page"
        case .pageListInfo:
            return "gwapi/workbenchserver/api/workbench/getmore"
        case .upgradeInfo:
            return "gwapi/workbenchserver/api/workbench/upgrade"
        case .uploadImgs:
            return "gwapi/workbenchserver/api/workbench/upgrade"
        }
    }
    
    /// 请求方法
    public var method: Moya.Method {
        return .post
    }
    
    /// 用于单元测试的数据
    public var sampleData: Data {
        "".data(using: .utf8) ?? Data()
    }
    
    /// 请求任务
    public var task: Moya.Task {
        // ↓↓↓ get请求不带参用A带参用B，post请求用C，注意encoding方式的不同 ↓↓↓
        //
        // A: return .requestPlain
        // B: return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        // C: return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        // D: return .uploadMultipart([MultipartFormData])
        // E: return .uploadCompositeMultipart([MultipartFormData], urlParameters: [:])
        //
        // ↑↑↑ get请求不带参用A带参用B，post请求用C，注意encoding方式的不同 ↑↑↑
        
        switch self {
        case .tabbarInfo(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .bannerInfo(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .categoryInfo(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .listInfo(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .pageListInfo(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .upgradeInfo(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .uploadImgs(files: let files, name: let name, parameters: let parameters):
            var formDatas = [MultipartFormData]()
            for image in files {
                let imageData = image.jpegData(compressionQuality: 0.5)
                let fileName = "iOS\(Date().timeIntervalSince1970).png"
                let formData = MultipartFormData(provider: .data(imageData!), name: name, fileName: fileName, mimeType: "image/png")
                formDatas.append(formData)
            }
            
            // MARK: 具体用哪个方法要根据后台接收图片数据的方式来选择，注意encoding方式的不同
            
            // 方式一：
//            return .uploadCompositeMultipart(formDatas, urlParameters: parameters)
            
            // 方式二：
            for item in parameters {
                let value = item.value as? String ?? ""
                let formData = MultipartFormData(provider: .data(value.data(using: String.Encoding.utf8)!), name: item.key)
                formDatas.append(formData)
            }
            
            return .uploadMultipart(formDatas)
        }
    }
    
    /// 请求头
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
