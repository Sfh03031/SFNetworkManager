//
//  ViewController.swift
//  SFNetworkManager
//
//  Created by Sfh03031 on 03/12/2024.
//  Copyright (c) 2024 Sfh03031. All rights reserved.
//

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

