//
//  Sucessu2ViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/3/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class Sucessu2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() +  2) {
            print("ola")
             self.TransitarParaTelaPrincipal()
        }
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
