//
//  RecuperarSenhaViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/3/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecuperarSenhaViewController: UIViewController {
    @IBOutlet weak var telefoneLabel: UITextField!
    var telefone = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       mostrarPopUpInternet()
       
        telefoneLabel.setLeftView(image: UIImage(named: "phone")!)
        HideKeyboard()
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        telefoneLabel.text = ""
        mostrarPopUpInternet()
    }
    
    @IBAction func buttonEnviar(_ sender: UIButton) {
        // fazer requisizaçao do código de confirmaçao para redefinir senha
                 
               guard let contacto = telefoneLabel?.text, contacto.count > 0 else {
                     print("Informa o numero de telefone")
                   showToast(controller: self, message: "Informa o telefone", seconds: 2)
                telefoneLabel.layer.borderColor = UIColor.red.cgColor
                     return
                     
                 }
               guard let contacto1 = telefoneLabel?.text, contacto1.count > 0, contacto1.count < 10 else {
                            print("Informa o numero de telefone")
                          showToast(controller: self, message: "Telefone inválido", seconds: 2)
                           telefoneLabel.layer.borderColor = UIColor.red.cgColor
                            return
                            
                        }
               
                   
               
                 
                // let parametros = ["id": contacto] as [String : Any]
                mostrarProgresso()
                 
                 let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/SolicitarCodigoRecuperacao/\(contacto)"
                 telefone = contacto
                 
                 Alamofire.request(URL, method: .put, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
                            if response.result.isSuccess{
                                
                                if response.response?.statusCode == 200 {
                                    
                                    print("Sucesso no envio do numero de telefone")
                                    self.terminarProgresso()
                                    self.performSegue(withIdentifier: "irCodigo", sender: self)
                                    
                                    
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
                                self.terminarProgresso()
                                 print("codigo errado 2")
                                self.showToast(controller: self, message: "Não pode criar a conta agora tenta mais tarde!", seconds: 3)
                            }
                        }
       
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "irCodigo" {
            let telefoneVC = segue.destination as? RecuperarSenha2ViewController
            
            telefoneVC?.telefone = telefone
        }
    }
    

}
