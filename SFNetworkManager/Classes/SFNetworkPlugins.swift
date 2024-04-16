//
//  SFNetworkPlugins.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/3/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Moya

#if canImport(SFNetworkMonitor)
import SFNetworkMonitor
#endif

#if canImport(SVProgressHUD)
import SVProgressHUD
#endif

/// 根据项目实际需要去配置
class IndicatorPlugin: PluginType {
#if !canImport(SVProgressHUD)
    /// Indicator
    lazy var activityView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let view = UIActivityIndicatorView.init()
            view.activityIndicatorViewStyle = .large
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.hidesWhenStopped = true
            view.color = .white
            view.transform = CGAffineTransformMakeScale(2.5, 2.5)
            return view
        } else {
            let view = UIActivityIndicatorView.init()
            view.activityIndicatorViewStyle = .whiteLarge
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.hidesWhenStopped = true
            view.color = .white
            view.transform = CGAffineTransformMakeScale(2.5, 2.5)
            return view
        }
    }()
#endif
    
    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
#if canImport(SFNetworkMonitor)
        if SFNetworkMonitor.shared.netStatus == .noNet {
            SFNetworkManager.APIProvider.session.cancelAllRequests()
        }
#endif
        
        if isShowLoading {
            DispatchQueue.main.async {
#if canImport(SVProgressHUD)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
                SVProgressHUD.setBackgroundLayerColor(UIColor.init(white: 0.4, alpha: 1))
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setForegroundColor(.black)
                SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
                SVProgressHUD.show(withStatus: "加载中...")
                SVProgressHUD.setMinimumDismissTimeInterval(30.0)
#else
                self.activityView.center = UIApplication.shared.windows.first { $0.isKeyWindow }!.center
                UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(self.activityView)
                self.activityView.startAnimating()
#endif
            }
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
#if canImport(SVProgressHUD)
            SVProgressHUD.dismiss()
#else
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
#endif
        }
    }
}
