//
//  CustumizarViewBarra.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/23/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
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
    
    
    @available(iOS 13.0, *)
    func styleView() {
        
       // layer.cornerRadius = 30
        layer.cornerRadius = 10
               clipsToBounds = true
                layer.masksToBounds = false
               layer.shadowRadius = 10
               layer.shadowOpacity = 1.0
               layer.shadowOffset = CGSize(width: CGFloat(3), height: CGFloat(3))
                layer.shadowColor = UIColor.systemGray5.cgColor

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
    }
    
}

