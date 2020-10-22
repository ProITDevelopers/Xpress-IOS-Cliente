//
//  RegistarViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/18/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class RegistarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgUsuario: UIImageView!
    @IBOutlet weak var btnM: UIButton!
    @IBOutlet weak var btnF: UIButton!
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var sobreNomeTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var palavraPasseTextFiled: UITextField!
    
   
    
     var fotoUsuario = UIImage()
     var genero = ""
    var resposta = Resposta()
    var selecionouFoto = false
    var buttonVerPassword = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

         fotoUsuario = imgUsuario.image!
        HideKeyboard()
        
        
        mostrarPassWord(button: buttonVerPassword, textField: palavraPasseTextFiled)
        mostrarPopUpInternet()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarPopUpInternet()
    }

    
    @objc func ButtonPasswordShow(){

        if(buttonVerPassword.isSelected == true) {
                   buttonVerPassword.setImage(UIImage(named: "passwordV"), for: .normal)
            palavraPasseTextFiled.isSecureTextEntry = true
               } else {
                  buttonVerPassword.setImage(UIImage(named: "passwordIv"), for: .normal)
             palavraPasseTextFiled.isSecureTextEntry = false
               }
               
               buttonVerPassword.isSelected = !buttonVerPassword.isSelected
        
       
    }
    
    
     //MARK: -Button Actions
    
    @IBAction func ButtonGenero1(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            btnM.isSelected = false
                   
        } else {
            sender.isSelected = true
            btnM.isSelected = false
            genero = "F"
            print(genero)
        }
    }
    
    
    @IBAction func ButtonGenero2(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            btnF.isSelected = false
                  
        } else {
            sender.isSelected = true
            btnF.isSelected = false
            genero = "M"
            print(genero)
        }
    }
    
    @IBAction func ButtonSelecionarFoto(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
               imagePickerController.delegate = self
               
               let actionSheet = UIAlertController(title: "Fonte da Foto", message: "Escolha uma fonte", preferredStyle: .actionSheet)
               
               actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                   
                   if UIImagePickerController.isSourceTypeAvailable(.camera) {
                       imagePickerController.sourceType = .camera
                       self.present(imagePickerController, animated: true, completion: nil)
                   
                   } else {
                       print("Camera nao esta disponivel")
                   }
                   
               }))
               
               actionSheet.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (action:UIAlertAction) in
                   imagePickerController.sourceType = .photoLibrary
               
                   self.present(imagePickerController, animated: true, completion: nil)
               }))
               
               actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
               
               self.present(actionSheet, animated: true, completion: nil)
    }
    
       //MARK: - UIMagePickercontroller Delegate
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imgUsuario.image = image
            selecionouFoto = true
            print(self.selecionouFoto)
            picker.dismiss(animated: true, completion: nil)
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func ButtonRegistar(_ sender: UIButton) {
        
        registarCliente()
    }
    
    @IBAction func buttonCancelar(_ sender: UIButton) {
        TransitarParaTelaLogin()
    }
    
    
    
}


extension RegistarViewController {
    
    func registarCliente() {
        
         guard let nome = nomeTextField?.text, nome.count > 0 else {
                         print("Informa o nome")
                         nomeTextField.layer.borderColor = UIColor.red.cgColor
                        
                         showToast(controller: self, message: "Informa o primeiro nome", seconds: 2)
                         return
                         
                     }
                     
                     guard let text01 = nomeTextField?.text, text01.count > 2 else {
                                       print("Informa o nome")
                                       showToast(controller: self, message: "primeiro nome deve ter mais de 2 caracters", seconds: 2)
                        nomeTextField.layer.borderColor = UIColor.red.cgColor
                                       return
                                       
                                   }
                     
                     
                     
                     guard let sobreNome = sobreNomeTextField?.text, sobreNome.count > 0 else {
                         print("Informa o sobrenome")
                         sobreNomeTextField.layer.borderColor = UIColor.red.cgColor
                          
                          showToast(controller: self, message: "Informa o sobrenome", seconds: 2)
                         return
                         
                     }
                    
                            guard let text02 = sobreNomeTextField?.text, text02.count > 2 else {
                                print("Informa o sobrenome")
                                showToast(controller: self, message: "sobrenome deve ter mais de 2 caracters", seconds: 2)
                                sobreNomeTextField.layer.borderColor = UIColor.red.cgColor
                                return
                                
                            }
          
                     
                     guard let telefone = telefoneTextField?.text, telefone.count > 0 else {
                         print("Informa o contacto")
                         telefoneTextField.layer.borderColor = UIColor.red.cgColor
                          showToast(controller: self, message: "Informa o telemovel", seconds: 2)
                     
                         return
                         
                     }
                     
                     guard let text04 = telefoneTextField?.text, text04.count == 9 else {
                                       print("Informa o contacto")
                                      showToast(controller: self, message: "numero de telemovel deve ter 9 caracters", seconds: 2)
                        telefoneTextField.layer.borderColor = UIColor.red.cgColor
                                       return
                                       
                                   }
                     
                     
                     guard let email = emailTextField?.text, email.count > 0 else {
                         print("Informa o email")
                         emailTextField.layer.borderColor = UIColor.red.cgColor
                         showToast(controller: self, message: "Informa o email", seconds: 2)
                         return

                     }
                     
                     guard let palavraPasse = palavraPasseTextFiled?.text, palavraPasse.count > 0 else {
                         print("Informa nome de usuário")
                         palavraPasseTextFiled.layer.borderColor = UIColor.red.cgColor
                           showToast(controller: self, message: "Informa a password!", seconds: 2)
                         return
                         
                     }
                     
                     guard let text06 = palavraPasseTextFiled?.text, text06.count > 5 else {
                                print("poucos caracteres na password ")
                                palavraPasseTextFiled.layer.borderColor = UIColor.red.cgColor
                                  showToast(controller: self, message: "a palavra passe deve conter 6 caracteres no minimo", seconds: 2)
                                return
                                
                            }
        
        
        
       
        
        if isValidEmail(email: emailTextField.text!) == true {
        
            mostrarProgresso()
            
            
            // let imageData =
             let image = imgUsuario.image
             let   imageData = image?.jpegData(compressionQuality: 0.2)
             let headers: HTTPHeaders = ["Content-type": "application/json"]
                                        
             let parametros = ["PrimeiroNome": nome, "UltimoNome": sobreNome, "ContactoMovel":telefone, "Sexo": genero, "Email":email, "Password": palavraPasse] as [String : String]
            
       let URL = "https://apixpress.lengueno.com/cadastrarcliente"
       
            
            if selecionouFoto == false {
                
                print("foto nao selecionado")
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    
                    for (key, value) in parametros {
                        
                        multipartFormData.append((value).data(using: .utf8)!, withName: key)
                    
                    }
                 //multipartFormData.append(imageData!, withName: "imagem", fileName: "image.jpeg", mimeType: "image/jpeg")//FILEURL IN APPEND
                                              
                }, usingThreshold: UInt64.init(), to: URL, method: .post, headers: headers) { (result) in switch result {
                
                
                                case.failure(let error):
                                    print("Erro aqui \(error)")
                                    
                                    self.terminarProgresso()
                                    self.showToast(controller: self, message: "nao foi possivel registar", seconds: 2)
                                  
                                    
                                case.success(request: let upload,  _,  _):
                                    upload.validate()
                                    upload.responseJSON { response in
                                    let jsonDecoder = JSONDecoder()
                                    // let valor: JSON = JSON(response.result.value!)
                    
                        
                                if(response.response?.statusCode == 200) {
                                    
                                    //codigo que mostra o sucesso do registo
                                    print(response.result)
                                    print("Sucesso: \(jsonDecoder)")
                                    self.terminarProgresso()
                                    self.showToast(controller: self, message: "\(jsonDecoder)", seconds: 2)
                                     DispatchQueue.main.asyncAfter(deadline: .now() +  1) {
                                               
                                               self.TransitarParaTelaLogin()
                                           }
                                    
                                                                                                               
                                } else {
                                    
                                    //erro quando insirimos algum dado que ja existe
                                            do {
                                                
                                                self.terminarProgresso()
                                                    print(response.result)
                                                        
                                                    self.resposta = try jsonDecoder.decode(Resposta.self, from: response.data!)
                                        
                                                    print("erro inesperado 1: \(self.resposta.message ?? "")")
                                                    print(response.response?.statusCode as Any)
                                                    self.showToast(controller: self, message: "aqui \(self.resposta.message!)", seconds: 5)
                                                    
                                                            
                                            } catch {
                                                 self.terminarProgresso()
                                                    print("Erro ao tentar registar")
                                                            
                                            }
                                                    
                                        }
                              
                            }
                    
                    }
                    
                }
             
            } else {
                //resposta quando foi selecionado imagem
                print("foto selecionada")
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    
                    for (key, value) in parametros {
                        
                        multipartFormData.append((value).data(using: .utf8)!, withName: key)
                    
                    }
                 multipartFormData.append(imageData!, withName: "imagem", fileName: "image.jpeg", mimeType: "image/jpeg")//FILEURL IN APPEND
                    print(multipartFormData)
                                              
                }, usingThreshold: UInt64.init(), to: URL, method: .post, headers: headers) { (result) in switch result {
                
                
                                case.failure(let error):
                                    print("Erro aqui \(error)")
                                    
                                    self.terminarProgresso()
                                    self.showToast(controller: self, message: "nao foi possivel registar", seconds: 2)
                                  
                                    
                                case.success(request: let upload,  _,  _):
                                    upload.validate()
                                    upload.responseJSON { response in
                                    let jsonDecoder = JSONDecoder()
                                    // let valor: JSON = JSON(response.result.value!)
                    
                        
                                if(response.response?.statusCode == 200) {
                                    
                                    //codigo que mostra o sucesso do registo
                                    print(response.result)
                                    print("Sucesso: \(jsonDecoder)")
                                    self.terminarProgresso()
                                    self.showToast(controller: self, message: "\(jsonDecoder)", seconds: 2)
                                     DispatchQueue.main.asyncAfter(deadline: .now() +  1) {
                                               
                                               self.TransitarParaTelaLogin()
                                           }
                                    
                                                                                                               
                                } else {
                                    
                                    //erro quando insirimos algum dado que ja existe
                                            do {
                                                
                                                self.terminarProgresso()
                                                    print(response.result)
                                                        
                                                    self.resposta = try jsonDecoder.decode(Resposta.self, from: response.data!)
                                        
                                                    print("erro inesperado 1: \(self.resposta.message ?? "")")
                                                    print(response.response?.statusCode as Any)
                                                    self.showToast(controller: self, message: "aqui \(self.resposta.message!)", seconds: 5)
                                                    
                                                            
                                            } catch {
                                                self.terminarProgresso()
                                                    print("aqui erro ao tentar registar")
                                                            
                                            }
                                                    
                                        }
                              
                            }
                    
                    }
                    
                }
            }
            
            
       
            
        
       
                
              }// fim da verificacao do email
        
                // se o email nao for valido
              else {
                self.terminarProgresso()
                showToast(controller: self, message: "email invalido.", seconds: 3)
                    
        }// fim se o email nao e valido

                    
                     
    }
    
    
}


extension RegistarViewController {
    
    func mostrarPassWord(button: UIButton, textField: UITextField) {
        button.setImage(UIImage(named: "passwordV"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        button.frame = CGRect(x: textField.frame.size.width - 25, y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.ButtonPasswordShow), for: .touchUpInside)
        
        textField.rightView = button
        textField.rightViewMode = .always
    }
}
