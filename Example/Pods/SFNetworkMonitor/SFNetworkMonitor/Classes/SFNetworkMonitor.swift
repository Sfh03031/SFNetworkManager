//
//  SFNetworkMonitor.swift
//  SFNetworkMonitor_Example
//
//  Created by sfh on 2024/3/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#if canImport(Reachability)

import UIKit
import Reachability

@objc public enum SFNetStatus: Int {
    /// 无网络
    case noNet = 0
    /// wifi
    case wifi = 1
    /// 移动流量
    case cellular = 2
}

@objc open class SFNetworkMonitor: NSObject {
    /// 单例
    @objc public static let shared = SFNetworkMonitor()
    /// 无网络时是否弹窗提示
    @objc public var isShowAlertWhenNoNet = false
    /// 网络状态
    @objc public var netStatus: SFNetStatus = .noNet
    /// 网格状态改变的通知名称
    @objc public static let kNotificationNameNetworkChanged = NSNotification.Name(rawValue: "SFNetworkMonitorNetworkChanged")
    /// 是否在监听网络状态
    @objc public var isMonitoring: Bool = false
    
    fileprivate var reachability: Reachability?
    fileprivate var alert: UIAlertController?
    
    /// 开始监听
    /// - Parameter useClosures: 是否使用闭包，也会发通知
    @objc public func monitoring(useClosures: Bool = true) {
        self.isMonitoring = true
        let reachability = try? Reachability()
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { [weak self] reachability in
                if reachability.connection == .wifi {
                    self?.netStatus = .wifi
                    self?.alert?.dismiss(animated: true, completion: nil)
                } else if reachability.connection == .cellular {
                    self?.netStatus = .cellular
                    self?.alert?.dismiss(animated: true, completion: nil)
                } else {
                    self?.netStatus = .noNet
                    self?.showAlertIfNoNet()
                }
                NotificationCenter.default.post(name: Self.kNotificationNameNetworkChanged, object: self?.netStatus)
            }
            reachability?.whenUnreachable = { [weak self] _ in
                self?.netStatus = .noNet
                self?.showAlertIfNoNet()
                NotificationCenter.default.post(name: Self.kNotificationNameNetworkChanged, object: self?.netStatus)
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    /// 结束监听
    @objc public func stopMonitoring() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    /// 通知方法
    @objc func reachabilityChanged(_ note: Notification) {
        if let reachability = note.object as? Reachability {
            if reachability.connection == .wifi {
                self.netStatus = .wifi
                self.alert?.dismiss(animated: true, completion: nil)
            } else if reachability.connection == .cellular {
                self.netStatus = .cellular
                self.alert?.dismiss(animated: true, completion: nil)
            } else {
                self.netStatus = .noNet
                self.showAlertIfNoNet()
            }
            NotificationCenter.default.post(name: Self.kNotificationNameNetworkChanged, object: self.netStatus)
        }
    }
    
    deinit {
        stopMonitoring()
    }
}

extension SFNetworkMonitor {
    
    /// 无网络时弹提示
    fileprivate func showAlertIfNoNet() {
        if isShowAlertWhenNoNet {
            alert = UIAlertController(title: "提示", message: "网络未连接, 请进行网络设置", preferredStyle: .alert)
            guard let alert = alert else { return }
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "前往设置", style: .default, handler: { _ in
                if let url = URL(string: "App-Prefs:root") {
                    UIApplication.shared.open(url)
                }
            }))
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    /// 在需要的地方主动调用
    @objc public func showAlertIfCellular(ignore: (() -> Void)?, goBack: (() -> Void)?) {
        if netStatus == .cellular {
            alert = UIAlertController(title: "提示", message: "您正在使用数据流量进行浏览, 是否需要修改网络设置", preferredStyle: .alert)
            guard let alert = alert else { return }
            alert.addAction(UIAlertAction(title: "继续", style: .cancel, handler: { _ in
                ignore?()
            }))
            alert.addAction(UIAlertAction(title: "前往设置", style: .default, handler: { _ in
                goBack?()
                if let url = URL(string: "App-Prefs:root") {
                    UIApplication.shared.open(url)
                }
            }))
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

#endif
