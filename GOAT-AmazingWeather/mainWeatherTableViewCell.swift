//
//  mainWeatherTableViewCell.swift
//  GOAT-AmazingWeather
//
//  Created by Ren-Kai Yeh on 11/4/19.
//  Copyright © 2019 Sponty, LLC. All rights reserved.
//

import UIKit

class mainWeatherTableViewCell: UITableViewCell {

    @IBOutlet var weatherImg: UIImageView!
    
    @IBOutlet var dayOfTheWeek: UILabel!
    
    @IBOutlet var highLowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
