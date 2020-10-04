//
//  MenuViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/19/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuViewController: UIViewController{
    
   
    
    @IBOutlet weak var categoriaColectionView: UICollectionView!
    @IBOutlet weak var menuCollectionView1: UICollectionView!
    @IBOutlet weak var menuCollectionView2: UICollectionView!
    
     var estabelecimentos = [Estabelecimento]()
    
    var dados = ["1"]
    
    let token = UserDefaults.standard.string(forKey: "token")
   
    override func viewDidLoad() {
        super.viewDidLoad()

        obterEstabelecimentos()
        print(estabelecimentos)
       
        categoriaColectionView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtoVerTudo1(_ sender: UIButton) {
        print("ve 1")
        performSegue(withIdentifier: "irEstabelecimentos", sender: self)
    }
    
    @IBAction func ButtonVerTudo2(_ sender: Any) {
           print("ve 2")
        performSegue(withIdentifier: "irEstabelecimentos", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func obterEstabelecimentos() {
             
           let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/ListarEstabPorTipo/1"
        
            let headrs: HTTPHeaders = ["Accept": "application/json", "Content-Type" : "application/json"]
             
             Alamofire.request(URL, method: .get, encoding: JSONEncoding.default, headers: headrs).responseString { response in
                   
                   if response.result.isSuccess{

                       do {
                        
                         
                          let estacionamentoJSON = JSON(response.data!)
                           let jsonDecoder = JSONDecoder()
                        self.estabelecimentos = try jsonDecoder.decode([Estabelecimento].self, from: response.data!)
                        
                        
                        self.menuCollectionView1.reloadData()
                        self.menuCollectionView2.reloadData()
                       } catch {
                           print("erro inesperado: \(error)")
                       }
                     
                   } else {
                     print("Erro verifica por favor.")
                     print(response.response?.statusCode as Any)
                     print(response.debugDescription)
                       print(response.result)
                   }
               }
            
             

             
         }
}


    
 extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
           if collectionView == categoriaColectionView {
            
               return 10
            
           } else if collectionView == menuCollectionView1 {
            
            return estabelecimentos.count
            
           } else {
            
            return estabelecimentos.count
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           
           
           
           if collectionView == categoriaColectionView {
                     let cell = categoriaColectionView.dequeueReusableCell(withReuseIdentifier: "categoria", for: indexPath) as? categoriaCollectionViewCell
            
                      cell?.nomeCategoria.text = String(indexPath.row)
                      
                      return cell!
                  } else if collectionView == menuCollectionView1 {
            
                     let cell = menuCollectionView1.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? Estabelecimento1CollectionViewCell
              
           

            cell!.logoEsta.sd_setImage(with: URL(string: estabelecimentos[indexPath.row].logotipo ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                      
                      return cell!
            
                  } else {
            
                      let cell = menuCollectionView2.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? Estabelecimento2CollectionViewCell
            
           
            
             cell!.imgLogo2.sd_setImage(with: URL(string: estabelecimentos[indexPath.row].logotipo ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                      
                      return cell!
                  }
           
           
       }
       
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "irEstabelecimentos", sender: self)
    }
       
   }

