//
//  detailViewController.swift
//  GOAT-AmazingWeather
//
//  Created by Ren-Kai Yeh on 11/4/19.
//  Copyright © 2019 Sponty, LLC. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet var weatherIconImgView: UIImageView!
    
    @IBOutlet var dayOfTheWeekLabel: UILabel!
    
    @IBOutlet var highLowLabel: UILabel!
    
    @IBOutlet var daySummaryLabel: UILabel!
    
    var iconStr = String()
    var dayOfTheWeek = String()
    var highLow = String()
    var daySummary = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherIconImgView.image = UIImage(named: iconStr)
        
        dayOfTheWeekLabel.text = dayOfTheWeek
        
        highLowLabel.text = highLow
        
        daySummaryLabel.text = daySummary
    }

}
