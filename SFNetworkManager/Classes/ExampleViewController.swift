//
//  ExampleViewController.swift
//  SFNetworkManager_Example
//
//  Created by sfh on 2024/3/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import HandyJSON

class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 查询底部导航
        let target = ExampleService.tabbarInfo(parameters: ["id": "业务模块id", "other": "其他需要参数"])
        SFNetworkManager.request(target: target, modelType: TabbarInfoModel.self) { msg, model in
            print("请求成功")
        } failure: { error in
            print("请求失败")
        }

        /// 查询轮播图
        let target1 = ExampleService.bannerInfo(parameters: ["navigationBtmId": "底部导航id", "id": "业务模块id"])
        SFNetworkManager.request(target: target1, modelType: TabbarInfoModel.self) { msg, model in
            print("请求成功")
        } failure: { error in
            print("请求失败")
        }
        
        /// 查询分类菜单
        let target2 = ExampleService.categoryInfo(parameters: ["navigationBtmId": "底部导航id", "id": "业务模块id", "userId": "用户id"])
        SFNetworkManager.request(target: target2, modelType: TabbarInfoModel.self) { msg, model in
            print("请求成功")
        } failure: { error in
            print("请求失败")
        }
        
        /// 查询内容列表
        let target3 = ExampleService.listInfo(parameters: ["navigationBtmId": "底部导航id", "id": "业务模块id", "categoryId": "二级分类id"])
        SFNetworkManager.request(target: target3, modelType: listInfoModel.self) { msg, model in
            print("请求成功")
        } failure: { error in
            print("请求失败")
        }
        
        /// 查询分页内容列表
        let target4 = ExampleService.pageListInfo(parameters: ["navigationBtmId": "底部导航id", "id": "业务模块id", "categoryId": "二级分类id", "pageNum": "页码", "pageSize": "每页条数"])
        SFNetworkManager.request(target: target4, modelType: listInfoModel.self) { msg, model in
            print("请求成功")
        } failure: { error in
            print("请求失败")
        }
        
        /// 查询版本升级
        let target5 = ExampleService.upgradeInfo(parameters: ["serverVersionName": "版本名称", "appPackageName": "包名", "serverVersionCode": "版本号", "md5": "包名对应的md5值 32位小写", "id": "应用id"])
        SFNetworkManager.request(target: target5, modelType: upgradeInfoModel.self) { msg, model in
            print("请求成功")
        } failure: { error in
            print("请求失败")
        }
    }

}

/// 底部导航模型
struct TabbarInfoModel: HandyJSON {
    /// 详情跳转id
    var id: String?
    /// 广告图片url
    var img: String?
    /// 名称
    var name: String?
    /// 协议链接
    var url: String?
    /// 是否可用
    var enable: Bool?
    /// 预留字段1
    var img_normal: String?
    /// 预留字段2
    var img_press: String?
    /// 预留字段3
    var force_login: String?
    /// 预留字段4
    var isShow: Bool?
    /// 预留字段5
    var state: String?
}

/// 内容列表模型
struct listInfoModel: HandyJSON {
    var list: [infoListModel]?
    
    struct infoListModel: HandyJSON {
        /// 详情跳转id
        var id: String?
        /// 广告图片url
        var img: String?
        /// 名称
        var name: String?
        /// 协议链接
        var url: String?
        /// 是否可用
        var enable: Bool?
    }
    
}

/// 版本升级模型
struct upgradeInfoModel: HandyJSON {
    /// 安装包路径
    var apkPath: String?
    /// 版本编码
    var serverVersionCode: String?
    /// 版本名称
    var serverVersionName: String?
    /// 包名
    var appPackageName: String?
    /// 更新标题
    var updateInfoTitle: String?
    /// 更新内容
    var updateInfo: String?
    /// 包名md5
    var md5: String?
    /// 是否强制更新
    var isForce: Bool?
    /// 更新背景图
    var upgradeBackImg: String?
    /// 应用名称
    var applicationLable: String?
}
