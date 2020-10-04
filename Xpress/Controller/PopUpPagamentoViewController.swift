//
//  PopUpPagamentoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit


class PopUpPagamentoViewController: UIViewController {

  
     var tipoPagamento = ""
    var longitude = ""
    var latitude = ""
    var telemovel = ""
    var referencia = ""
    var produtoComprar = Produto()
    var estabelecimentoId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
           
        print(telemovel)
         print(referencia)
        print(longitude)
        print(latitude)
        print(produtoComprar)
        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func buttonMulticaixa(_ sender: UIButton) {
        tipoPagamento = "Multicaixa"
               print(tipoPagamento)
        performSegue(withIdentifier: "irCheckOut", sender: self)
       
    }
    @IBAction func buttonReferencia(_ sender: UIButton) {
        tipoPagamento = "Referência"
        print(tipoPagamento)
        performSegue(withIdentifier: "irCheckOut", sender: self)
      
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "irCheckOut" {
                  let checkoutVC = segue.destination as? CheckoutViewController
                  
            checkoutVC?.referencia = referencia
            checkoutVC?.telemovel = telemovel
                  checkoutVC?.longitude = longitude
                  checkoutVC?.latitude = latitude
            checkoutVC?.tipoPagamento = tipoPagamento
            if produtoComprar.idProduto != nil {
                    checkoutVC?.produtoComprar = produtoComprar
                    checkoutVC?.tipoCompra = 1
                checkoutVC?.estabelecimentoId = estabelecimentoId
                  }
              }
    }
    

}
