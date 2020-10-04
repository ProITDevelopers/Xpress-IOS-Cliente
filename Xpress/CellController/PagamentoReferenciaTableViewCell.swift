//
//  PagamentoReferenciaTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/2/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class PagamentoReferenciaTableViewCell: UITableViewCell {
    @IBOutlet weak var facturaLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var estadoPedidoLabel: UILabel!
    @IBOutlet weak var estadoPagamentoLabel: UILabel!
    @IBOutlet weak var metodoPagamentoLabel: UILabel!
    @IBOutlet weak var referenciaLabel: UILabel!
    @IBOutlet weak var entidadeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
