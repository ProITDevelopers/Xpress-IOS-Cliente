//
//  DetalheEstabTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 11/17/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class DetalheEstabTableViewCell: UITableViewCell {
    @IBOutlet weak var valorTaxaLabel: UILabel!
    @IBOutlet weak var valorItemLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var estabelecimentoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
