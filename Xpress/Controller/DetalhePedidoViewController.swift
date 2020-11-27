//
//  DetalhePedidoViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 11/18/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class DetalhePedidoViewController: UIViewController {

    @IBOutlet weak var tipoPagamentoLabel: UILabel!
    @IBOutlet weak var telefoneLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    var endereco: String = ""
    var telefone: String = ""
    var tipoPagamento: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
        tipoPagamentoLabel.text = tipoPagamento
        telefoneLabel.text = telefone
        enderecoLabel.text = endereco
    }
    
    @IBAction func buttonContinuar(_ sender: Any) {
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
