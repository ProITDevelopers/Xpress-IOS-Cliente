//
//  CustumizarViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/2/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
@available(iOS 13.0, *)
class CustumizarViewCell: UIView {
    
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
        layer.cornerRadius = 10.0
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





