//
//  EstabCarrinho.swift
//  Xpress
//
//  Created by Adilson Ebo on 11/9/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import Foundation
import RealmSwift


class EstabCarrinho: Object {
    
     @objc dynamic var ideStabelecimento = 0
     @objc dynamic  var nomeEstab = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic  var longitude = 0.0
    @objc dynamic var taxaEntrega = 0.0
    //@objc dynamic var valorItens = 0.0
    
}
