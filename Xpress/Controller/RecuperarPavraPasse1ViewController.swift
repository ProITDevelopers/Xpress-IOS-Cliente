//
//  RecuperarPavraPasse1ViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/19/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecuperarPavraPasse1ViewController: UIViewController {
    @IBOutlet weak var telefoneTextField: UITextField!
    var telefone = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        telefoneTextField.setLeftView(image: UIImage(named: "phone")!)
         
        HideKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func ButtonEnviar(_ sender: UIButton) {
        
        // fazer requisizaçao do código de confirmaçao para redefinir senha
        
          
        guard let contacto = telefoneTextField?.text, contacto.count > 0 else {
              print("Informa o numero de telefone")
            showToast(controller: self, message: "Informa o telefone", seconds: 2)
             telefoneTextField.layer.borderColor = UIColor.red.cgColor
              return
              
          }
        guard let contacto1 = telefoneTextField?.text, contacto1.count > 0, contacto1.count < 10 else {
                     print("Informa o numero de telefone")
                   showToast(controller: self, message: "Telefone inválido", seconds: 2)
                    telefoneTextField.layer.borderColor = UIColor.red.cgColor
                     return
                     
                 }
        
        
        if VerificarInternet.Connection() {
             mostrarProgresso()
              let URL = "\(linkPrincipal.urlLink)/SolicitarCodigoRecuperacao/\(contacto)"
                      telefone = contacto
                      
                      Alamofire.request(URL, method: .put, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
                                 if response.result.isSuccess{
                                     
                                     if response.response?.statusCode == 200 {
                                         
                                         print("Sucesso no envio do numero de telefone")
                                        self.terminarProgresso()
                                         self.performSegue(withIdentifier: "irCodigo", sender: self)
                                        self.telefoneTextField.text = ""
                                         
                                     } else  {
                                        self.terminarProgresso()
                                         self.showToast(controller: self, message: "Nº telefone não existe", seconds: 3)
                                         print(response)
                                         print("codigo errado 1")
                                     
                                     }
                                     
                                     //print(response.response?.statusCode)
                                     //print("Sucesso no autenticaçao")
                                 } else {
                                     let erro: JSON = JSON(response.result.value!)
                                     print(erro)
                                      print("codigo errado 2")
                                    self.terminarProgresso()
                                     self.showToast(controller: self, message: "Não pode criar a conta agora tenta mais tarde!", seconds: 3)
                                 }
                             }
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
            
        
          
         // let parametros = ["id": contacto] as [String : Any]
        
          
         
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irCodigo" {
                   let telefoneVC = segue.destination as? RecuperarPalavraPasse2ViewController
                   
                   telefoneVC?.telefone = telefone
               }
    }
    
    @IBAction func ButtonCancelar(_ sender: UIButton) {
         TransitarParaTelaLogin()
    }
    
    
}
