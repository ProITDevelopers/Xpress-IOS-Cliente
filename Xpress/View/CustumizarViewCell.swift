//
//  CustumizarViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/2/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

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
    
    
    
    func styleView() {
        layer.cornerRadius = 10.0
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





