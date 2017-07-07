//
//  LeftViewController.swift
//  PaintApp
//
//  Created by 前原理来 on 2017/07/05.
//  Copyright © 2017年 前原理来. All rights reserved.
//

import UIKit

protocol LeftViewControllerDelegate: class {
    func leftViewController(didSetLineWidth width: CGFloat)
    func leftViewController(didSetDrawColort drawColor: UIColor, elaseAlpha: CGFloat, blendMode: CGBlendMode)
    func leftViewControllerDidAllDelete()
}

class LeftViewController: UIViewController, UITableViewDelegate {
    weak var delegate: LeftViewControllerDelegate?
    
    @IBAction func slideSlider(_ sender: UISlider) {
        delegate?.leftViewController(didSetLineWidth: CGFloat(sender.value) * 30)
    }
    
    @IBAction func setRedColor(_ sender: Any) {
        delegate?.leftViewController(didSetDrawColort: .red, elaseAlpha: 1, blendMode: .normal)
    }
    
    @IBAction func setGreenColor(_ sender: Any) {
        delegate?.leftViewController(didSetDrawColort: .green, elaseAlpha: 1, blendMode: .normal)
    }
    
    
    @IBAction func setBlueColor(_ sender: Any) {
        delegate?.leftViewController(didSetDrawColort: .blue, elaseAlpha: 1, blendMode: .normal)
    }
    
    @IBAction func setBlackColor(_ sender: Any) {
        delegate?.leftViewController(didSetDrawColort: .black, elaseAlpha: 1, blendMode: .normal)
    }
    
    @IBAction func setEraser(_ sender: Any) {
        delegate?.leftViewController(didSetDrawColort: .white, elaseAlpha: 0, blendMode: .clear)
    }
    
    @IBAction func allDeleteClicked(_ sender: Any) {
        delegate?.leftViewControllerDidAllDelete()
    }
}
