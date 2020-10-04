//
//  SucessoMulticaixaViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class SucessoMulticaixaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

      
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                       print("ola")
                       self.navigationController?.popToRootViewController(animated: true)
                   }
      
        
        
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttoFechar(_ sender: UIButton) {
         self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 2
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
