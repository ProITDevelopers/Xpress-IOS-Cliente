//
//  DetalhesFacturaTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/1/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class DetalhesFacturaTableViewCell: UITableViewCell {
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var estadoPagamentoLabel: UILabel!
    @IBOutlet weak var tipoPagamentoLabel: UILabel!
    @IBOutlet weak var totalPagarLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var facturaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
