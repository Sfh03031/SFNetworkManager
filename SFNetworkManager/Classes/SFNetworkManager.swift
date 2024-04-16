//
//  SFNetworkManager.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/3/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import HandyJSON
import Moya

/// 超时时长
private(set) var timeoutInterval: Double = 30
/// 是否显示loading，抽成属性，不需要在插件里判断是哪个TargetType
private(set) var isShowLoading: Bool = true

/// 请求前的设置
private let endpointClosure = { (target: TargetType) -> Endpoint in
    // 解决网络请求地址里面含有? 时无法解析的bug
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )

    // 针对某个TargetType的某个请求单独设置超时时长时使用
    if let t = target as? MultiTarget, let t1 = t.target as? ExampleService {
        switch t1 {
        case .tabbarInfo:
            timeoutInterval = 10
            return endpoint
        default:
            return endpoint
        }
    }
    
    return endpoint
}

/// 设置请求时长、打印请求信息
private let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = timeoutInterval

        #if DEBUG
        // 打印请求参数
        if let requestData = request.httpBody {
            print("请求地址: \(request.url!)" + "\n请求方法: " + "\(String(describing: request.httpMethod))" + "\n请求参数: " + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            print("请求地址: \(request.url!)" + "\n请求方法: \(String(describing: request.httpMethod))")
        }

        if let header = request.allHTTPHeaderFields {
            print("请求头内容\(header)")
        }
        #endif

        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

public class SFNetworkManager: NSObject {

    /// 进度回调，默认为nil
    typealias progressBlock = (CGFloat) -> Void

    /// 创建请求对象
    static let APIProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, requestClosure: requestClosure, plugins: [IndicatorPlugin()], trackInflights: false)
    
    /// 核心方法
    ///
    /// - Parameters:
    ///   - target: 遵循TargetType协议的枚举对象
    ///   - modelType: 返回值中的body对象需要转的model类型，需遵循HandyJSON协议
    ///   - isLoading: 是否显示菊花，默认显示
    ///   - progress: 请求进度，默认为nil
    ///   - success: 成功的回调，接口返回值中的msg和body转换后的model
    ///   - failure: 失败的回调，返回错误信息
    static func request<T: HandyJSON>(target: TargetType,
                                             modelType: T.Type,
                                             isLoading: Bool = true,
                                             progress: progressBlock? = nil,
                                             success: @escaping (_ msg: String?, _ model: T?) -> Void,
                                             failure: @escaping (_ error: String?) -> Void)
    {
        isShowLoading = isLoading

        APIProvider.request(MultiTarget(target), callbackQueue: DispatchQueue.main) { progressResponse in
            progress?(CGFloat(progressResponse.progress))
        } completion: { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(),
                   let obj = JSONDeserializer<SFNetworkResponse>.deserializeFrom(dict: json as? [String: Any])
                {
#if DEBUG
                    print("接收到的数据: \(json)")
#endif
                    if obj.code == 200 {
                        if let res = obj.results, res.ret == 100 {
                            if let body = res.body {
                                return success(res.msg, modelType.deserialize(from: body))
                            } else {
                                return success(res.msg, modelType.deserialize(from: [:]))
                            }
                        } else {
#if DEBUG
                            print("无返回数据或数据解析失败: obj.ret=\(String(describing: obj.results?.ret))")
#endif
                            return failure("请求失败")
                        }
                    } else {
#if DEBUG
                        print("无返回数据或数据解析失败: obj.code=\(obj.code)")
#endif
                        return failure("无返回数据或数据解析失败")
                    }
                } else {
#if DEBUG
                    print("数据格式错误: \(response)")
#endif
                    return failure("数据格式错误")
                }
            case .failure(let error):
#if DEBUG
                print(error.errorDescription ?? "网络请求失败")
#endif
                return failure(error.errorDescription ?? "网络请求失败")
            }
        }
    }
}
