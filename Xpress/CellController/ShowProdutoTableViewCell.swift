//
//  ShowProdutoTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/4/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

protocol IrCarrinhoDelegate {
   
    func didVerCarrino()
    
}
class ShowProdutoTableViewCell: UITableViewCell {
    
     var delegate: IrCarrinhoDelegate?

   
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var nomeEstabelecimentoLabel: UILabel!
    @IBOutlet weak var btnCarrinho: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBtn.layer.cornerRadius = viewBtn.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonCarrinho(_ sender: UIButton) {
        delegate?.didVerCarrino()
    }
    
}
