//
//  ViewController.swift
//  YSJDropMenu_Swift
//
//  Created by 闫树军 on 16/5/16.
//  Copyright © 2016年 闫树军. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dropMenu        :YSJDropMenuView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropMenu = YSJDropMenuView.init(frame: CGRectMake(0, 100, kScreenWidth, 40), Items: ["综合排序","综合排序","综合排序","综合排序","综合排序"], menuItem: ["综合排序","价格从低到高"])
        dropMenu.delegate = self
        self.view.addSubview(dropMenu)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController : YSJDropMenuViewDelegate {
    
    func  dropMenuselectedItem(index: NSInteger) {
        print(index)
    }
    
    func dropMenuSelectedTitle(index: NSInteger) {
        print(index)
    }
}

