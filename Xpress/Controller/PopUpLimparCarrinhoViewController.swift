//
//  PopUpLimparCarrinhoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import RealmSwift

 protocol atualizarCarrinhoDelegate {
    
    func didAtualizarCarrinho()
   
}


class PopUpLimparCarrinhoViewController: UIViewController {

    
     var delegate1: atualizarCarrinhoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func buttoLimpar(_ sender: UIButton) {
        limparCarrinho()
        delegate1?.didAtualizarCarrinho()
        self.view.removeFromSuperview()
    }
    @IBAction func buttonCancelar(_ sender: UIButton) {
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
