//
//  StatisticsVC.swift
//  ReadingDiary
//
//  Created by Anna Panova on 18.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

class StatisticsVC: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeInDaysLabel: UILabel!
    
    //  setup statistics Storage (NSUserDefaults)
    let repository = StatisticsRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = "\(repository.getNumberOfReadedBooks())"
        timeInDaysLabel.text = "\(repository.getAverageDuration()) days"
    }
}
