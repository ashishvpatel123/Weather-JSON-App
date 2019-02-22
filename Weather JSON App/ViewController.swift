//
//  ViewController.swift
//  Weather JSON App
//
//  Created by IMCS2 on 2/21/19.
//  Copyright © 2019 IMCS2. All rights reserved.
// URL : https://api.openweathermap.org/data/2.5/weather?q=Dallas&appid=4e50d2279e5b4d7501d1092f83ea5345

import UIKit

struct WelcomeData: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Sys: Codable {
    let type, id: Int
    let message: Double
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}


class ViewController: UIViewController {

    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var weatherLable: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submitButtonClicked(_ sender: Any) {
        let city = cityName.text
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city!)&appid=4e50d2279e5b4d7501d1092f83ea5345") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
            let data = try JSONDecoder().decode(WelcomeData.self , from: dataResponse)
                print("data from api  \(data)")
                DispatchQueue.main.async {
                    self.weatherLable.text = "Description : " + data.weather[0].description + " \n Humidity : " + String(data.main.humidity)
                }
            }catch let parsingError{
                print("parsing error \(parsingError)")
            }
        }
        task.resume()
        
    }
    
}

