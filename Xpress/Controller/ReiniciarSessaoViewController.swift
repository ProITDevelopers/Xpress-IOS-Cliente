//
//  ReiniciarSessaoViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/7/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import SDWebImage
import RealmSwift

class ReiniciarSessaoViewController: UIViewController {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var senhaLabel: UITextField!
    @IBOutlet weak var imgUsuario: UIImageView!
    var token = Token()
    var buttonVerPassword = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

          self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        mostrarPerfil()
        senhaLabel.setLeftView(image: UIImage(named: "icons8-forgot-password-30")!)
        mostrarPassWord(button: buttonVerPassword, textField: senhaLabel)
        // Do any additional setup after loading the view.
    }
    
    

        
        func mostrarPassWord(button: UIButton, textField: UITextField) {
               button.setImage(UIImage(named: "passwordV"), for: .normal)
               button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
               button.frame = CGRect(x: textField.frame.size.width - 25, y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
               button.addTarget(self, action: #selector(self.ButtonPasswordShow), for: .touchUpInside)
               
               textField.rightView = button
               textField.rightViewMode = .always
           }
        
        
        
           
 
    
    @objc func ButtonPasswordShow(){

           if(buttonVerPassword.isSelected == true) {
                      buttonVerPassword.setImage(UIImage(named: "passwordV"), for: .normal)
               senhaLabel.isSecureTextEntry = true
                  } else {
                     buttonVerPassword.setImage(UIImage(named: "passwordIv"), for: .normal)
                senhaLabel.isSecureTextEntry = false
                  }
                  
                  buttonVerPassword.isSelected = !buttonVerPassword.isSelected
           
          
       }
    func mostrarPerfil() {
        let imagemUsuario = UserDefaults.standard.string(forKey: "imgUsuario")
        
        let nomeCompleto = UserDefaults.standard.string(forKey: "nomeCompleto")
        //var casa: String?
         let url = imagemUsuario
       
         if url != "Sem Imagem" && url != nil {
             imgUsuario.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgUsuario.sd_setImage(with: URL(string: imagemUsuario!), placeholderImage: UIImage(named: "placeholder.phg"))
            
         } else {
            imgUsuario.image = UIImage(named:"fota.jpg")
            
        }
        
         nomeLabel.text = nomeCompleto
         
         
     }
    
  
    
    @IBAction func buttonRecuperarSenha(_ sender: UIButton) {
        
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.recuperarSenha) as! RecuperarSenhaViewController
            self.navigationController?.pushViewController(carrinhoVC, animated: true)
    }
    
    @IBAction func buttonEntrar(_ sender: UIButton) {
 
                guard let password = senhaLabel?.text, password.count > 0 else {
                    print("Informa a senha")
                 
                  showToast(controller: self, message: "Informa a senha", seconds: 2)
                   senhaLabel.layer.borderColor = UIColor.red.cgColor
                    return
                    
                }
              
             
                // verificar se e email
       
               
        let email = UserDefaults.standard.string(forKey: "emailUsuario")
                var parametros = [String: Any]()
               
               parametros = ["email": email!, "password": password]
              
                //utilizando o MBProgressHUD para mostrar o processamento
                mostrarProgresso()
                
                
                
                
               // fazerLogin(usuario: usuario, senha: password)
               
              
                let URL = "https://apixpress.lengueno.com/authenticate2"
                
                Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseString { response in
                          
                           
                           if response.result.isSuccess{
                               
                          
                               
                               do {
                                   let jsonDecoder = JSONDecoder()
                                   self.token = try jsonDecoder.decode(Token.self, from: response.data!)
                                  UserDefaults.standard.setValue(self.token.tokenuser, forKey: "token")
                                  UserDefaults.standard.setValue(self.token.expiracao, forKey: "dataExpiracao")
                                 
                                  
                                  let token = UserDefaults.standard.string(forKey: "token")
                                                   
                                  guard let usuario = token, usuario != "" else {
                                                          print(token as Any)
                                                          return
                                           self.terminarProgresso()
                                  }
                                  self.view.removeFromSuperview()
                                                            
                                   
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
                                self.showToast(controller: self, message: "Não foi possivel iniciar a sessão tente mais tarde!", seconds: 3)
                                print(response.error as Any)
                               
                           }
                       }
        
    }
    @IBAction func buttonOutraConta(_ sender: UIButton) {
        
               
               let realm = try! Realm()
               try! realm.write {
                   realm.deleteAll()
               }
               
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "nomeCompleto")
                UserDefaults.standard.removeObject(forKey: "emailUsuario")
                UserDefaults.standard.removeObject(forKey: "imgUsuario")
               TransitarParaTelaLogin()
        
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
