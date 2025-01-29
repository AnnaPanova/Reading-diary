//
//  CustomCellSearch.swift
//  ReadingDiary
//
//  Created by Anna Panova on 17.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

class CustomCellSearch: UITableViewCell {
    //  MARK: Setup custom cell for Searching books on Goodreads
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var starsFromGoodreadsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var openLinkButton: UIButton!
    
    @IBAction func openLinkAction(_ sender: UIButton) {
        openLink?()
    }
    
    //  MARK: Closure for realisation opening link
    var openLink : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: Add action to perform when the Open link button is tapped
        self.openLinkButton.addTarget(self, action: #selector(openLinkAction(_:)), for: .touchUpInside)
    }
}
