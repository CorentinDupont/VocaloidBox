//
//  MusicTableViewCell.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 07/05/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    // MARK - Properties
    
    @IBOutlet weak var musicTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
