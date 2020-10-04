//
//  CustumizarBtnCurto.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class CustumizarBtnCurto: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupButton() {
        styleBotton()
        
    }
    
    
    func styleBotton() {
        layer.cornerRadius = 20
        //layer.borderWidth = 0.3
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleBotton()
    }
    
}

