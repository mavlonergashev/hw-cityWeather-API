//
//  MainVC.swift
//  hw cityWeather
//
//  Created by Mavlon on 18/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

let accessToken = "8e4624b76897491c83294821221903"
let baseUrl = "http://api.weatherapi.com/v1"
let currentWeatherPath = "/current.json"
let historyPath = "/history.json"

class MainVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        }
    }
    
    var isSearchHistory = true
    let dateFormatter = DateFormatter()
    var searchHistoryData: [WeatherInfo] = []
    var historyData: [WeatherInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        print(dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -6, to: Date())!))
        print(dateFormatter.string(from: Date()))
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            isSearchHistory = true
        } else {
            isSearchHistory = false
        }
        self.tableView.reloadData()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        textField.endEditing(true)
    }
}

//MARK: - Search Text Field

extension MainVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        getWeather(cityName: textField.text!)
        textField.text = ""
    }
    
}

//MARK: - Table View Methods

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchHistory {
            return searchHistoryData.count
        } else {
            return historyData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.cellIndex = indexPath.row
        cell.delegate = self
        
        if isSearchHistory {
            cell.updateCell(weather: searchHistoryData[indexPath.row])
        } else {
            cell.updateCell(weather: historyData[indexPath.row])
        }
        
        return cell
    }
    
}

//MARK: - Get Weather

extension MainVC {
    
    private func getWeather(cityName: String) {
        
        let parametres: [String : String] = [
            "key" : accessToken,
            "q" : cityName,
            "dt" : dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -6, to: Date())!),
            "end_dt" : dateFormatter.string(from: Date())
        ]
        
        let request = AF.request(baseUrl+historyPath,method: .get, parameters: parametres)
        
        
        
        request.response { response in
            if let data = response.data {
                
                
                
                let json = JSON(data)
                if json["location"].isEmpty {
                    SwiftSpinner.show(duration: 3, title: "Matching Not Found")
                } else {
                    SwiftSpinner.show("Searching for \(cityName)", animated: true)
                    self.cityNameLbl.text = json["location"]["name"].stringValue
                    self.countryNameLbl.text = json["location"]["country"].stringValue
                    self.degreeLbl.text = json["forecast"]["forecastday"][6]["day"]["avgtemp_c"].stringValue
                    
                    self.searchHistoryData.append(WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][6]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Date())))
                    
                    self.historyData = [
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][0]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -6, to: Date())!)),
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][1]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)),
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][2]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -4, to: Date())!)),
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][3]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)),
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][4]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)),
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][5]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)),
                        WeatherInfo(cityName: json["location"]["name"].stringValue, countryName: json["location"]["country"].stringValue, degree: json["forecast"]["forecastday"][6]["day"]["avgtemp_c"].stringValue, date: self.dateFormatter.string(from: Date()))
                    ]
                    SwiftSpinner.hide()
                    self.tableView.reloadData()
                }
            } else {
                print("Response kelishda error")
            }
        }
    }
}

//MARK: - DeleteCell Protocol

extension MainVC: DeleteCell {
    func deleteCell(index: Int) {
        if isSearchHistory {
            self.searchHistoryData.remove(at: index)
            self.tableView.reloadData()
        }
    }
}
