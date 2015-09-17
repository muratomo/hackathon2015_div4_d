//
//  ViewController.swift
//  WeatherWindow
//
//  Created by music on 2015/09/17.
//  Copyright (c) 2015年 kazu. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate {
    
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
    }
    
    func onView(x:Int){
        screenImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        screenImage.image = imgArray[x]
        self.view.addSubview(screenImage)
        
        // お絵かきview生成
        if(x == 2 || x == 3) {
            draw.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            draw.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
            self.view.addSubview(draw)
            
            // clearボタンのセット
            resetButton.backgroundColor = UIColor.whiteColor()
            resetButton.setTitle("RESET", forState: UIControlState.Normal)
            resetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            resetButton.sizeToFit()
            resetButton.layer.masksToBounds = true
            resetButton.layer.position = CGPoint(x: self.view.frame.width - resetButton.frame.width,
                y:self.view.frame.height - resetButton.frame.height)
            resetButton.addTarget(self, action: "resetPaint", forControlEvents: .TouchUpInside)
            self.view.addSubview(resetButton)
        }
        
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
        
        getWeather()
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
        
        resetButton.backgroundColor = UIColor.whiteColor()
        resetButton.setTitle("RESET", forState: UIControlState.Normal)
        resetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        resetButton.sizeToFit()
        resetButton.layer.masksToBounds = true
        resetButton.layer.position = CGPoint(x: self.view.frame.width - resetButton.frame.width,
            y:self.view.frame.height - resetButton.frame.height)
        resetButton.addTarget(self, action: "resetPaint", forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton)

        self.view.addSubview(windowImage)
    }
    
    func getWeather(){
        var urlString = "http://api.openweathermap.org/data/2.5/forecast?units=metric&lat=" + toString(latitude) + "&lon=" + toString(longitude)
        var isInLoad = false
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        
        var w_date:NSString!
        var w_main_str:NSString = ""
        let check_weather:[NSString] = ["Clear", "Clouds", "Rain", "Snow", "その他"];
        
        var sendparams:Int = 4
        
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 日付フォーマットの設定
        
        
        var url = NSURL(string: urlString)!
        // 通信用のConfigを生成.
        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // Sessionを生成.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        // タスクの生成.
        let myTask:NSURLSessionDataTask = mySession.dataTaskWithURL(url, completionHandler: { (data, response, err) -> Void in
            // リソースの取得が終わると、ここに書いた処理が実行される
            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            let i = 0
            
            if let statusesDic = json as? NSDictionary{
                if let aStatus = statusesDic["list"] as? NSArray {
                    for_i: for w_list in aStatus {
                        if w_list["dt_txt"]!!.compare(dateFormatter.stringFromDate(now)) == NSComparisonResult.OrderedDescending{
                            // 日付が対象より古い
                            if let w_main = w_list["weather"] as? NSArray{
                                if let w_mainlist = w_main[0] as? NSDictionary{
                                    w_main_str = w_mainlist["main"] as! NSString
                                    break for_i
                                }
                            }
                        }else if (w_list["dt_txt"]!!.compare(dateFormatter.stringFromDate(now)) == NSComparisonResult.OrderedAscending){
                            // 日付が対象より新しい
                            // 上記の場合、date2014の方が2015年よりも小さいのでこ  こにきます。
                        }else{
                            // 日付が同じ
                        }
                    }
                }
            }
            var j:Int
            for j=0; j<5; j++ {
                if check_weather[j] == w_main_str {
                    sendparams = j
                }
            }
            self.onView(sendparams)
        })
        // タスクの実行.
        myTask.resume()
    }
}
