//
//  ShowDetalheProdutoTableViewCell.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/4/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import RealmSwift
protocol AtualizarProdutoShowDelegate {
    func mostrarItensCarrinho()
    func didAvisarLimiteProduto()
    func didComprarAgora()
    
}

class ShowDetalheProdutoTableViewCell: UITableViewCell {
    
     var delegate: AtualizarProdutoShowDelegate?
    
    @IBOutlet weak var nomeProdutoLabel: UILabel!
    @IBOutlet weak var precoLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var qtdLabel: UILabel!
    @IBOutlet weak var btnsubtrair: UIButton!
    @IBOutlet weak var btnAdicionar: UIButton!
    @IBOutlet weak var btnAdicionar2: CustumizarBtnCurto!
    @IBOutlet weak var staButton: UIStackView!
    
      var idProduto: Int?
      var idEstabelecimento:Int?
      var quantidade = 1
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonSubtrair(_ sender: UIButton) {
        SubtrairProdutoCarrinho()
         
        
    }
    
    @IBAction func buttonAdicionar(_ sender: UIButton) {
        adicionarCarrinho()
            //delegate?.mostrarItensCarrinho()
    }
    
    @IBAction func buttonadicionar2(_ sender: UIButton) {
        
        if mostrarQtdIten(idItem: idProduto!) == 0 {
            adicionarCarrinho()
            staButton.isHidden = false
            delegate?.mostrarItensCarrinho()
            btnAdicionar2.titleLabel?.text = "Adicionado"
            btnAdicionar2.backgroundColor = UIColor(red: 196.0/255.0, green: 205.0/255.0, blue: 209.0/255.0, alpha: 1.0)
        }
        
    }
    @IBAction func buttonComprar(_ sender: UIButton) {
          adicionarCarrinho()
        delegate?.didComprarAgora()
    }
    
    
    
    
    
}



extension ShowDetalheProdutoTableViewCell {
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
                             staButton.isHidden = false
                            itens[0].quantidade = item.quantidade
                            print("quantidade adicionada ")
                        }
                       
                       
                         qtdLabel.text = "\(mostrarQtdIten(idItem: idProduto!))"
                    } else {
                      
                        delegate?.didAvisarLimiteProduto()
                    }
                       
                      
                   } else {
                       
                       
                       try realm.write {
                           
                           realm.add(item)
                           print("item adicionada ")
                            staButton.isHidden = false
                           if itens.count > 0 {
                               
                               for item in itens {
                                   
                                   print(" IdPro: \(item.produtoId) - Qtd: \(item.quantidade) - Esta: \(item.ideStabelecimento)")
                                   
                               }
                           }
                       }
                   
                    qtdLabel.text = "\(mostrarQtdIten(idItem: idProduto!))"
                   }
//                   print(Realm.Configuration.defaultConfiguration.fileURL)
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
                                _ = itens[0].quantidade - 1
                                       try realm.write {
                                           realm.delete(itens[0])
                                   
                                       }
                                btnAdicionar2.backgroundColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0)
                                staButton.isHidden = true
                                   qtdLabel.text = "\(mostrarQtdIten(idItem: idProduto!))"
                                   
                                   } catch{
                                       
                                       print("Erro ao Eliminar o produto do carrinho, \(error)")
                                   }
                                    
                                delegate?.mostrarItensCarrinho()
                           }
                           else {
                            let itemresto = itens[0].quantidade - 1
                               try realm.write {
                               //realm.add(item)
                                          btnAdicionar2.backgroundColor =  UIColor(red: 196.0/255.0, green: 205.0/255.0, blue: 209.0/255.0, alpha: 1.0)
                                staButton.isHidden = false
                               itens[0].quantidade = itemresto
                               print("quantidade adicionada ")
                             }
                            qtdLabel.text = " \(mostrarQtdIten(idItem: idProduto!))"
                            
                           }
                             
                         }
//                         print(Realm.Configuration.defaultConfiguration.fileURL)
                         //showToast(message: "adicionado", seconds: 1)
                     } catch let error {
                         print(error)
                     }
               
             
           
    }
    
   
}

extension ShowDetalheProdutoTableViewCell {
    
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
