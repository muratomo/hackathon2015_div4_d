//
//  drawView.swift
//  WeatherWindow
//
//  Created by 村上友教 on 2015/09/17.
//  Copyright (c) 2015年 村上友教. All rights reserved.
//

import UIKit

class drawView: UIView {
    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        lastPoint = touch.locationInView(self)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        var newPoint = touch.locationInView(self)
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        
        for line in lines {
            CGContextMoveToPoint(context, line.start.x, line.start.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
        }
        
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.5) //線の色
        CGContextSetLineWidth(context, 25)  //線の太さ
        CGContextSetLineCap(context, kCGLineCapRound)   //線を滑らかに
        CGContextStrokePath(context)
    }
}
