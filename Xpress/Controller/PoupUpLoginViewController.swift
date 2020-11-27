//
//  PoupUpLoginViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/26/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

 protocol atualizarTokenDelegate {
    
    func didAtualizarEncomendas()
 }
 protocol atualizarTokenDelegate2 {
    
    func didAtualizarCarrinho2()
   
}
protocol atualizarBotaoDelegate2 {
    
    func didAtualizarBotao2()
   
   
}

class PoupUpLoginViewController: UIViewController {
    
    var delegate2: atualizarTokenDelegate?
    var delegate3: atualizarTokenDelegate2?
    var delegate4: atualizarBotaoDelegate2?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    var buttonVerPassword = UIButton(type: .custom)
    var telaOrigem: Int = 0
    var token = Token()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        emailTextField.setLeftView(image: UIImage(named: "perfil")!)
        senhaTextField.setLeftView(image: UIImage(named: "icons8-forgot-password-30")!)
        mostrarPassWord(button: buttonVerPassword, textField: senhaTextField)
        // Do any additional setup after loading the view.
    }
    
    @objc func ButtonPasswordShow(){

          if(buttonVerPassword.isSelected == true) {
                     buttonVerPassword.setImage(UIImage(named: "passwordV"), for: .normal)
              senhaTextField.isSecureTextEntry = true
                 } else {
                    buttonVerPassword.setImage(UIImage(named: "passwordIv"), for: .normal)
               senhaTextField.isSecureTextEntry = false
                 }
                 
                 buttonVerPassword.isSelected = !buttonVerPassword.isSelected
          
         
      }
    
    func mostrarPassWord(button: UIButton, textField: UITextField) {
        button.setImage(UIImage(named: "passwordV"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        button.frame = CGRect(x: textField.frame.size.width - 25, y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.ButtonPasswordShow), for: .touchUpInside)
        
        textField.rightView = button
        textField.rightViewMode = .always
    }

    /*
    // MARK: - Navigation
     @IBAction func ButtonRegistar(_ sender: UIButton) {
     }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func ButtonRecuperarSenha(_ sender: UIButton) {
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recuperarSenhaId") as! RecuperarSenhaViewController
        self.navigationController?.pushViewController(carrinhoVC, animated: true)
    }
    
    @IBAction func ButtonEntrar(_ sender: UIButton) {
        
            guard let usuario = emailTextField?.text, usuario.count > 0 else {
                   print("Informa o nome de usuario")
             emailTextField.layer.borderColor = UIColor.red.cgColor
                   showToast(controller: self, message: "Informa o nome de usuario", seconds: 1)
                   return
                   
               }
               
               guard let password = senhaTextField?.text, password.count > 0 else {
                   print("Informa a senha")
                
                 showToast(controller: self, message: "Informa a senha", seconds: 2)
                  senhaTextField.layer.borderColor = UIColor.red.cgColor
                   return
                   
               }
             
            
               // verificar se e email
               let verificacao = isValidEmail(email: usuario)
               
               var parametros = [String: Any]()
               if verificacao == true {
                   print(verificacao)
                   parametros = ["email": usuario, "password": password]
               } else {
                     print(verificacao)
                    parametros = ["telefone": usuario, "password": password]
               }
        
        
        
        if VerificarInternet.Connection() {
            
             mostrarProgresso()
            let URL = "\(linkPrincipal.urlLink)/authenticate2"
                         
                         Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
                                   
                                     
                                    if response.result.isSuccess{
                                        self.terminarProgresso()
                                   
                                        
                                        do {
                                            let jsonDecoder = JSONDecoder()
                                            self.token = try jsonDecoder.decode(Token.self, from: response.data!)
                                           
                                        UserDefaults.standard.setValue(self.token.tokenuser, forKey: "token")
                                          UserDefaults.standard.setValue(self.token.expiracao, forKey: "dataExpiracao")
                                           
                                           let token = UserDefaults.standard.string(forKey: "token")
                                                            
                                           guard let usuario = token, usuario != "convidado" else {
                                               
                                               return
                                                 
                                           }
                                        
                                          
                                          if self.telaOrigem == 1 {
                                              self.delegate2?.didAtualizarEncomendas()
                                             self.view.removeFromSuperview()
                                          }
                                          if self.telaOrigem == 2{
                                              
                                              self.TransitarParaTelaPrincipal()
                                          }
                                          
                                          if self.telaOrigem == 3 {
                                              self.delegate3?.didAtualizarCarrinho2()
                                               self.view.removeFromSuperview()
                                          }
                                          
                                          if self.telaOrigem == 4 {
                                              
                                              self.delegate4?.didAtualizarBotao2()
                                              self.view.removeFromSuperview()
                                          }
                                          
                                          if self.telaOrigem == 5 {
                                              
                                              self.navigationController?.popToRootViewController(animated: true)
                                          }
                                          
                                             
                                              
                                            
                                        } catch {
                                         
                                     
                                           //erro na autenticacao
                                           self.terminarProgresso()
                                         self.showToast(controller: self, message: response.result.value!, seconds: 2)
                                          
                                            print("erro inesperado1: \(error)")
                                        }
                            
                                       
                                     

                                        
                                    } else {
                                       
                                         // print(response.response?.statusCode )
                                          // codigo que gera a UIAlertController (aviso de erro ao fazer login)
                                     
                                       self.terminarProgresso()
                                         self.showToast(controller: self, message: "O dispositivo não esta conectado a nenhuma rede 3G OU WI-FI..", seconds: 3)
                                         print(response.error as Any)
                                        
                                    }
                                }
            
            
            
            
        } else {
            print("nao esta conectado")
            self.showToast(controller: self, message: "O dispositivo não esta conectado a nenhuma rede 3G OU WI-FI..", seconds: 3)
            
        }
        
               
               //utilizando o MBProgressHUD para mostrar o processamento
              
               
               
               
               
              // fazerLogin(usuario: usuario, senha: password)
              
             
             
               
    }
    @IBAction func ButtonRegistar(_ sender: UIButton) {
        TransitarTela(idTela: "registarID")
    }
    @IBAction func ButtonCancelar(_ sender: UIButton) {
        
        if telaOrigem == 1 {
           // let token = UserDefaults.standard.string(forKey: "token")
          //  if !token!.isEmpty {
               self.view.removeFromSuperview()
        //   }
           
            
        }
        
        if telaOrigem == 2 {
            self.view.removeFromSuperview()
        }
        
        if telaOrigem == 3 {
            self.delegate4?.didAtualizarBotao2()
             self.view.removeFromSuperview()
        }
        
        if self.telaOrigem == 4 {
            self.delegate4?.didAtualizarBotao2()
            self.view.removeFromSuperview()
            
        }
        
        if self.telaOrigem == 5 {
           self.navigationController?.popToRootViewController(animated: true)
            
        }

    }
}
