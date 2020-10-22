//
//  PerfilViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/25/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import RealmSwift

class PerfilViewController: UIViewController {

    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var nomeCompletoLabel: UILabel!
    @IBOutlet weak var contactosLabel: UILabel!
    @IBOutlet weak var contactoAlternativoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var generoLabel: UILabel!
    


    var perfil = [Perfil]()


    override func viewDidLoad() {
        super.viewDidLoad()

       mostrarPopUpInternet()
           //  verificarSessao()
      
      mostrarButtonEditar()
       obterPerfil()
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarButtonEditar()
        obterPerfil()
        mostrarPopUpInternet()
    }
    
    
    func mostrarButtonEditar() {
         // button
                     let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
                     rightButton.setBackgroundImage(UIImage(named: "editar"), for: .normal)
                     rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)

                    // rightButton.addSubview(label)
                     
                     // Bar button item
                     let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
                     
                     navigationItem.rightBarButtonItems  = [rightBarButtomItem]
    }
    

    @objc func rightButtonTouched() {
         print("right button touched")
            performSegue(withIdentifier: "idEditarPerfil", sender: self)
       }
       
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mostrarPerfil() {
        
       
        //var casa: String?
        let url = perfil[0].imagem
        imgPerfil.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        if url != "Sem Imagem" && url != nil {
                   imgPerfil.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               imgPerfil.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "placeholder.phg"))
               } else {
                    imgPerfil.image = UIImage(named:"fota.jpg")
               }
        
        
        nomeCompletoLabel.text = perfil[0].nomeCompleto
        
        contactosLabel.text = perfil[0].contactoMovel
        contactoAlternativoLabel.text = perfil[0].contactoAlternativo
        emailLabel.text = perfil[0].email
        
        if perfil[0].sexo == "M" {
                  generoLabel.text = ("Masculino")
               } else {
                     generoLabel.text = ("Femenino")
               }
    }

}


extension PerfilViewController {
    
    
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
                           
                                  
                                   
                            self.mostrarPerfil()
                           
                            
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
}
