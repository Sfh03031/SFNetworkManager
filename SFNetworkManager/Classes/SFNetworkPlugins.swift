//
//  SFNetworkPlugins.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/3/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Moya
import SFNetworkMonitor

/// 根据项目实际需要去配置
class IndicatorPlugin: PluginType {

    /// Indicator
    lazy var activityView: SFNetworkIndicator = {
        let view = SFNetworkIndicator(frame: UIScreen.main.bounds, message: "loading...", type: .circleStrokeSpin, style: .light)
//        view.hudBackgroundColor = .systemTeal
//        view.indicatorColor = .systemPink
//        view.textColor = .brown
//        view.maxWith = 300.0
//        view.padding = 10.0
//        view.margin = 5.0
//        view.indicatorWH = 60.0
//        view.textFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
//        view.radius = 10.0
//        view.offset = 20.0
//        view.maskColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
        DispatchQueue.main.async {
            if SFNetworkMonitor.shared.isMonitoring && SFNetworkMonitor.shared.netStatus == .noNet {
                SFNetworkManager.APIProvider.session.cancelAllRequests()
                return
            }
            if isShowLoading {
                self.activityView.frame = UIApplication.shared.windows.first { $0.isKeyWindow }!.bounds
                UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(self.activityView)
            }
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            self.activityView.removeFromSuperview()
        }
    }
}
