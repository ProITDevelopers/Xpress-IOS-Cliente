//
//  ItemsCarrinho.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/24/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import Foundation
import RealmSwift

class ItemsCarrinho: Object {
    
   @objc dynamic var itemId: String = ""
   @objc dynamic var produtoId: Int = 0
   @objc dynamic var quantidade: Int = 0
   @objc dynamic var ideStabelecimento: Int = 0
   @objc dynamic var nomeItem: String = ""
   @objc dynamic var estabelecimento: String = ""
   @objc dynamic var precoUnitario: Int = 0
    @objc dynamic var imagemProduto: String = ""
    @objc dynamic var emStock: Int = 0
    @objc dynamic var obseracoes: String = ""
    
}
