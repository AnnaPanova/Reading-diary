//
//  CustomCell.swift
//  ReadingDiary
//
//  Created by Anna Panova on 16.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    //  MARK: Setup custom cell for List of Books
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var readedLabel: UILabel!
    @IBOutlet weak var starsFromGoodreadsLabel: UILabel!
    @IBOutlet weak var myStarsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
