//
//  ItemFacturaTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/1/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class ItemFacturaTableViewCell: UITableViewCell {
    @IBOutlet weak var qtdLabel: UILabel!
    @IBOutlet weak var nomeItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
