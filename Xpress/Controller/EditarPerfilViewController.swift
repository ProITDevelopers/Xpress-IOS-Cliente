//
//  EditarPerfilViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/26/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
////https://apixpress.lengueno.com

import UIKit
import Alamofire
import SwiftyJSON
import Photos
import SDWebImage
import MBProgressHUD

class EditarPerfilViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    let provinciaArray = [ "Bengo", "Benguela", "Bié",  "Cabinda", "Cuando-Cubango", "Cuanza Sul", "Cuanza Norte", "Cunene", "Huambo", "Huíla", "Luanda", "Lunda Norte", "Lunda Sul", "Malanje", "Moxico", "Namibe", "Uíge", "Zaire"]
    
    var perfil = [Perfil]()
    
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var sobrenomeTextField: UITextField!
    @IBOutlet weak var telefoneAlternativoTextField: UITextField!
    
    @IBOutlet weak var btnM: UIButton!
    @IBOutlet weak var btnF: UIButton!
    @IBOutlet weak var municipioTextField: UITextField!
    @IBOutlet weak var bairroTextField: UITextField!
    @IBOutlet weak var ruaTextField: UITextField!
    @IBOutlet weak var casaTextField: UITextField!
    @IBOutlet weak var provinciaTextField: UITextField!
    @IBOutlet weak var btnSalvarFoto: UIButton!
    
    let picker = UIPickerView()
   var selecionarFoto = false
    var genero = ""
    var fotografiaSelecionada = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        verPickerProvincia()
        HideKeyboard()
        mostrarButtonEditar()
        if VerificarInternet.Connection() {
             obterPerfil()
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if VerificarInternet.Connection() {
             
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
    }
    
    
    func verPickerProvincia(){
           picker.delegate = self
        provinciaTextField.inputView = picker
            //provinciaTextField.backgroundColor = .white
       }
    
    @IBAction func buttonSalvarFoto(_ sender: UIButton) {
       
    }
    
    func mostrarButtonEditar() {
           // button
                       let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
                       rightButton.setBackgroundImage(UIImage(named: "icons8-checkmark-40"), for: .normal)
                       rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)

                      // rightButton.addSubview(label)
                       
                       // Bar button item
                       let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
                       
                       navigationItem.rightBarButtonItems  = [rightBarButtomItem]
      }
      

      @objc func rightButtonTouched() {
           print("right button touched")
        if selecionarFoto == true {
              salvarFoto()
        }
        
    }
    
    
    @IBAction func ButtonAlterarFoto(_ sender: UIButton) {
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
            imgPerfil.image = image
            selecionarFoto = true
            fotografiaSelecionada = image!
            
            picker.dismiss(animated: true, completion: nil)
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    
    
    
    
    
    
    @IBAction func ButtonMasculino(_ sender: UIButton) {
        
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
    
    
    @IBAction func ButtonFemenino(_ sender: UIButton) {
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
    
    @IBAction func ButtonSalvar(_ sender: UIButton) {
        atualizarCliente()
       
       
    }
    
    // MARK: - Mostra todos os dados do perfil nos textField
    
    func mostrarPerfil(perfil: Perfil) {
        
        
        
        let url = perfil.imagem
       
        
        if url != "Sem Imagem" && url != nil {
            imgPerfil.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        imgPerfil.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "placeholder.phg"))
        } else {
             imgPerfil.image = UIImage(named:"fota.jpg")
        }
        
        nomeTextField.text = perfil.primeiroNome
        sobrenomeTextField.text = perfil.ultimoNome
        telefoneAlternativoTextField.text = perfil.contactoAlternativo
           
        
        if perfil.sexo == "M" {
            btnM.isSelected = true
        } else {
            btnF.isSelected = true
        }
        
          
        municipioTextField.text = perfil.municipio
        bairroTextField.text = perfil.bairro
        ruaTextField.text = perfil.rua
        casaTextField.text = perfil.nCasa
        provinciaTextField.text = perfil.provincia
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showPopUpFuncao(){
          
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.sucessoFotoPopUp) as! PopUpSucessoFotoViewController
          self.addChild(popOverVC)
          popOverVC.view.frame = self.view.frame
          self.view.addSubview(popOverVC.view)
          popOverVC.didMove(toParent: self)
      }

}


extension EditarPerfilViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return provinciaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return provinciaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        provinciaTextField.text = provinciaArray[row]
        print(provinciaArray[row])
        view.endEditing(true)
    }
}


extension EditarPerfilViewController {
    
    func obterPerfil()  {
        
       
        
             let URL = "https://apixpress.lengueno.com/PerfilCliente"
           
            let token = UserDefaults.standard.string(forKey: "token")
        
        
        
         
           let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
           Alamofire.request(URL, method: .get, headers: headrs).responseJSON { response in
                    
                    if response.result.isSuccess{
                       
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.perfil = try jsonDecoder.decode([Perfil].self, from: response.data!)
                            print(self.perfil[0])
                           
                                  
                                   
                            self.mostrarPerfil(perfil: self.perfil[0])
                           
                            
                        } catch {
                            
                            print("erro inesperado: \(error)")
                        }

                    } else {
                       
                       print("Erro verifica por favor.")
                       print(response.debugDescription)
                        print(response)
                    }
                }

       }
    
    
    
    // metodo de registar o cliente usando post
    func atualizarCliente() {
       
        guard let nome = nomeTextField?.text, nome.count > 0 else {
                                print("Informa o nome")
                                nomeTextField.layer.borderColor = UIColor.red.cgColor
                               
                                showToast(controller: self, message: "informar o primeiro nome", seconds: 2)
                                return
                                
                            }
                            
        guard let text01 = nomeTextField?.text, text01.count > 2 else {
                                              print("Informa o nome")
                                              showToast(controller: self, message: "primeiro nome deve ter mais de 2 caracters", seconds: 2)
                                              return
                                              
                                          }
                            
                            
                            
            guard let sobreNome = sobrenomeTextField?.text, sobreNome.count > 0 else {
                                print("Informa o sobrenome")
                                sobrenomeTextField.layer.borderColor = UIColor.red.cgColor
                                 
                                 showToast(controller: self, message: "informar o sobrenome", seconds: 2)
                                return
                                
                            }
                           
            guard let text02 = sobrenomeTextField?.text, text02.count > 2 else {
                                       print("Informa o sobrenome")
                                       showToast(controller: self, message: "sobrenome deve ter mais de 2 caracters", seconds: 2)
                                       return
                                       
                                   }
                 
                            
            guard let telefone = telefoneAlternativoTextField?.text, telefone.count > 0 else {
                                print("Informa o contacto")
                                telefoneAlternativoTextField.layer.borderColor = UIColor.red.cgColor
                                 showToast(controller: self, message: "informar o telemovel", seconds: 2)
                            
                                return
                                
                            }
                            
            guard let text04 = telefoneAlternativoTextField?.text, text04.count == 9 else {
                                              print("Informa o contacto")
                                             showToast(controller: self, message: "numero de telemovel deve ter 9 caracters", seconds: 2)
                                              return
                                              
                                          }
                            
                            
        guard let municipio = municipioTextField?.text, municipio.count > 0 else {
                                print("Informa o município")
                                municipioTextField.layer.borderColor = UIColor.red.cgColor
                                showToast(controller: self, message: "informar o município", seconds: 2)
                                return

                            }
                            
        guard let bairro = bairroTextField?.text, bairro.count > 0 else {
                                print("Informa o bairro")
                                bairroTextField.layer.borderColor = UIColor.red.cgColor
                                  showToast(controller: self, message: "informar o bairro!", seconds: 2)
                                return
                                
                            }
                            
            guard let rua = ruaTextField?.text, rua.count > 0 else {
                                       print("Informa a rua ")
                                       ruaTextField.layer.borderColor = UIColor.red.cgColor
                                         showToast(controller: self, message: "informar a rua", seconds: 2)
                                       return
                                       
                                   }
        
        guard let casa = casaTextField?.text, casa.count > 0 else {
                                             print("Informa a casa ")
                                             ruaTextField.layer.borderColor = UIColor.red.cgColor
                                               showToast(controller: self, message: "informar a casa", seconds: 2)
                                             return
                                             
                                         }
        guard let provincia = provinciaTextField?.text, rua.count > 0 else {
                                             print("Informa a província ")
                                             ruaTextField.layer.borderColor = UIColor.red.cgColor
                                               showToast(controller: self, message: "informar a província", seconds: 2)
                                             return
                                             
                                         }
      
        
     let URL = "https://apixpress.lengueno.com/UpdateDadosPessoaisCliente"
        
        var parametros = [String:String]()
       
             let parametros1 = ["primeiroNome": nome, "ultimoNome": sobreNome, "contactoAlternativo": telefone, "provincia": provincia, "municipio": municipio, "bairro": bairro, "rua": rua, "nCasa": casa, "sexo": genero] as [String : Any]
     
            
            let parametros2 = ["primeiroNome": nome, "ultimoNome": sobreNome, "contactoAlternativo": telefone, "provincia": provincia, "municipio": municipio, "bairro": bairro, "rua": rua, "nCasa": casa, "sexo": genero] as [String : Any]
     
        if telefone == "" {
            parametros = parametros1 as! [String : String]
        } else {
            parametros = parametros2 as! [String : String]
        }
        
        
        let token = UserDefaults.standard.string(forKey: "token")
        print(token ?? "")
          mostrarProgresso()
        let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
        
        Alamofire.request(URL, method: .put, parameters: parametros, encoding: JSONEncoding.default, headers: headrs).responseString { response in
            if response.result.isSuccess{
                 self.terminarProgresso()
                if response.response?.statusCode == 200 {
                    print(response.response?.statusCode ?? "")
                    print("Sucesso no registo")
                    self.showToast1(controller: self, message: "Salvo com sucesso!", seconds: 2)
                    self.obterPerfil()
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() +  1) {
                                   print("ola")
                               self.navigationController?.popViewController(animated: true)
                                  
                           }
                    
                    
                    
                } else {
                    self.terminarProgresso()
                    self.showToast(controller: self, message: "Não foi possivel salvar!", seconds: 2)
                    print("Erro verifica por favor.")
                    print(response.response?.statusCode ?? "")
                    print(response.debugDescription)
                }
            } else {
                self.terminarProgresso()
                print(response.result)
            }
        }
        

    }
}


extension EditarPerfilViewController {
    func salvarFoto() {
           

        let imageData = fotografiaSelecionada.jpegData(compressionQuality: 0.2)
           let token = UserDefaults.standard.string(forKey: "token")
          
           
           let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Content-Type" : "application/json"]
           
           mostrarProgresso()
           
           Alamofire.upload(multipartFormData: { (multipartFormData) in
               
               multipartFormData.append(imageData!, withName: "FotoCapa", fileName: "image.jpeg", mimeType: "image/jpeg")//FILEURL IN APPEND
           }, usingThreshold: UInt64.init(), to: "https://apixpress.lengueno.com/AlterarFotoPerfilCliente", method: .post, headers: headrs) { (result) in switch result {
               
           case .success(let upload, _, _):
               upload.responseData(completionHandler: { response in
                
                   if response.response?.statusCode == 200 {
                    print(response.response?.statusCode)
                     self.terminarProgresso()
                       print("FOTO CARREGADA COM SUCESSO")
                   
                   
                    self.showPopUpFuncao()
                   } else {
                     self.terminarProgresso()
                    print(response.response?.statusCode)
                       print("ERRO AO CARREGAR A FOTO")
                    self.showToast1(controller: self, message:"Não foi possivel salvar a fotografia.", seconds: 2)
                   }
               })
               
           case .failure(let error):
             self.terminarProgresso()
               print("Error in upload:\(error.localizedDescription)")
               }
               
               
           }
       }
}
