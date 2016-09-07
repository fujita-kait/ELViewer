//
//  TopViewController.swift
//  ELDeviceObjectsViewer
//
//  Created by 藤田裕之 on 2016/09/07.
//  Copyright © 2016年 SmartHouse. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let elObjectTVC = segue.destinationViewController as? ELObjectTableViewController {
            switch segue.identifier! {
                case "segueDeviceObject":
                    elObjectTVC.jsonFileName = "deviceObject_G"
                case "segueNodeProfile":
                    elObjectTVC.jsonFileName = "nodeProfile"
                case "segueSuperClass":
                    elObjectTVC.jsonFileName = "superClass"
            default:
                break
            }
        }
    }
}
