# SFNetworkManager

[![CI Status](https://img.shields.io/travis/Sfh03031/SFNetworkManager.svg?style=flat)](https://travis-ci.org/Sfh03031/SFNetworkManager)
[![Version](https://img.shields.io/cocoapods/v/SFNetworkManager.svg?style=flat)](https://cocoapods.org/pods/SFNetworkManager)
[![License](https://img.shields.io/cocoapods/l/SFNetworkManager.svg?style=flat)](https://cocoapods.org/pods/SFNetworkManager)
[![Platform](https://img.shields.io/cocoapods/p/SFNetworkManager.svg?style=flat)](https://cocoapods.org/pods/SFNetworkManager)

## Introduction

  A network request framework based on Moya and HandyJSON, which can return an object model that follows the HandyJSON protocol and can be flexibly customized according to needs.I have written several examples to demonstrate usage, and the object model can be customized according to requirements by following the HandyJSON protocol.
  
  (zh: 基于Moya、HandyJSON的网络请求框架，可返回遵循HandyJSON协议的对象模型，可根据需求灵活自定义。写了几个例子展示用法，对象模型可按需求进行自定义，只需遵循HandyJSON协议即可。)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
import UIKit
import HandyJSON
import SFNetworkManager

class BallModel: HandyJSON {
    var ballType: String?
    var roomId: String?
    var userId: String?
    var viewertoken: String?
    
    required init() {}
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
            
        SFNetworkManager.request(target: APIService.yourRequestName(parameters: ["positionKey": "0"]), 
                                 modelType: BallModel.self,
                                 isLoading: true,
                                 progress: { progress in
            print("进度: \(progress)")
        }) { msg, model in
            print("msg: \(String(describing: msg))")
            print(model?.ballType as Any)
            print(model?.roomId as Any)
            print(model?.userId as Any)
            print(model?.viewertoken as Any)
        } failure: { error in
            print(error?.debugDescription as Any)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
```
you can see the code in the Example Project.

## Requirements

* iOS 12.0 or later
* Swift 5.9.2
* Xcode 15.1

## Installation

SFNetworkManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SFNetworkManager'
```

If you want to use the latest features of SFNetworkManager use normal external source dependencies.

```ruby
pod 'SFNetworkManager', :git => 'https://github.com/Sfh03031/SFNetworkManager.git'
```

## Change log

2024.07.31, 0.1.3
- fix bug and update readme(zh: 修复bug、更新readme)

2024.07.12, 0.1.2
- code optimize, add new indicatorView(zh: 代码优化，新增指示器)

2024.04.16, 0.1.1
- update plugin(zh: 更新插件)
    
2024.03.12, 0.1.0
- Initial version(zh: 初始版本)

## Author

Sfh03031, sfh894645252@163.com

## License

SFNetworkManager is available under the MIT license. See the LICENSE file for more info.
