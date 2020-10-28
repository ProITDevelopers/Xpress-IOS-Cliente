//
//  ExtensionController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/20/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import MBProgressHUD
import RealmSwift
import UserNotifications





//MARK: FUNCAO QUE BAIXA O TECLADO

extension UIViewController {
 func HideKeyboard() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DimissKeyboard))
     view.addGestureRecognizer(tap)
 }
 
 @objc func DimissKeyboard() {
     view.endEditing(true)
 }
 
 //MARK: FUNCAO QUE VERIFICA EMAIL
 func isValidEmail( email: String) -> Bool {
     let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

     let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
     return emailPred.evaluate(with: email)
 }
    
    //MARK: FUNCAO QUE TRANSITA PARA TELA PRINCIPAL
    
    func TransitarParaTelaPrincipal() {
        
         if #available(iOS 13.0, *) {
                   TransitarParaTelaPrincipal13()
               } else {
                    TransitarParaTelaPrincipal12()
               }
    }
    
    func TransitarParaTelaPrincipal12() {
        
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let principal = mainStoryboard.instantiateViewController(withIdentifier: StoryboardID.pricipal) as! UITabBarController
        let appDeleegate = UIApplication.shared.delegate
        appDeleegate?.window??.rootViewController = principal
        
    }
    
    
    
    @available(iOS 13.0, *)
    func TransitarParaTelaPrincipal13() {
        let principal = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardID.pricipal)
        if let windowscene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowscene.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = principal
    
        }
    }
    
     //MARK: FUNCAO QUE MOSTRA TOAST (MENSAGEM)
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
              let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           alert.view.backgroundColor = UIColor.red
              alert.view.alpha = 0.6
              alert.view.layer.cornerRadius = 15
              controller.present(alert, animated: true)
              DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                  alert.dismiss(animated: true)
              }
          }
    
    func showToast1(controller: UIViewController, message: String, seconds: Double) {
                 let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
              alert.view.backgroundColor = UIColor.blue
                 alert.view.alpha = 0.6
                 alert.view.layer.cornerRadius = 15
                 controller.present(alert, animated: true)
                 DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                     alert.dismiss(animated: true)
                 }
             }
    
    
     //MARK: FUNCAO QUE PROCESSAMENTO
    func mostrarProgresso() {
        
        //utilizando o MBProgressHUD para mostrar o processamento
        let processando = MBProgressHUD.showAdded(to: self.view, animated: true)
        processando.label.text = "Espere..."
        processando.mode = .indeterminate
       // processando.backgroundView.style = .blur
       // processando.backgroundView.color = UIColor(white: 0.0, alpha: 0.7)
        
    }
     //MARK: FUNCAO QUE TERMINA O PROCESSAMENTO
    func terminarProgresso() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    
    //MARK: FUNCAO QUE TRANSITA PARA TELA DE LOGIN
        func TransitarParaTelaLogin() {
        
         if #available(iOS 13.0, *) {
                   TransitarParaTelaLogin13()
               } else {
                    TransitarParaTelaLogin12()
               }
    }
    func TransitarParaTelaLogin12() {
           
               let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login = mainStoryboard.instantiateViewController(withIdentifier: StoryboardID.navigatioLogin)
           let appDeleegate = UIApplication.shared.delegate
           appDeleegate?.window??.rootViewController = login
           
       }
       
       
       
       @available(iOS 13.0, *)
       func TransitarParaTelaLogin13() {
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardID.navigatioLogin)
           if let windowscene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowscene.delegate as? SceneDelegate, let window = sceneDelegate.window {
               window.rootViewController = login
       
           }
       }
    
    
    
    
    func verificarUIImage(image: UIImage) -> Bool {
        let cgref = image.cgImage
        let cim = image.ciImage

        if cim == nil && cgref == nil {
            return true
        } else {
            return false
        }
        
    }
    
    func colocarImageTextField(textField: UITextField, nome: String) {
        if #available(iOS 13.0, *) {
            
             textField.setLeftView(image: UIImage(systemName:nome)!)
        } else {
            // textField.setLeftView(image: UIImage(named:nome)!)
            let imageView = UIImageView();
            let image = UIImage(named: nome);
            imageView.image = image;
            textField.leftView = imageView;
        }
       
    }
    
    
    
    
    // MARK: - mostra o numero de items no carrinho no botao carrino superior direito

    func contarItem (label: UILabel) {
        
        do {
            
             let realm = try Realm()
            let numeroItens = realm.objects(ItemsCarrinho.self)
            
            label.text = "\(numeroItens.count)"
            
        } catch let error {
            print(error)
        }
    }
    
     // MARK: - retorna o numero de items no carrinho
    func contarItem1 () -> Int {
              var numero = 0
              do {
                  
                   let realm = try Realm()
                  let numeroItens = realm.objects(ItemsCarrinho.self)
                  
                   numero = numeroItens.count
                  
              } catch let error {
                  print(error)
              }
              return numero
          }
     // MARK: - metodo que limpa o carrinho
    func limparCarrinho(){
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    
    //MARK: FUNCAO QUE TRANSITA PARA QUALQUER Tela
    func TransitarTela(idTela: String) {
           
            if #available(iOS 13.0, *) {
               TransitarTela13(idTela: idTela)
                  } else {
                TransitarTela12(idTela: idTela)
                  }
       }
       func TransitarTela12(idTela: String) {
              
                  let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login = mainStoryboard.instantiateViewController(withIdentifier: idTela)
              let appDeleegate = UIApplication.shared.delegate
              appDeleegate?.window??.rootViewController = login
              
          }
          
          
          
          @available(iOS 13.0, *)
          func TransitarTela13(idTela: String) {
            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: idTela)
              if let windowscene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowscene.delegate as? SceneDelegate, let window = sceneDelegate.window {
                  window.rootViewController = login
          
              }
          }
    
    //MARK: FUNCAO QUE Converte a data
    func converterData(dataConverter: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let converteData = format.date(from: dataConverter)
        format.timeZone = TimeZone.current
        format.dateFormat = "dd MMM, yyyy"
        let localDateStr = format.string(from: converteData!)
        return localDateStr

    }
    
    func converterData2(dataConverter: String) -> String {
           
           let format = DateFormatter()
           format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
           let converteData = format.date(from: dataConverter)
           format.timeZone = TimeZone.current
           format.dateFormat = "dd MMM, yyyy"
           let localDateStr = format.string(from: converteData!)
           return localDateStr
       }
    
     //MARK: FUNCAO QUE MOSTRA O POPUP DA FALTA DE INTERNET
    func mostrarPopUpInternet(){
        if VerificarInternet.Connection() {
            print("conectado")
        } else {
            print("nao esta conectado")
            showPopUpInternet()
        }
    }
    
    func showPopUpInternet() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popInternetId") as! ShowPopUpInternetViewController
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
}


extension UITextField {
    
     //MARK: FUNCAO QUE COLOCA ICON NO TEXTFIELD
   
      func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
      }
    
    
    
}





extension UIViewController {
    
    func showPopUpLogin() {
           
             let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPoupUpId") as! PoupUpLoginViewController
             
             self.addChild(popOverVC)
             popOverVC.view.frame = self.view.frame
             self.view.addSubview(popOverVC.view)
             popOverVC.didMove(toParent: self)
         }
    
    func showPopUpSessao() {
        
          let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpSessaoID") as! ReiniciarSessaoViewController
          
          self.addChild(popOverVC)
          popOverVC.view.frame = self.view.frame
          self.view.addSubview(popOverVC.view)
          popOverVC.didMove(toParent: self)
      }
    
    
    func verificarSessao() {
        
          // MARK: Verificar se esta logado e salta para tela principal
            // pegar e formatar a data actual
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = format.string(from: date)
            print(formattedDate)
        // buscar o tokem na memoria do telefone
        //data de expiracao
          let dataexpiracao = UserDefaults.standard.string(forKey: "dataExpiracao")
          //formatar data de expiracao
            var dataConvertida = ""
            var converteData = date
            if dataexpiracao != nil {
                let format1 = DateFormatter()
                format1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                converteData = format1.date(from: dataexpiracao!)!
                format1.timeZone = TimeZone.current
                format1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dataConvertida = format1.string(from: converteData)
                print(dataConvertida)
                
                }
          let token1 = UserDefaults.standard.string(forKey: "token")
       
           if token1 != nil  && token1 != "convidado" && formattedDate > dataConvertida  {
            showPopUpSessao()
            print("terminou a sessao")
            }
          
    }
    
}
    
