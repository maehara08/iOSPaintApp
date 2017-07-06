//
//  LeftViewController.swift
//  PaintApp
//
//  Created by 前原理来 on 2017/07/05.
//  Copyright © 2017年 前原理来. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    
    var canvasView:CanvasView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.canvasView = delegate.canvasView
    }
    
    @IBAction func slideSlider(_ sender: UISlider) {
        canvasView?.lineWidth = CGFloat(sender.value) * 30
    }
    
    @IBAction func setRedColor(_ sender: Any) {
        canvasView!.drawColor = UIColor.red
        canvasView!.elaseAlpha = 1.0
        canvasView!.cgBlendMode = CGBlendMode.normal
    }
    
    @IBAction func setGreenColor(_ sender: Any) {
        canvasView?.drawColor = UIColor.green
        canvasView?.elaseAlpha = 1.0
        canvasView?.cgBlendMode = CGBlendMode.normal
    }
    
    
    @IBAction func setBlueColor(_ sender: Any) {
        canvasView?.drawColor = UIColor.blue
        canvasView?.elaseAlpha = 1.0
        canvasView?.cgBlendMode = CGBlendMode.normal
    }
    
    @IBAction func setBlackColor(_ sender: Any) {
        canvasView?.drawColor = UIColor.black
        canvasView?.elaseAlpha = 1.0
        canvasView?.cgBlendMode = CGBlendMode.normal
    }
    
    @IBAction func setEraser(_ sender: Any) {
        canvasView!.elaseAlpha = 0.0
        canvasView!.cgBlendMode = CGBlendMode.clear
    }
    
    @IBAction func allDeleteClicked(_ sender: Any) {
        canvasView?.allDelete()
    }
}
