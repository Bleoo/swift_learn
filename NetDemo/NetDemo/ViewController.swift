//
//  ViewController.swift
//  NetDemo
//
//  Created by TDC on 16/8/29.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

struct Weather {
    var city: String?
    var weather: String?
    var temp: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var lb_city: UILabel!
    @IBOutlet weak var lb_weather: UILabel!
    @IBOutlet weak var lb_temperature: UILabel!
    
    var weather: Weather? {
        didSet{
            self.lb_city.text = weather?.city
            self.lb_weather.text = weather?.weather
            self.lb_temperature.text = weather?.temp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeather()
    }

    func getWeather(){
        // String转URL编码
        let city = "深圳".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        // NSURL的参数String中不能包含中文或者空格等,否则url会为nil
        let url = NSURL(string: "http://apis.baidu.com/apistore/weatherservice/cityname?cityname=\(city!)")
        // 创建请求
        let request = NSMutableURLRequest(URL: url!)
        // 请求方式
        request.HTTPMethod = "GET"
        // 设置请求头参数
        request.setValue("5e769803a697dcf91066ac77c782d655", forHTTPHeaderField: "apikey")
        // 创建Session及SessionConfig
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10
        let session = NSURLSession(configuration: config)
        // 创建请求任务,dataTaskWithRequest为异步方法
        let task = session.dataTaskWithRequest(request) { (data, _, error) -> Void in
            if error == nil {
                do {
                    // JSON数据解析为NSDictionary
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary{
                        if let retData = json.objectForKey("retData") as? NSDictionary {
                            let weat = retData.objectForKey("weather") as? String
                            let temp = retData.objectForKey("temp") as? String
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.weather = Weather(city: "深圳", weather: weat, temp: temp)
                            })
                        }
                    }
                }
            }

        }
        // 任务开始
        task.resume()
    }

}

