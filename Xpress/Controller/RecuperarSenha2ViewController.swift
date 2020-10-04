//
//  RecuperarSenha2ViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/3/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecuperarSenha2ViewController: UIViewController {

    @IBOutlet weak var codigoTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
   var telefone = ""
    var buttonPassword = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colocarImageTextField(textField: codigoTextField, nome: "lock")
         colocarImageTextField(textField: senhaTextField, nome: "lock")
        mostrarPassWord(button: buttonPassword, textField: senhaTextField)
        HideKeyboard()
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
               senhaTextField.isSecureTextEntry = true
                  } else {
                     buttonPassword.setImage(UIImage(named: "passwordIv"), for: .normal)
                senhaTextField.isSecureTextEntry = false
                  }
                  
                  buttonPassword.isSelected = !buttonPassword.isSelected
           
          
       }
    @IBAction func buttonContinuar(_ sender: UIButton) {
        
        guard let codigo = codigoTextField?.text, codigo.count > 0 else {
                          print("por favor informa a nova senha")
                          showToast(controller: self, message: "por favor informa o código que recebeu por mensagem.", seconds: 3)
                      codigoTextField.layer.borderColor = UIColor.red.cgColor
                          return
                      }
               guard let senha = senhaTextField?.text, senha.count > 0 else {
                   print("por favor informa a nova senha")
                   showToast(controller: self, message: "por favor informa a nova palavra passe", seconds: 3)
                   senhaTextField.layer.borderColor = UIColor.red.cgColor
                   return
               }
               
               
                guard let password1 = senhaTextField?.text, password1.count > 4 else {
                                   print("Informa a senha")
                                
                   showToast(controller: self, message: "Informa uma palavra passe com mínimo 4 caracteres!", seconds: 2)
                   
                   senhaTextField.layer.borderColor = UIColor.red.cgColor
                       return
                                   
                               }
               
               
                      redifinirSenha(codigo: codigo, password: senha)
        
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

extension RecuperarSenha2ViewController {
    
    func redifinirSenha(codigo: String, password: String) {
           
           let parametros = ["codigoRecuperacao": codigo, "novaPassword": password] as [String : Any]
           let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/ReporSenha/\(telefone)"
           
           
           Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
               
               if response.result.isSuccess{
                 
                   if response.response?.statusCode == 200 {
                    
                    self.showPopUpSucessoSenha()
                       print("Senha atualizada com sucesso")
                     
                   } else  {
                       
                       print(response.debugDescription)
                       self.showToast(controller: self, message: "Código incorrecto", seconds: 2)
                       print("erro codigo")
                       
                   }
                   
                   //print(response.response?.statusCode)
                   //print("Sucesso no autenticaçao")
               } else {
                   let erro: JSON = JSON(response.result.value!)
                   print(erro)
                   self.showToast(controller: self, message: "Não é possivel alterar a palavra passe, tente mais tarde!", seconds: 3)
               }
           }
    }
}


extension RecuperarSenha2ViewController {
    
    func mostrarPassWord(button: UIButton, textField: UITextField) {
        button.setImage(UIImage(named: "passwordV"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        button.frame = CGRect(x: textField.frame.size.width - 25, y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.ButtonPasswordShow), for: .touchUpInside)
        
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    func showPopUpSucessoSenha() {
           let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sucessoSenhaId") as! SairPopUpViewController
           
           self.addChild(popOverVC)
           popOverVC.view.frame = self.view.frame
           self.view.addSubview(popOverVC.view)
           popOverVC.didMove(toParent: self)
       }
}
