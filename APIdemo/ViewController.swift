//
//  ViewController.swift
//  APIdemo
//
//  Created by Gladston Joseph on 2/25/19.
//  Copyright © 2019 Gladston Joseph. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func getWeatherButton(_ sender: Any) {
        let cityName = cityTextField.text?.lowercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20")
        if cityName != "" {
            getCityDetails(capitalCity: cityName!)
        } else {
            resultLabel.text = "Please Enter a Valid City"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func getCityDetails(capitalCity: String) {//} -> String {
        
        let url = URL(string: "https://restcountries.eu/rest/v2/capital/\(capitalCity)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("getCityDetails URL Error: \(error)")
            } else {
                if let urlContent = data {
                    
                    do {
                        var jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        jsonResult = jsonResult[0]
                        print("getCityDetails jsonResult: \(jsonResult)")
                        print("\n")
                        print("\n")
                        
                        if let countryCode = (jsonResult["alpha2Code"] as? String)?.lowercased() {
                            //return countryCode
                            self.getWeatherData(city: capitalCity, countryCode: countryCode)
                        }
                    } catch {
                        print("getCityDetails JSON Processing Failed")
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    func getWeatherData(city: String, countryCode: String) {
        print("countryCode in getWeatherData() : \(countryCode)")
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(countryCode)&appid=1ae48a41e0057c7a0bba524689321b05")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("getWeatherData URL Error : \(error)")
            } else {
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print("getWeatherData jsonResult : \(jsonResult)")
                        if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                            
                            DispatchQueue.main.sync(execute: {
                                self.resultLabel.text = description
                            })
                        }
                    } catch {
                        print("getWeatherData JSON Processing Failed")
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }
    
}

