//
//  ViewController.swift
//  WeatherWindow
//
//  Created by music on 2015/09/17.
//  Copyright (c) 2015年 kazu. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let la_label = UILabel()
    let lo_label = UILabel()
    let resetButton = UIButton()
    var draw = drawView()

    var myLocationManager: CLLocationManager!
    var latitude: CLLocationDegrees!    //緯度
    var longitude: CLLocationDegrees!   //経度
    
    var screenImage: UIImageView! = UIImageView()
    var windowImage: UIImageView! = UIImageView()
    
    let img0 :UIImage = UIImage(named: "blue_sky.jpg")!
    let img1 :UIImage = UIImage(named: "cloudy_sky.jpg")!
    let img2 :UIImage = UIImage(named: "rainy_sky.jpg")!
    let img3 :UIImage = UIImage(named: "snow_sky.jpg")!
    let img4 :UIImage = UIImage(named: "etc_sky.jpg")!
    
    var imgArray :[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //配列に空のimgを格納
        imgArray = [img0, img1, img2, img3, img4]
        
        screenImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        screenImage.image = imgArray[0]
        self.view.addSubview(screenImage)
        
        // お絵かきview生成
        if(true) {
            draw.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            draw.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
            self.view.addSubview(draw)
        
            // clearボタンのセット
            resetButton.backgroundColor = UIColor.greenColor()
            resetButton.setTitle("RESET", forState: UIControlState.Normal)
            resetButton.sizeToFit()
            resetButton.layer.position = CGPoint(x: self.view.frame.width - resetButton.frame.width,
                y:self.view.frame.height - resetButton.frame.height)
            resetButton.addTarget(self, action: "resetPaint", forControlEvents: .TouchUpInside)
            self.view.addSubview(resetButton)
        }
            
        // 各GPSインスタンスの生成.
        myLocationManager = CLLocationManager()
        latitude = CLLocationDegrees()
        longitude = CLLocationDegrees()

        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 距離のフィルタ.
        myLocationManager.distanceFilter = 100.0
        
        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            self.myLocationManager.requestAlwaysAuthorization();
        }
        
        // 位置情報の更新を開始.
        myLocationManager.startUpdatingLocation()
        
        la_label.text = "緯度"
        lo_label.text = "経度"
        
        la_label.font = UIFont.systemFontOfSize(40)
        lo_label.font = UIFont.systemFontOfSize(40)
        
        la_label.sizeToFit()
        lo_label.sizeToFit()
        
        la_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 50)
        lo_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 50)
        
        self.view.addSubview(la_label)
        self.view.addSubview(lo_label)
        
        windowImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(windowImage)
        windowImage.image = UIImage(named: "waku.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // GPSから値を取得した際に呼び出されるメソッド.
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // 配列から現在座標を取得.
        var myLocations: NSArray = locations as NSArray
        var myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        var myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
 
        latitude = myLocation.latitude
        longitude = myLocation.longitude
        
        la_label.text = toString(latitude)
        lo_label.text = toString(longitude)
        
        la_label.sizeToFit()
        lo_label.sizeToFit()
    }
    
    // 認証が変更された時に呼び出されるメソッド.
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .AuthorizedWhenInUse:
            println("AuthorizedWhenInUse")
        case .AuthorizedAlways:
            println("AuthorizedAlways")
        case .Denied:
            println("Denied")
        case .Restricted:
            println("Restricted")
        case .NotDetermined:
            println("NotDetermined")
        default:
            println("etc.")
        }
    }
    
    func resetPaint() {
        draw.removeFromSuperview()
        resetButton.removeFromSuperview()
        windowImage.removeFromSuperview()
        
        var new_draw = drawView()
        draw = new_draw

        draw.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        draw.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.view.addSubview(draw)
        
        resetButton.backgroundColor = UIColor.greenColor()
        resetButton.setTitle("RESET", forState: UIControlState.Normal)
        resetButton.sizeToFit()
        resetButton.layer.position = CGPoint(x: self.view.frame.width - resetButton.frame.width,
            y:self.view.frame.height - resetButton.frame.height)
        resetButton.addTarget(self, action: "resetPaint", forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton)

        self.view.addSubview(windowImage)
    }
}
