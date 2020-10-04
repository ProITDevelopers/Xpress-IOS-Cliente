//
//  DetalheShowProdutoTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/3/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import RealmSwift

protocol SaltarParaCarrinhoDelegate {
    func didIrCarrinho()
    
    
}
class DetalheShowProdutoTableViewCell: UITableViewCell {
    
    var delegate: SaltarParaCarrinhoDelegate?
    
    @IBOutlet weak var btnCarrinho: UIButton!
    @IBOutlet weak var estabelecimentoLabel: UILabel!
    @IBOutlet weak var enderecoEstsLabel: UILabel!
    @IBOutlet weak var imgCapaEstabelecimento: UIImageView!
     var label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonCarrinho(_ sender: UIButton) {
        delegate?.didIrCarrinho()
    }
    
}
