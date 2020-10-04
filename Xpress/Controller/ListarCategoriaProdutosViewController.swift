//
//  ListarCategoriaProdutosViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/24/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ListarCategoriaProdutosViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchCategorias = [Categoria]()
    var estabelecimento = Estabelecimento()
    var categorias = [Categoria]()
    var searching = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func obterCategorias(idEstabelecimentoF: Int ) {
            
            let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/ListarCategoria/\(idEstabelecimentoF)"
            
            let token = UserDefaults.standard.string(forKey: "token")
                   print(token)
            let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
            
            Alamofire.request(URL, method: .get, encoding: JSONEncoding.default, headers: headrs).responseString { response in
                       
                       if response.result.isSuccess{
                           
                           let categoriaJSON = JSON(response.data!)
                           print(categoriaJSON)
                           self.categorias.removeAll()
                           
                           do {
                               let jsonDecoder = JSONDecoder()
                               self.categorias = try jsonDecoder.decode([Categoria].self, from: response.data!)
                            print(self.categorias)
                               self.tblView.reloadData()
                               
                           } catch {
                               print("erro inesperado: \(error)")
                           }
                           
                           if response.response?.statusCode == 200 {
                               print(response.response?.statusCode)
                               print("veja a lista")
                              // print(self.produtos[0].descricaoProdutoC)
                               
                               
                           } else {
                               print("Erro verifica por favor.")
                               print(response.response?.statusCode)
                               print(response.debugDescription)
                           }
                       } else {
                           print(response.result)
                       }
                   }
        
        }

}

extension ListarCategoriaProdutosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
                   
                   return searchCategorias.count
                   
               } else {
               return categorias.count
                   
               }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
              
              if searching {
                  
                cell.descricaoLabel?.text = searchCategorias[indexPath.row].descricao
                  
                  
                  cell.imgCategoria.sd_imageIndicator = SDWebImageActivityIndicator.gray
                if searchCategorias[indexPath.row].imagemcategoria == nil
                             {
                                  cell.imgCategoria.image = UIImage(named:"fota.jpg")
                             } else {
                    cell.imgCategoria.sd_setImage(with: URL(string: searchCategorias[indexPath.row].imagemcategoria ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                             }
                  
              } else {
              
              
                cell.descricaoLabel?.text = categorias[indexPath.row].descricao
              
              
              cell.imgCategoria.sd_imageIndicator = SDWebImageActivityIndicator.gray
                if categorias[indexPath.row].imagemcategoria == nil
                         {
                              cell.imgCategoria.image = UIImage(named:"fota.jpg")
                         } else {
                    cell.imgCategoria.sd_setImage(with: URL(string: categorias[indexPath.row].imagemcategoria ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                         }
                  
              }
              
              return cell
    }
    
    
}


extension ListarCategoriaProdutosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCategorias = categorias.filter({$0.descricao.prefix(searchText.count) == searchText})
               searching = true
               tblView.reloadData()
    }
}
