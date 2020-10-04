//
//  ProdutoTableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/24/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import RealmSwift

protocol AtualizarListaProdutosDelegate {
    func didListarProduto()
    
    func mostrarBtnCarrinho()
  func didAvisarLimiteProduto()
}


class ProdutoTableViewCell: UITableViewCell {

  var delegate: AtualizarListaProdutosDelegate?
    
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var descricaoProduto: UILabel!
    @IBOutlet weak var precoProduto: UILabel!
    @IBOutlet weak var qtdProduto: UILabel!
    @IBOutlet weak var menosProduto: UIButton!
    @IBOutlet weak var maisProduto: UIButton!
    @IBOutlet weak var carrinhoAddProduto: UIButton!
    
    @IBOutlet weak var stackViewButton: UIStackView!
    var idProduto: Int?
    var idEstabelecimento:Int?
    var quantidade: Int = 1
    var produtoNome = ""
    var nomeEstabelecimento = ""
     var precoUnidade = 0
    var urlImagemProduto = ""
    var emStock1: Int = 0
    var observacoes: String = "Obrigado"
    var produtoCarrinho: Results<ItemsCarrinho>!
    
    var NoCarrinhoquantidade: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        delegate?.didListarProduto()
        
        
                   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //verificar se esta no carrinho
        
              
    }
    
    
    @IBAction func ButtonAddCarrinho(_ sender: UIButton) {
        print("Carrinho")
        adicionarCarrinho()
        carrinhoAddProduto.isHidden = true
        stackViewButton.isHidden = false
          delegate?.didListarProduto()
    }
    
    @IBAction func ButtonMaisProduto(_ sender: UIButton) {
        print("Mais")
          adicionarCarrinho()
        carrinhoAddProduto.isHidden = true
        stackViewButton.isHidden = false
         delegate?.didListarProduto()
    }
    
    @IBAction func ButtonMenosProduto(_ sender: UIButton) {
        print("Menus")
        SubtrairProdutoCarrinho()
        delegate?.didListarProduto()
    }
    
}

extension ProdutoTableViewCell {
    
    func adicionarCarrinho() {
        
               let item = ItemsCarrinho()

               item.itemId = "\(idEstabelecimento!)-\(idProduto!)"
               item.produtoId = idProduto!
               item.quantidade = quantidade
               item.ideStabelecimento = idEstabelecimento!
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
                       
                       
                         qtdProduto.text =   "\(item.quantidade)"
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
                   
                       qtdProduto.text =   "\(item.quantidade)"
                   }
                   print(Realm.Configuration.defaultConfiguration.fileURL)
               // showToast( message: "adicionado", seconds: 3)
               } catch let error {
                   print(error)
               }
      
    }
    
    func SubtrairProdutoCarrinho()  {
        
        
                     let item = ItemsCarrinho()

                     item.itemId = "\(idEstabelecimento!)-\(idProduto!)"
                     item.produtoId = idProduto!
                     item.quantidade = quantidade
                     item.ideStabelecimento = idEstabelecimento!
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
                                    delegate?.didListarProduto()
                                       }
                                   carrinhoAddProduto.isHidden = false
                                   stackViewButton.isHidden = true
                                   qtdProduto.text =   "\(itemresto)"
                                    
                                
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
                           qtdProduto.text =   "\(itemresto)"
                           }
                             
                         }
                         print(Realm.Configuration.defaultConfiguration.fileURL)
                         //showToast(message: "adicionado", seconds: 1)
                     } catch let error {
                         print(error)
                     }
               
             
           
    }
    
   
}

extension ProdutoTableViewCell {
    
    func mostrarQtdIten(idItem: Int) -> Int {
                  var retorno = 0
     
           
           
                  do {
       
                       let realm = try Realm()
                       let itens = realm.objects(ItemsCarrinho.self).filter("produtoId == %@", idItem)
           
                       
                       
                   if itens.isEmpty {
                       retorno = 0
                   } else{
                       retorno =  itens[0].quantidade
                   }
           
           
               } catch let error {
                      print(error)
                  }
           
                  return retorno
               }
}
