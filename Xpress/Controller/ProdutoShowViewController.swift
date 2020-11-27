//
//  ProdutoShowViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class ProdutoShowViewController: UIViewController {
    
    
    var produto = Produto()
    var estabelecimentoId = 0
    var nomeEstabelecimento = ""
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var precoProduto: UILabel!
    @IBOutlet weak var descricaoProduto: UILabel!
    
    var label = UILabel()
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if VerificarInternet.Connection() {
             
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
            
        print(produto)
        // Do any additional setup after loading the view.
        
        
        tblView.register(UINib.init(nibName: "ShowProdutoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellShowDetalhe1")
        tblView.register(UINib.init(nibName: "ShowDetalheProdutoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellShowDetalhe2")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblView.reloadData()
        if VerificarInternet.Connection() {
             
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
       
    }
    
   func saltarCarrinho() {
       
       let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.carrinho) as! CarrinhoViewController
            self.navigationController?.pushViewController(carrinhoVC, animated: true)
   
              
   }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "irMapa2" {
            let mapaVC = segue.destination as? MapaLocalEntregaViewController
            mapaVC?.produtoCompra = produto
            mapaVC?.estabelecimentoId = estabelecimentoId
        }
    }
    
    @IBAction func buttonAdicionar(_ sender: UIButton) {
        adicionarCarrinho(produto: produto, idEstab: estabelecimentoId)    }
  
}


extension ProdutoShowViewController {
    
    func buttonComprarAgora() {
          performSegue(withIdentifier: "irMapa2", sender: self)
    }
    
    
    
    func irCarrinho() {
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.carrinho) as! CarrinhoViewController
        self.navigationController?.pushViewController(carrinhoVC, animated: true)
    }
    
    
    
    
    
    func adicionarCarrinho(produto: Produto, idEstab: Int) {
             
            let item = ItemsCarrinho()

            item.itemId = "\(idEstab)-\(produto.idProduto!)"
            item.produtoId = produto.idProduto!
            item.quantidade = 1
            item.ideStabelecimento = idEstab
            item.nomeItem = produto.descricaoProdutoC!
            item.estabelecimento = produto.estabelecimento!
            item.precoUnitario = produto.precoUnid!
            item.imagemProduto = produto.imagemProduto!
            item.emStock = produto.emStock!
            item.obseracoes = "Obrigado"


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
                           
                            showToast1(controller: self, message: "Quantidade adicionada.", seconds: 3)
                              
                         } else {
                           
                             showToast(controller: self, message: "Já atingiu o limite do produto para o pedido.", seconds: 3)
                         }
                            
                           
                        } else {
                            
                            
                            try realm.write {
                                
                                realm.add(item)
                                print("item adicionada ")
                                showToast1(controller: self, message: "Item adicionado.", seconds: 1)
                                if itens.count > 0 {
                                    
                                    for item in itens {
                                        
                                        print(" IdPro: \(item.produtoId) - Qtd: \(item.quantidade) - Esta: \(item.ideStabelecimento)")
                                        
                                    }
                                }
                            }
                        
                          
                        }
//                        print(Realm.Configuration.defaultConfiguration.fileURL)
                    // showToast( message: "adicionado", seconds: 3)
                    } catch let error {
                        print(error)
                    }
            
         }
    
    func eliminarEstabelecimento()  {
                 
             let item = EstabCarrinho()
              item.ideStabelecimento = estabelecimentoId
             item.nomeEstab = nomeEstabelecimento
             item.latitude = 0.0
             item.longitude = 0.0
             do {
                 let realm = try Realm()
                 let itens = realm.objects(ItemsCarrinho.self).filter("ideStabelecimento == %@", item.ideStabelecimento)
                 let estabelecimento = realm.objects(EstabCarrinho.self).filter("ideStabelecimento == %@", item.ideStabelecimento)

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



extension ProdutoShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         switch indexPath.row {
               case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellShowDetalhe1", for: indexPath) as! ShowProdutoTableViewCell
                    
                    label = UILabel(frame: CGRect(x: 15, y: -5, width: 25, height: 25))
                     label.layer.borderColor = UIColor.clear.cgColor
                     label.layer.borderWidth = 2
                     label.layer.cornerRadius = label.bounds.size.height / 2
                     label.textAlignment = .center
                     label.layer.masksToBounds = true
                     label.font = UIFont(name: "SanFranciscoText-Light", size: 5)
                     label.textColor = .white
                     label.backgroundColor = UIColor(red:52.0/255.0, green: 183.0/255.0, blue: 89.0/255.0, alpha: 1.0)
                     //label.text = "80"
                     contarItem(label: label)
                  
                        cell.btnCarrinho.addSubview(label)
                   
                   let url = produto.imagemProduto
                    if url != "Sem Imagem" && url != nil {
                        cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.gray
                         cell.imgProduto.sd_setImage(with: URL(string: url ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                      } else {
                            cell.imgProduto.image = UIImage(named:"fota.jpg")
                        }
                    cell.nomeEstabelecimentoLabel.text = nomeEstabelecimento
                   
                    cell.delegate = self
                    
                    
                    
                   return cell
               default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellShowDetalhe2", for: indexPath) as! ShowDetalheProdutoTableViewCell
       
                    
                    if mostrarQtdIten(idItem: produto.idProduto!) == 0 {
                        cell.staButton.isHidden = true
                        
                         cell.btnAdicionar2.backgroundColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0)
                       
                    } else {
                         cell.staButton.isHidden = false
                       
                        cell.btnAdicionar2.backgroundColor = UIColor(red: 196.0/255.0, green: 205.0/255.0, blue: 209.0/255.0, alpha: 1.0)
                        
                    }
                    
                    cell.delegate = self
                    cell.nomeProdutoLabel.text = produto.descricaoProdutoC
                    cell.precoLabel.text = "\(produto.precoUnid!).00 AKZ"
                    cell.descricaoLabel.text = produto.descricaoProduto
                    cell.qtdLabel.text = "\(mostrarQtdIten(idItem: produto.idProduto!))"
                    //enviar o produdo a celula
                    cell.idProduto = produto.idProduto
                    cell.idEstabelecimento = estabelecimentoId
                   cell.produtoNome = produto.descricaoProdutoC!
                    cell.nomeEstabelecimento = nomeEstabelecimento
                    cell.precoUnidade = produto.precoUnid!
                    cell.urlImagemProduto = produto.imagemProduto!
                    cell.emStock1 = produto.emStock!
                    cell.observacoes = "Obrigado"
                    cell.longitude = 0.0
                    cell.latitude = 0.0
                    
                return cell
               }
    }
    
    
}


extension ProdutoShowViewController: AtualizarProdutoShowDelegate {
    func didComprarAgora() {
       irCarrinho()
    }
    
    func mostrarItensCarrinho() {
        tblView.reloadData()
    }
    
    func didAvisarLimiteProduto() {
        showToast(controller: self, message: "Já atingiu o limite do  produto para o pedido..", seconds: 3)
    }
    
   
    
    
}



extension ProdutoShowViewController: IrCarrinhoDelegate {
    func didVerCarrino() {
        irCarrinho()
    }
    
    
    
   
    
    
}
    
    

extension ProdutoShowViewController {
    
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

