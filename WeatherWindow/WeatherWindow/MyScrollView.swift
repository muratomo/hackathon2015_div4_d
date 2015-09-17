//
//  MyScrollView.swift
//  WeatherWindow
//
//  Created by 村上友教 on 2015/09/17.
//  Copyright (c) 2015年 村上友教. All rights reserved.
//

import Foundation
import UIKit

class MyScrollView: UIView {
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let position : CGPoint = touch.locationInView(self)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var newPoint = touches.first as! UITouch
    }
    
    
}