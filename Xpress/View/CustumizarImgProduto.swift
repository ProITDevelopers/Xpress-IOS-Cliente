//
//  CustumizarImgProduto.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/3/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit


class CustumizarImgProduto: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupImageView() {
        styleView()
        
    }
    
    
    func styleView() {
        
        
      // layer.borderWidth = 0.1
 //let shadowPath2 = UIBezierPath(rect:  bounds)
       layer.cornerRadius = 20
        clipsToBounds = true
         layer.masksToBounds = false
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: CGFloat(3), height: CGFloat(3))
         layer.shadowOffset = CGSize(width: CGFloat(3), height: CGFloat(3))
         if #available(iOS 13.0, *) {
             layer.shadowColor = UIColor.secondarySystemBackground.cgColor
         } else {
             layer.shadowColor = UIColor.gray.cgColor
             // Fallback on earlier versions
         }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
    }
}






