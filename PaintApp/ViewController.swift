//
//  ViewController.swift
//  PaintApp
//
//  Created by 前原理来 on 2017/07/01.
//  Copyright © 2017年 前原理来. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var canvasView: CanvasView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(red: 129/255, green: 212/255, blue: 78/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor.white
        //バーの左側にボタンを配置します(ライブラリ特有)
        //        addLeftBarButtonWithImage(UIImage(named: "menu")!)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0                   // 最小拡大率
        scrollView.maximumZoomScale = 4.0                   // 最大拡大率
        scrollView.zoomScale = 1.0                          // 表示時の拡大率(初期値)
        canvasView.initCanvas(uiView: view, scrollView: scrollView)
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.canvasView=self.canvasView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ギャラリーからPick
    @IBAction func onClickPickButton(_ sender: Any) {
        self.pickImageFromLibrary()
    }
    
    // やり直し
    @IBAction func onClickRedo(_ sender: Any) {
        canvasView.redoPath()
    }
    
    // 元に戻す
    @IBAction func onClickUndo(_ sender: Any) {
        canvasView.undoPath()
    }
    
    // save
    @IBAction func onClickSave(_ sender: Any) {
        canvasView.saveImage()
    }
    
    // scrollview delegetes
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }

    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func setImageWithResize(uiImage :UIImage) {
        let size = CGSize(width: (view.frame.width), height: (view.frame.height))
        UIGraphicsBeginImageContext(size)
        uiImage.draw(in: CGRect(x:0, y:0, width: (view.frame.width), height:(view.frame.height)))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let myUIImageView = UIImageView(image: resizeImage)
        myUIImageView.alpha = 0.5
        self.backgroundView.image = resizeImage
    }
    // 写真を選択した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            canvasView.contentMode = .scaleToFill
//            canvasView.setImageWithResize(uiImage: pickedImage)
            setImageWithResize(uiImage: pickedImage)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
