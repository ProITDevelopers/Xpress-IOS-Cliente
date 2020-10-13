//
//  ViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/18/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//https://apivendas.xpressentregas.com

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import UserNotifications





class ViewController: UIViewController {

    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var palavraPasseTextField: UITextField!
    
    var token = Token()
    var buttonVerPassword = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuracaoNotification()
        usuarioTextField.setLeftView(image: UIImage(named: "perfil")!)
        palavraPasseTextField.setLeftView(image: UIImage(named: "icons8-forgot-password-30")!)
       
       mostrarPassWord(button: buttonVerPassword, textField: palavraPasseTextField)
        HideKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - mostra o numero de items no carrinho no botao carrino superior direito
    private func configuracaoNotification(){
                    //NOTIFICACOES
                    UNUserNotificationCenter.current().requestAuthorization(options:
                        [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                         // Handle Error
                    })
                    UNUserNotificationCenter.current().delegate = self
                }
    
    @objc func ButtonPasswordShow(){

        if(buttonVerPassword.isSelected == true) {
                   buttonVerPassword.setImage(UIImage(named: "passwordV"), for: .normal)
            palavraPasseTextField.isSecureTextEntry = true
               } else {
                  buttonVerPassword.setImage(UIImage(named: "passwordIv"), for: .normal)
             palavraPasseTextField.isSecureTextEntry = false
               }
               
               buttonVerPassword.isSelected = !buttonVerPassword.isSelected
        
       
    }
    
    
    @IBAction func ButtonEntrar(_ sender: UIButton) {
        
        
        
       guard let usuario = usuarioTextField?.text, usuario.count > 0 else {
              print("Informa o nome de usuario")
        usuarioTextField.layer.borderColor = UIColor.red.cgColor
              showToast(controller: self, message: "Informa o nome de usuario", seconds: 1)
              return
              
          }
          
          guard let password = palavraPasseTextField?.text, password.count > 0 else {
              print("Informa a senha")
           
            showToast(controller: self, message: "Informa a senha", seconds: 2)
             palavraPasseTextField.layer.borderColor = UIColor.red.cgColor
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
          
          //utilizando o MBProgressHUD para mostrar o processamento
          mostrarProgresso()
          
          
          
          
         // fazerLogin(usuario: usuario, senha: password)
         
        
          let URL = "https://apivendas.xpressentregas.com/authenticate2"
          
          Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
                    
                     
                     if response.result.isSuccess{
                         
                    
                         
                         do {
                             let jsonDecoder = JSONDecoder()
                             self.token = try jsonDecoder.decode(Token.self, from: response.data!)
                            UserDefaults.standard.setValue(self.token.tokenuser, forKey: "token")
                            UserDefaults.standard.setValue(self.token.expiracao, forKey: "dataExpiracao")
                         
                            
                            let token = UserDefaults.standard.string(forKey: "token")
                                             
                            guard let usuario = token, usuario != "" else {
                                self.terminarProgresso()
                                return
                                  
                            }
                            self.TransitarParaTelaPrincipal()
                                                      
                             
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
          
    }
    

    
    @IBAction func ButtonEsqueceuPalavraPasse(_ sender: UIButton) {
        
        performSegue(withIdentifier: "irRecuperar1", sender: self)
    }
    @IBAction func ButtonRegistar(_ sender: UIButton) {
        
        TransitarTela(idTela: "registarID")
        
    }
}

extension ViewController {
    
    func mostrarPassWord(button: UIButton, textField: UITextField) {
           button.setImage(UIImage(named: "passwordV"), for: .normal)
           button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
           button.frame = CGRect(x: textField.frame.size.width - 25, y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
           button.addTarget(self, action: #selector(self.ButtonPasswordShow), for: .touchUpInside)
           
           textField.rightView = button
           textField.rightViewMode = .always
       }
    
    
    
       
}


//MARK: EXTENSION QUE CONFIGURA AS NOTIFICAOES
extension ViewController: UNUserNotificationCenterDelegate {
func mostrarNotificacao(_ title: String, _ subtitile: String, _ body: String?=nil){
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitile
    content.body = body ?? ""
    content.badge = 0
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                    repeats: false)
    
    let requestIdentifier = UUID().uuidString
    let request = UNNotificationRequest(identifier: requestIdentifier,
                                        content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request,
                                           withCompletionHandler: { (error) in
                                            // Handle error
    })
}




func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
}



func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let application = UIApplication.shared
    let userInfo = response.notification.request.content
    //background
    if(application.applicationState == .active){
        print(userInfo.title)
        print(userInfo.subtitle)
        print(userInfo.body)
    }
    
    
    //foreground
    if(application.applicationState == .inactive)
    {
        print(userInfo.title)
        print(userInfo.subtitle)
        print(userInfo.body)
    }
    
    
    
    completionHandler()
}
}
