//
//  FacturaTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/1/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class FacturaTableViewCell: UITableViewCell {

    @IBOutlet weak var estabelecimentoLabel: UILabel!
    @IBOutlet weak var facturaLabel: UILabel!
    @IBOutlet weak var dataFacturaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
