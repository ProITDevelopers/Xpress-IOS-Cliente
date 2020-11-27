//
//  ItemCarrinhoTableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

protocol AtualizarListaCarrinhoDelegate {
    func didListarProduto()
    
   func didAvisarLimiteProduto()
  func didAtualizarTotalCarrinho()
}


class ItemCarrinhoTableViewCell: UITableViewCell {

    
     var delegate: AtualizarListaCarrinhoDelegate?
    
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var precoProduto: UILabel!
    @IBOutlet weak var descricaoProduto: UILabel!
    
    @IBOutlet weak var quantidadeProduto: UILabel!
    
    var idProduto: Int?
    var idEstabelecimento1:Int?
    var quantidade: Int = 1
    var produtoNome = ""
    var nomeEstabelecimento = ""
     var precoUnidade = 0
    var urlImagemProduto = ""
    var emStock1: Int = 0
     var observacoes: String = "Obrigado"
    var latitude = 0.0
    var longitude = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        delegate?.didListarProduto()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnRemover(_ sender: UIButton) {
        
    }
   
    @IBAction func brnSubtrair(_ sender: UIButton) {
        SubtrairProdutoCarrinho()
        
    }
    @IBAction func btnSomar(_ sender: UIButton) {
        adicionarCarrinho()
    }
    
    @IBAction func btnEliminarItem(_ sender: Any) {
        SubtrairProdutoCarrinho2()
    }
    
    
}


extension ItemCarrinhoTableViewCell {
    
    func adicionarCarrinho() {
          
                 let item = ItemsCarrinho()

                 item.itemId = "\(idEstabelecimento1!)-\(idProduto!)"
                 item.produtoId = idProduto!
                 item.quantidade = quantidade
                 item.ideStabelecimento = idEstabelecimento1!
                 item.nomeItem = produtoNome
                 item.estabelecimento = nomeEstabelecimento
                 item.precoUnitario = precoUnidade
                 item.imagemProduto = urlImagemProduto
                 item.emStock = emStock1
                 item.obseracoes = observacoes


                 do {
                     
                     let realm = try Realm()
                     let itens = realm.objects(ItemsCarrinho.self).filter("itemId == %@", item.itemId)
                     
                     if itens.isEmpty == false {
                         print(itens)
              
                      if itens[0].quantidade < itens[0].emStock {
                          item.quantidade = item.quantidade + itens[0].quantidade
                          try realm.write {
                              //realm.add(item)
                              
                              itens[0].quantidade = item.quantidade
                              print("quantidade adicionada ")
                          }
                         
                         
                           quantidadeProduto.text =   "\(item.quantidade)"
                      } else {
                        
                          delegate?.didAvisarLimiteProduto()
                      }
                         
                        
                     } else {
                         
                         
                         try realm.write {
                             
                             realm.add(item)
                             print("item adicionada ")
                             
                             if itens.count > 0 {
                                 
                                 for item in itens {
                                     
                                     print(" IdPro: \(item.produtoId) - Qtd: \(item.quantidade) - Esta: \(item.ideStabelecimento)")
                                     
                                 }
                             }
                         }
                     
                         quantidadeProduto.text =   "\(item.quantidade)"
                     }
//                     print(Realm.Configuration.defaultConfiguration.fileURL)
                 // showToast( message: "adicionado", seconds: 3)
                 } catch let error {
                     print(error)
                 }
           delegate?.didListarProduto()
         delegate?.didAtualizarTotalCarrinho()
         // delegate?.didMostrarItenCarrino()
      }
    
    
    func SubtrairProdutoCarrinho()  {
        
        
                     let item = ItemsCarrinho()

                     item.itemId = "\(idEstabelecimento1!)-\(idProduto!)"
                     item.produtoId = idProduto!
                     item.quantidade = quantidade
                     item.ideStabelecimento = idEstabelecimento1!
                     item.nomeItem = produtoNome
                     item.estabelecimento = nomeEstabelecimento
                     item.precoUnitario = precoUnidade
                     item.imagemProduto = urlImagemProduto


                     do {
                         
                         let realm = try Realm()
                         let itens = realm.objects(ItemsCarrinho.self).filter("itemId == %@", item.itemId)
                         
                         if itens.isEmpty == false {
                             print(itens)
                           
                           if itens[0].quantidade == 1 {
                               
                              
                               do {
                                   let itemresto = itens[0].quantidade - 1
                                       try realm.write {
                                           realm.delete(itens[0])
                                   
                                       }
                                   
                                   quantidadeProduto.text =   "\(itemresto)"
                                   eliminarEstabelecimento()
                                   } catch{
                                       
                                       print("Erro ao Eliminar o produto do carrinho, \(error)")
                                   }
                                    
                               
                           }
                           else {
                            let itemresto = itens[0].quantidade - 1
                               try realm.write {
                               //realm.add(item)
                                                
                               itens[0].quantidade = itemresto
                               print("quantidade adicionada ")
                             }
                           quantidadeProduto.text =   "\(itemresto)"
                           }
                             
                         }
//                         print(Realm.Configuration.defaultConfiguration.fileURL)
                         //showToast(message: "adicionado", seconds: 1)
                     } catch let error {
                         print(error)
                     }
               
               delegate?.didListarProduto()
                delegate?.didAtualizarTotalCarrinho()
            
    }
    
    
     func SubtrairProdutoCarrinho2()  {
            
            
                         let item = ItemsCarrinho()

                         item.itemId = "\(idEstabelecimento1!)-\(idProduto!)"
                         item.produtoId = idProduto!
                         item.quantidade = quantidade
                         item.ideStabelecimento = idEstabelecimento1!
                         item.nomeItem = produtoNome
                         item.estabelecimento = nomeEstabelecimento
                         item.precoUnitario = precoUnidade
                         item.imagemProduto = urlImagemProduto


                         do {
                             
                             let realm = try Realm()
                             let itens = realm.objects(ItemsCarrinho.self).filter("itemId == %@", item.itemId)
                             
                             if itens.isEmpty == false {
                                 print(itens)
                               
                             
                                   do {
                                       let itemresto = itens[0].quantidade - 1
                                           try realm.write {
                                               realm.delete(itens[0])
                                       
                                           }
                                       
                                       quantidadeProduto.text =   "\(itemresto)"
                                       eliminarEstabelecimento()
                                       } catch{
                                           
                                           print("Erro ao Eliminar o produto do carrinho, \(error)")
                                       }
                                        
                                 
                             }
    //                         print(Realm.Configuration.defaultConfiguration.fileURL)
                             //showToast(message: "adicionado", seconds: 1)
                         } catch let error {
                             print(error)
                         }
                   
                   delegate?.didListarProduto()
                    delegate?.didAtualizarTotalCarrinho()
                
        }
    
    
    
    func guardarEstabelecimento() {
              
          let item = EstabCarrinho()
          item.ideStabelecimento = idEstabelecimento1!
          item.nomeEstab = nomeEstabelecimento
        item.latitude = latitude
        item.longitude = longitude
          do {
              let realm = try Realm()
              let itens = realm.objects(EstabCarrinho.self).filter("ideStabelecimento == %@", item.ideStabelecimento)
              if itens.isEmpty == true {
                  print(itens)
                  try realm.write {
                      realm.add(item)
                      print("estabelecimento adicionada ")
                      
                  }
                  
              }
              //print(Realm.Configuration.defaultConfiguration.fileURL)
              // showToast( message: "adicionado", seconds: 3)
              
          } catch let error {
              print(error)
              
          }
          
      }
      
        func eliminarEstabelecimento()  {
         
          do {
              let realm = try Realm()
              let itens = realm.objects(ItemsCarrinho.self).filter("ideStabelecimento == %@", idEstabelecimento1!)
              let estabelecimento = realm.objects(EstabCarrinho.self).filter("ideStabelecimento == %@", idEstabelecimento1!)

              if itens.isEmpty == true {
                  print(itens)
                 
                      
                      do {
                          
                          try realm.write {
                          realm.delete(estabelecimento[0])
                          print("estabelecimento removido")
                          }
                          
                      } catch {
                          print("Erro ao Eliminar o produto do carrinho, \(error)")
                          
                      }
                      
                
                  
              }
              //print(Realm.Configuration.defaultConfiguration.fileURL)
              //showToast(message: "adicionado", seconds: 1)
              
          } catch let error {
              print(error)
              
          }
          
      }
    
}
