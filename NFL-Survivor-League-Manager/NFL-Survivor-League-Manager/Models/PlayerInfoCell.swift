//
//  PlayerInfoCell.swift
//  NFL-Survivor-League-Manager
//
//  Created by Jacob Frick on 12/7/18.
//  Copyright © 2018 Jacob Frick. All rights reserved.
//

import UIKit

class PlayerInfoCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerStatusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
