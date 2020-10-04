//
//  SairPopUpViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/30/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import RealmSwift

class SairPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func buttonSim(_ sender: UIButton) {
         self.view.removeFromSuperview()
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
         UserDefaults.standard.removeObject(forKey: "token")
         UserDefaults.standard.removeObject(forKey: "nomeCompleto")
         UserDefaults.standard.removeObject(forKey: "emailUsuario")
        TransitarParaTelaLogin()
       
    }
    
    @IBAction func buttonNao(_ sender: UIButton) {
         self.view.removeFromSuperview()
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
