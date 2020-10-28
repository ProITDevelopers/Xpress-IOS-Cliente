//
//  CustumizarViewText.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/28/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class CustumizarViewText: UITextView {
    
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupTextField() {
        styleTextField()
        
    }
    
    
    func styleTextField() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0).cgColor
            
            
            
        
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleTextField()
    }
    
}

