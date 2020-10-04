//
//  EstabelecimentoTableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/22/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class EstabelecimentoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgEstabelecimento: UIImageView!
    @IBOutlet weak var nomeEstabelecimento: UILabel!
    @IBOutlet weak var descricaoEstabelecimento: UILabel!
    
    @IBOutlet weak var estadoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
