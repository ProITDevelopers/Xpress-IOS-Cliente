//
//  TableViewLoginViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/30/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit

class TableViewLoginViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var opcoes  = ["Entrar ou Registar"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "cellLogin")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showPopUpTelaLoguin() {
              let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPoupUpId") as! PoupUpLoginViewController
              
              self.addChild(popOverVC)
              popOverVC.telaOrigem = 2
              popOverVC.view.frame = self.view.frame
              self.view.addSubview(popOverVC.view)
              popOverVC.didMove(toParent: self)
          }
}

extension TableViewLoginViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opcoes.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cellLogin", for: indexPath) as! LoginTableViewCell

               
               let text = opcoes[indexPath.row]
                   cell.detalheLabel.text = text
         cell.imgDetalhe.image =  UIImage(named:"sair.png.png")
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
              return UITableView.automaticDimension
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         if  indexPath.row == 0 {
                 showPopUpTelaLoguin()

             }
        
         
     }
}
