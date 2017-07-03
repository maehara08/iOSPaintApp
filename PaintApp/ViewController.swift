//
//  ViewController.swift
//  PaintApp
//
//  Created by 前原理来 on 2017/07/01.
//  Copyright © 2017年 前原理来. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0                   // 最小拡大率
        scrollView.maximumZoomScale = 4.0                   // 最大拡大率
        scrollView.zoomScale = 1.0                          // 表示時の拡大率(初期値)
        canvasView.initCanvas(uiView: view, scrollView: scrollView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slideSlider(_ sender: UISlider) {
        canvasView.lineWidth = CGFloat(sender.value) * 30
    }
    
    @IBAction func setRedColor(_ sender: Any) {
        canvasView.drawColor = UIColor.red
        canvasView.elaseAlpha = 1.0
        canvasView.cgBlendMode = CGBlendMode.normal
    }
    
    @IBAction func setGreenColor(_ sender: Any) {
        canvasView.drawColor = UIColor.green
        canvasView.elaseAlpha = 1.0
        canvasView.cgBlendMode = CGBlendMode.normal
    }
    
    
    @IBAction func setBlueColor(_ sender: Any) {
        canvasView.drawColor = UIColor.blue
        canvasView.elaseAlpha = 1.0
        canvasView.cgBlendMode = CGBlendMode.normal
    }
    
    @IBAction func setBlackColor(_ sender: Any) {
        canvasView.drawColor = UIColor.black
        canvasView.elaseAlpha = 1.0
        canvasView.cgBlendMode = CGBlendMode.normal
    }
    
    @IBAction func setEraser(_ sender: Any) {
        canvasView.elaseAlpha = 0.0
        canvasView.cgBlendMode = CGBlendMode.clear
    }
    
    // scrollview delegetes
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasView
    }
}
