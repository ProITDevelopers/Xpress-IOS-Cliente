//
//  DefinicaoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import SDWebImage

class DefinicaoViewController: UIViewController {
    
      var perfil = [Perfil]()
      var estado = ""
       var token = UserDefaults.standard.string(forKey: "token")
      let nomeUser = "Joao"//UserDefaults.standard.string(forKey: "nomeCompleto")
      let emailUser = UserDefaults.standard.string(forKey: "emailUsuario")
     var data  = [["Opções de Perfil"], ["Express Lengueno é um serviço de delivery que permite o usuário realizar os seus pedidos preferidos."], ["1.2"], ["Copyright © 2020 - HXA, Powered by Pro-IT Consulting"], ["Tem alguma dúvida? Estamos felizes em ajudar."] , ["Partilhe a nossa app com os seus amigos."]]
    
     
      let headerTitles  = ["Perifl e Segurança","Sobre Nós","Versão","Desenvolvedor","Enviar feedback","Partilhar"]

   
    
    @IBOutlet weak var tblView: UITableView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        token = UserDefaults.standard.string(forKey: "token")
//
//        tblView.register(UINib.init(nibName: "SairTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSair")
//               tblView.register(UINib.init(nibName: "DefinicaoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellDefinicao")
//        // Do any additional setup after loading the view.
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        mostrarPopUpInternet()
        
        tblView.register(UINib.init(nibName: "SairTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSair")
        tblView.register(UINib.init(nibName: "DefinicaoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellDefinicao")
        tblView.reloadData()
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



extension DefinicaoViewController: UITableViewDataSource, UITableViewDelegate {


func numberOfSections(in tableView: UITableView) -> Int {
    
   
         return data.count
   

}

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section < headerTitles.count {
        
        
        return headerTitles[section]
    }

    return nil
}



func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
   
   
           return  data[section].count
    
   
}
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           if let header = view as? UITableViewHeaderFooterView {
               header.backgroundView?.backgroundColor = UIColor.white
               header.textLabel?.textColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0)
           }
       }

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
          return UITableView.automaticDimension
   
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 && indexPath.row == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSair", for: indexPath) as! SairTableViewCell

        
                  let text = data[indexPath.section][indexPath.row]
            cell.detalheLabel.text = text
                   cell.imgDetalhe.image =  UIImage(named:"perfil.png")
          
        return cell
        
    } else
        
        if indexPath.section == 0 && indexPath.row == 1 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cellSair", for: indexPath) as! SairTableViewCell

           
                 let text = data[indexPath.section][indexPath.row]
                     
                  cell.detalheLabel.text = text
                     cell.imgDetalhe.image =  UIImage(named:"sair.png")
            return cell
           } else {
  
     let cell = tableView.dequeueReusableCell(withIdentifier: "cellDefinicao", for: indexPath) as! DefinicaoTableViewCell

            let text = data[indexPath.section][indexPath.row]
                 cell.detalhesLabel1.text = text
                
          
            return cell
    }
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
             token = UserDefaults.standard.string(forKey: "token")
            if token!.isEmpty {
                 saltarTableLogin()
                 
            } else {

                saltarTableSair()
               
                //performSegue(withIdentifier: "perfilID", sender: nil)
               
              
            }
            
        }

        
    }
    
    
    
    
    
    
    func saltarTableSair() {
        
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableSairID") as! TableViewSairViewController
             self.navigationController?.pushViewController(carrinhoVC, animated: true)
    
               
    }
    
    func saltarTableLogin() {
        
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableLoginID") as! TableViewLoginViewController
             self.navigationController?.pushViewController(carrinhoVC, animated: true)
    
               
    }
}
