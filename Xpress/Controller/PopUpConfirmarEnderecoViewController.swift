//
//  PopUpConfirmarEnderecoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/28/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

 

class PopUpConfirmarEnderecoViewController: UIViewController {
     
    var endereco = ""
    @IBOutlet weak var enderecoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            enderecoLabel.text = endereco
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonSim(_ sender: UIButton) {
       
        self.view.removeFromSuperview()
      
        
    }
    @IBAction func buttonNao(_ sender: UIButton) {
        self.view.removeFromSuperview()
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


extension PopUpConfirmarEnderecoViewController {
    
   
}
