//
//  SlideViewController.swift
//  PaintApp
//
//  Created by 前原理来 on 2017/07/05.
//  Copyright © 2017年 前原理来. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideViewController: SlideMenuController {
    
    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main") as! ViewController
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "Left") as! LeftViewController
      
        leftVC.delegate = mainVC
      
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
//        let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
//        mainViewController = navigationController
        mainViewController = mainVC
        leftViewController = leftVC
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
