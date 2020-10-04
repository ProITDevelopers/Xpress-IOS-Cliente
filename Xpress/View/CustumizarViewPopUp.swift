//
//  CustumizarViewPopUp.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/30/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
class CustumizarViewPopUp: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutSubviews()
    }
    
    func setupView() {
        styleView()
        
    }
    
    
    func styleView() {
        layer.cornerRadius = 20.0
//        layer.shadowRadius = 10.0
//        layer.borderWidth = 0.2
//        let shadowPath2 = UIBezierPath(rect:  bounds)
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
//       layer.shadowOpacity = 0.6
//      layer.shadowPath = shadowPath2.cgPath
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
    }
}

