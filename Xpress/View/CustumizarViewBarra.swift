//
//  CustumizarViewBarra.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/23/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit


class CustumizarViewBarra: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupButton() {
        styleView()
        
    }
    
    
   
    func styleView() {
        
       // layer.cornerRadius = 30
        layer.cornerRadius = 10
               clipsToBounds = true
                layer.masksToBounds = false
               layer.shadowRadius = 10
        layer.shadowOpacity = 0.8
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

