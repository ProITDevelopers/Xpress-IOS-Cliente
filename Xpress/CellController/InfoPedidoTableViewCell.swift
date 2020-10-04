//
//  InfoPedidoTableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class InfoPedidoTableViewCell: UITableViewCell {

    @IBOutlet weak var tipoPagamento: UILabel!
    @IBOutlet weak var telefoneLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
