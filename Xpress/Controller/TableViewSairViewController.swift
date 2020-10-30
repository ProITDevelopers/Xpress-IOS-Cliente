//
//  TableViewSairViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/30/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class TableViewSairViewController: UIViewController {
    
    var opcoes  = ["Ver perfil","Redifinir palavra-passe", "Sair"]
 
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

         tblView.register(UINib.init(nibName: "Sair2TableViewCell", bundle: nil), forCellReuseIdentifier: "cellSair2")
//
        // Do any additional setup after loading the view.
    }
    
    func showPopUpSair() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpSairId") as! SairPopUpViewController
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func RecuperarSenha() {
        
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recuperarSenhaId") as! RecuperarSenhaViewController
                       self.navigationController?.pushViewController(carrinhoVC, animated: true)
                 
         
    }
    func SaltarPerfil() {
        
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerfilID") as! PerfilViewController
        self.navigationController?.pushViewController(carrinhoVC, animated: true)
                 
         
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

extension TableViewSairViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opcoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cellSair2", for: indexPath) as! Sair2TableViewCell

               
               let text = opcoes[indexPath.row]
                   cell.detalheLabel.text = text
        
        if indexPath.row == 0 {
            cell.imgDetalhe.image =  UIImage(named:"perfil.png")
        }
                if indexPath.row == 1 {
                    cell.imgDetalhe.image =  UIImage(named:"icons8-forgot-password-30.png")
                           
                       }
        if indexPath.row == 2 {
                   cell.imgDetalhe.image =  UIImage(named:"sair.png.png")
               }
                 
               return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
              return UITableView.automaticDimension
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  indexPath.row == 0 {
                SaltarPerfil()

            }
        if  indexPath.row == 1 {
            RecuperarSenha()
        }
        if  indexPath.row == 2 {
                  showPopUpSair()
               }
        
    }
    
}
