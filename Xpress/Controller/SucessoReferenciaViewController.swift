//
//  SucessoReferenciaViewController.swift
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

class SucessoReferenciaViewController: UIViewController {
    
   
    
    @IBOutlet weak var referenciaLabel: UILabel!
    @IBOutlet weak var entidadeLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    var resposta1 = [[respostaReferencia]]()
    var resposta = [respostaReferencia]()
    var tipoPag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        if tipoPag == 0 {
        referenciaLabel.text =  "Referência: \(resposta[0].codigo!)"
        entidadeLabel.text = "Entidade: \(resposta[0].entidade!)"
        valorLabel.text = "Valor: \(resposta[0].valor)0 akz"
        } else {
            referenciaLabel.isHidden = true
            entidadeLabel.isHidden = true
            valorLabel.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 
            self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonFechar(_ sender: UIButton) {
       self.navigationController?.popToRootViewController(animated: true)
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
