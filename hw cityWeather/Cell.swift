//
//  Cell.swift
//  hw cityWeather
//
//  Created by Mavlon on 18/03/22.
//

import UIKit

protocol DeleteCell {
    func deleteCell(index: Int)
}

class Cell: UITableViewCell {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var delegate: DeleteCell?
    var cellIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(weather: WeatherInfo) {
        cityLbl.text = weather.cityName
        countryLbl.text = weather.countryName
        degreeLbl.text = weather.degree
        dateLbl.text = weather.date
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        delegate?.deleteCell(index: cellIndex)
    }
    
    
}
