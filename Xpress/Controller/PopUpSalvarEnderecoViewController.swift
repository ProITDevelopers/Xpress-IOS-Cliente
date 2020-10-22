//
//  PopUpSalvarEnderecoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/28/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
///https://apixpress.lengueno.com


import UIKit

import SwiftyJSON
import Alamofire

 // protocol passarDados {
   //   func dados(telef: String, ref: String)
    
 // }

class PopUpSalvarEnderecoViewController: UIViewController {
    
    var endereco = ""
    var longitude = ""
    var latitude = ""
    var telemovel = ""
    var referencia = ""
    var produtoComprar = Produto()
    var estabelecimentoId = 0
    // var delegate: passarDados?
    
    
    var perfil = [Perfil]()
    @IBOutlet weak var telemovelLabel: UITextField!
    @IBOutlet weak var referenciaLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        print(endereco)
        referenciaLabel.text = endereco
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonBuscarNumero(_ sender: UIButton) {
        obterPerfil()
    }
    
    @IBAction func buttonCancelar(_ sender: UIButton) {
         self.view.removeFromSuperview()
    }
    
    @IBAction func buttoContinuar(_ sender: UIButton) {
        
        guard let refer = referenciaLabel?.text, refer.count > 0 else {
                   print("Informa referencia")
                   return
                   
               }
               
               guard let telem = telemovelLabel?.text, telem.count > 0 else {
                   print("Informa telemove")
                   showToast(controller: self, message: "Informa telemove", seconds: 2)
                   
                   return
                   
               }
        guard let telefone = telemovelLabel?.text, telefone.count == 9 else {
            print("Informa telemove")
            showToast(controller: self, message: "Número incorreto", seconds: 2)
            
            return
            
        }
                
    
         //delegate?.dados(telef: telemovelLabel.text ?? "", ref: referenciaLabel.text ?? "")
        performSegue(withIdentifier: "irTipoPagamentoId", sender: self)
               
         self.view.removeFromSuperview()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "irTipoPagamentoId" {
            let tipoPagamentoVC = segue.destination as? PopUpPagamentoViewController
            
            tipoPagamentoVC?.referencia = referenciaLabel.text!
            tipoPagamentoVC?.telemovel = telemovelLabel.text!
            tipoPagamentoVC?.longitude = longitude
            tipoPagamentoVC?.latitude = latitude
            if produtoComprar.idProduto != nil {
                tipoPagamentoVC?.produtoComprar = produtoComprar
                tipoPagamentoVC?.estabelecimentoId = estabelecimentoId
            }
        }
    }
    

}

extension PopUpSalvarEnderecoViewController {
    
    func obterPerfil() {
          
          let URL = "https://apixpress.lengueno.com/PerfilCliente"
          
          let token = UserDefaults.standard.string(forKey: "token")
        
          
          let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
          
          Alamofire.request(URL, method: .get, headers: headrs).responseJSON { response in
              
              if response.result.isSuccess{
                  
                  
                
                  
                  do {
                      let jsonDecoder = JSONDecoder()
                    self.perfil = try jsonDecoder.decode([Perfil].self, from: response.data!)
                     
                    if self.perfil.isEmpty {
                          
                      } else {
                        self.mostrartelefone(numero: self.perfil[0].contactoMovel!)
                      }
                      
                  } catch {
                      print("erro inesperado: \(error)")
                  }
                  
              } else {
                  print(response)
              }
          }
          

      }
      
      
      func mostrartelefone(numero: String){
          telemovelLabel.text = numero
      }
}
