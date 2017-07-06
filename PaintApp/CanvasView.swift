//
//  CanvasView.swift
//  PaintApp
//
//  Created by 前原理来 on 2017/07/01.
//  Copyright © 2017年 前原理来. All rights reserved.
//

import UIKit

class CanvasView: UIImageView {
    
    var parentView:UIView?
    var scrollView:UIScrollView?
    // 直前のタッチ座標の保存用
    var lastPoint: CGPoint?
    // 描画用の線の太さの保存用
    var lineWidth: CGFloat = 10.0
    var drawColor = UIColor.black
    // 消しゴム用Alpha
    var elaseAlpha: CGFloat = 1.0
    // ベジェ曲線描画用
    var bezierPath : UIBezierPath?
    // blendmode https://lab.dolice.net/blog/2013/07/25/objc-ui-image-blend-mode/
    var cgBlendMode = CGBlendMode.normal
    // undo のための保存
    var saveImageArray = [UIImage]()
    // 現在表示してるのは何番か
    var currentDisplayCount = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func initCanvas(uiView :UIView, scrollView:UIScrollView){
        self.parentView = uiView
        self.scrollView = scrollView
        prepareDrawing()
    }
    
    /**
     UIGestureRecognizerでお絵描き対応
     */
    private func prepareDrawing() {
        let myDraw = UIPanGestureRecognizer(target: self, action: #selector(drawGesture(sender:)))
        // 検出するタッチ数
        myDraw.maximumNumberOfTouches = 1
        self.scrollView?.addGestureRecognizer(myDraw)
        
        //実際のお絵描きで言うキャンバスの準備 (=何も描かれていないUIImageの作成)
        prepareCanvas()
        self.saveImageArray.append(self.image!)
    }
    
    private func prepareCanvas() {
        // キャンバスのサイズの決定
        let canvasSize = CGSize(width: (parentView?.frame.width)!*2, height: (parentView?.frame.height)!*2)
        // canvasのRect
        let canvasRect = CGRect(x: 0, y:0, width: canvasSize.width, height: canvasSize.height)
        // context作成
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        // キャンバス用にからのUIImageを作成
        var firstCanvasImage = UIImage()
        // 塗りつぶす
//        UIColor.white.setFill()
//        UIRectFill(canvasRect)
        // contextから塗りつぶしたImageを取得
        firstCanvasImage = UIGraphicsGetImageFromCurrentImageContext()!
        // contentModeの設定 http://zutto-megane.com/objective-c/post-155/
        self.contentMode = .scaleAspectFit
        // imageをセット
        self.image = firstCanvasImage
        // context 終了
        UIGraphicsEndImageContext()
    }
    
    /**
     UIGestureRecognizerのStatusが.Changedの時に実行するDraw動作
     
     - parameter canvas : キャンバス
     - parameter lastPoint : 最新のタッチから直前に保存した座標
     - parameter newPoint : 最新のタッチの座標座標
     - parameter bezierPath : 線の設定などが保管されたインスタンス
     - returns : 描画後の画像
     */
    private func drawGestureAtChanged(canvas: UIImage, lastPoint: CGPoint, newPoint: CGPoint, bezierPath: UIBezierPath) -> UIImage {
        
        // 最新のtouchPointとlastPointからmiddlePointを算出 middlePointで書いたほうがきれい
        let middlePoint = CGPoint(x: (lastPoint.x + newPoint.x) / 2, y: (lastPoint.y + newPoint.y) / 2)
        
        // 各ポイントの座標はscrollView基準なのでキャンバスの大きさに合わせた座標に変換
        let middlePointForCanvas = convertPointForCanvasSize(originalPoint: middlePoint, canvasSize: canvas.size)
        let lastPointForCanvas   = convertPointForCanvasSize(originalPoint: lastPoint, canvasSize: canvas.size)
        
        // 曲線を描画
        bezierPath.addQuadCurve(to: middlePointForCanvas, controlPoint: lastPointForCanvas)
        UIGraphicsBeginImageContextWithOptions(canvas.size, false, 0.0)
        // rectを用意
        let canvasRect = CGRect(x: 0, y: 0, width: canvas.size.width, height: canvas.size.height)
        // 用意したRectに現在のimageを描画
        self.image?.draw(in: canvasRect)
        drawColor.setStroke()
        //        UIColor.white.setFill()
        //        bezierPath.fill()
        
        bezierPath.stroke(with: cgBlendMode, alpha: elaseAlpha)
        //        bezierPath.stroke()
        // 描画後のImageを取得
        let imageAfterDraw = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageAfterDraw!
    }
    
    /**
     draw動作
     private じゃだめなの?
     */
    func drawGesture(sender: AnyObject) {
        
        guard let drawGesture = sender as? UIPanGestureRecognizer else {
            print("drawGesture Error happened.")
            return
        }
        
        guard let canvas = self.image else {
            fatalError("self.pictureView.image not found")
        }
        // タッチ座標
        let touchPoint = drawGesture.location(in: self)
        switch drawGesture.state {
        case .began:
            bezierPath = UIBezierPath()
            lastPoint = touchPoint
            // touchPointの座標はscrollView基準なのでキャンバスの大きさに合わせた座標に変換
            let lastPointForCanvasSize = convertPointForCanvasSize(originalPoint: lastPoint!, canvasSize: canvas.size)
            // 線を丸く
            bezierPath?.lineCapStyle = .round
            // 先の太さ
            bezierPath?.lineWidth = lineWidth
            bezierPath?.move(to: lastPointForCanvasSize)
            
        case .changed:
            
            let newPoint = touchPoint
            
            // Draw実行しDraw後のimage取得
            let imageAfterDraw = drawGestureAtChanged(canvas: canvas, lastPoint: lastPoint!, newPoint: newPoint, bezierPath: bezierPath!)
            
            // draw画像をCanvasにセット
            self.image = imageAfterDraw
            // point保存
            lastPoint = newPoint
            
        case .ended:
            while currentDisplayCount != saveImageArray.count - 1 {
                saveImageArray.removeLast()
            }
            self.saveImageArray.append(self.image!)
            currentDisplayCount += 1
            print("Finish dragging")
            
        default:
            ()
        }
    }
    
    // やり直し
    func redoPath() {
        if currentDisplayCount >= saveImageArray.count-1 {return}
        currentDisplayCount += 1
        self.image = self.saveImageArray[currentDisplayCount]
    }
    // 元に戻す
    func undoPath()  {
        if currentDisplayCount <= 0 {return}
        currentDisplayCount -= 1
        self.image = self.saveImageArray[currentDisplayCount]
    }
    
    /**
     save
     */
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(self.image!, self, nil, nil)
    }
    
    func allDelete() {
        currentDisplayCount = 0
        while currentDisplayCount != saveImageArray.count - 1 {
            saveImageArray.removeLast()
        }
        self.image = saveImageArray[currentDisplayCount]
    }
    
    /**
     座標をキャンバスのサイズに変換
     
     - parameter originalPoint : 座標
     - parameter canvasSize : キャンバスのサイズ
     - returns : キャンバス基準に変換した座標
     */
    private func convertPointForCanvasSize(originalPoint: CGPoint, canvasSize: CGSize) -> CGPoint {
        let viewSize = scrollView?.frame.size
        let convertPoint = CGPoint(x: originalPoint.x / (viewSize?.width)! * canvasSize.width,
                                   y: originalPoint.y / (viewSize?.height)! * canvasSize.height)
        return convertPoint
    }
}
