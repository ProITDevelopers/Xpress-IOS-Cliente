//
//  TableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/24/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imgCategoria: UIImageView!
    @IBOutlet weak var descricaoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
