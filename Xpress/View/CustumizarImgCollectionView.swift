//
//  CustumizarImgCollectionView.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/23/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//


import UIKit

class CustumizarImgCollectionView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupImageView() {
        styleImageView()
        
    }
    
    
    func styleImageView() {
        layer.cornerRadius = 30 //layer.borderWidth = 0.3
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleImageView()
    }
    
}

