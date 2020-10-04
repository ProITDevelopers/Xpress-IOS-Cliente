//
//  PopUpSucessoFotoViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/3/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit


class PopUpSucessoFotoViewController: UIViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonOk(_ sender: UIButton) {
         // self.view.removeFromSuperview()
        
        navigationController?.popViewController(animated: true)
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

