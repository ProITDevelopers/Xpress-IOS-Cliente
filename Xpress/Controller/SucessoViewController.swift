//
//  SucessoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/20/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class SucessoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        DispatchQueue.main.asyncAfter(deadline: .now() +  2) {
            print("ola")
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        // Do any additional setup after loading the view.
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
