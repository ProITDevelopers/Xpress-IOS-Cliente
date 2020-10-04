//
//  ItensCheckTableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class ItensCheckTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var precoProduto: UILabel!
    @IBOutlet weak var estabelecimentoProduto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
