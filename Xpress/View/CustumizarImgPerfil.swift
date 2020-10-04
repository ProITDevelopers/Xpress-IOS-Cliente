//
//  CustumizarImgPerfil.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/19/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class CustumizarImagemPerfil: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupButton() {
        styleImageView()
        
    }
    
    
    func styleImageView() {
        layer.masksToBounds =  false
        layer.cornerRadius = frame.size.width/2
        layer.borderWidth = 5.0
        layer.borderColor = UIColor(red: 28.0/255.0, green: 150.0/255.0, blue: 106.0/255.0, alpha: 1.0).cgColor
        
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleImageView()
    }
}

