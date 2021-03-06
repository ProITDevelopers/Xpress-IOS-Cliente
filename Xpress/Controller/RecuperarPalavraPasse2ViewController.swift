//
//  RecuperarPalavraPasse2ViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/19/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RecuperarPalavraPasse2ViewController: UIViewController {

    @IBOutlet weak var palavraPasseTextField: UITextField!
    @IBOutlet weak var codigoTextField: UITextField!
    var telefone = ""
     var buttonPassword = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codigoTextField.setLeftView(image: UIImage(named:"icons8-forgot-password-30")!)
        palavraPasseTextField.setLeftView(image: UIImage(named: "icons8-forgot-password-30")!)

         
        mostrarPassWord(button: buttonPassword, textField: palavraPasseTextField)
        HideKeyboard()
        print(telefone)
        mostrarPopUpInternet()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarPopUpInternet()
    }
    
    @objc func ButtonPasswordShow(){

        
        
           if(buttonPassword.isSelected == true) {
                      buttonPassword.setImage(UIImage(named: "passwordV"), for: .normal)
               palavraPasseTextField.isSecureTextEntry = true
                  } else {
                     buttonPassword.setImage(UIImage(named: "passwordIv"), for: .normal)
                palavraPasseTextField.isSecureTextEntry = false
                  }
                  
                  buttonPassword.isSelected = !buttonPassword.isSelected
           
          
       }
    
    @IBAction func ButtonContinuar(_ sender: UIButton) {
        
        
        guard let codigo = codigoTextField?.text, codigo.count > 0 else {
                   print("por favor informa a nova senha")
                   showToast(controller: self, message: "por favor informa o código que recebeu por mensagem.", seconds: 3)
               codigoTextField.layer.borderColor = UIColor.red.cgColor
                   return
               }
        guard let senha = palavraPasseTextField?.text, senha.count > 0 else {
            print("por favor informa a nova senha")
            showToast(controller: self, message: "por favor informa a nova palavra passe", seconds: 3)
            codigoTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        
         guard let password1 = palavraPasseTextField?.text, password1.count > 4 else {
                            print("Informa a senha")
                         
            showToast(controller: self, message: "Informa uma palavra passe com mínimo 4 caracteres!", seconds: 2)
            
            palavraPasseTextField.layer.borderColor = UIColor.red.cgColor
                return
                            
                        }
        
        if VerificarInternet.Connection() {
                   redifinirSenha(codigo: codigo, password: senha)
               } else {
                   print("nao esta conectado")
                  showPopUpInternet()
               }
               
       
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}


extension RecuperarPalavraPasse2ViewController {
    
    func redifinirSenha(codigo: String, password: String) {
         mostrarProgresso()
           
           let parametros = ["codigoRecuperacao": codigo, "novaPassword": password] as [String : Any]
           let URL = "\(linkPrincipal.urlLink)/ReporSenha/\(telefone)"
           
           
           Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
               
               if response.result.isSuccess{
                 
                   if response.response?.statusCode == 200 {
                    self.terminarProgresso()
                    self.showPopUpSucessoSenha()
                     print("Senha atualizada com sucesso")
                     
                   } else  {
                    self.terminarProgresso()
                       print(response.debugDescription)
                       self.showToast(controller: self, message: "Código incorrecto", seconds: 2)
                       print("erro codigo")
                       
                   }
                   
                   //print(response.response?.statusCode)
                   //print("Sucesso no autenticaçao")
               } else {
                   let erro: JSON = JSON(response.result.value!)
                   print(erro)
                self.terminarProgresso()
                   self.showToast(controller: self, message: "Não é possivel alterar a palavra passe, tente mais tarde!", seconds: 3)
               }
           }
    }
}


extension RecuperarPalavraPasse2ViewController {
    
    func mostrarPassWord(button: UIButton, textField: UITextField) {
        button.setImage(UIImage(named: "passwordV"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        button.frame = CGRect(x: textField.frame.size.width - 25, y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.ButtonPasswordShow), for: .touchUpInside)
        
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    func showPopUpSucessoSenha() {
              let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sucessoPalavraPasseId") as! SucessoViewController
              
              self.addChild(popOverVC)
              popOverVC.view.frame = self.view.frame
              self.view.addSubview(popOverVC.view)
              popOverVC.didMove(toParent: self)
          }
    
}
