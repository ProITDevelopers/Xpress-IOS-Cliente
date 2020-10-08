//
//  CheckoutViewController.swift
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


class CheckoutViewController: UIViewController {
    
    
    var longitude = ""
    var latitude = ""
    var telemovel = ""
    var referencia = ""
    var tipoPagamento = ""
    var resposta = [respostaReferencia]()
    var produtoComprar = Produto()
    var tipoCompra = 0
    var estabelecimentoId = 0
    var produtoCarrinho: Results<ItemsCarrinho>!
    var intensCompra = [ItensComprar]()
    let realm = try! Realm()
   
    var itensParaComprar = [ItensComprar]()
    @IBOutlet weak var itensLabel: UILabel!
    @IBOutlet weak var totalPagarLabel: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var itemConprar = ItemsCarrinho.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mostrarPopUpInternet()
        verificarSessao()
        
        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "ItensCheckTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCheck1")
        
        tblView.register(UINib.init(nibName: "InfoPedidoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCheck2")
        //carregar o array de itens
        if produtoComprar.idProduto != nil {
            
        } else {
             getRealm()
        }
       
         itensLabel?.text = "  \(quantidadeIten()) Items"
        totalPagarLabel?.text = "Total: \(quantidadePagar())0 AKZ"
        mostrarPopUpInternet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarPopUpInternet()
    }
    
    @IBAction func buttonEnviarPedido(_ sender: UIButton) {
        chamarEnviarPedido()
    }
    
    
    func quantidadePagar() -> Double {
           var valor : Double = 0.0
        if tipoCompra == 1 {
            
            return Double(produtoComprar.precoUnid!)
            
        } else {
                for item in  produtoCarrinho {
                    valor = valor + Double(item.quantidade * item.precoUnitario)
                }
                return valor
        }
          
       }
       
       func quantidadeIten() -> Int {
           var valor : Int = 0
         
            if tipoCompra == 1 {
                    valor = 1
                    return valor
                } else {
                    valor = produtoCarrinho.count
                    return valor
                }
           
        }
    
    
    func getRealm() {
    
        produtoCarrinho = realm.objects(ItemsCarrinho.self)
         tblView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller. irSucessoId
        if segue.identifier == "irSucessoId" {
        
            let sucessoVC = segue.destination as? SucessoReferenciaViewController
            
            
                sucessoVC?.resposta = resposta
            if tipoPagamento == "Multicaixa" {
                sucessoVC?.tipoPag = 1
            }
             
            
        } 
    }


}


extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tipoCompra == 1 {
            return 2
        } else {
        return produtoCarrinho.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
        
        
        
        
        
        print(indexPath.row)
               switch indexPath.row {
               
               case 0:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "cellCheck2", for: indexPath) as! InfoPedidoTableViewCell
                          
                         
                   cell.enderecoLabel?.text = referencia
                   cell.telefoneLabel?.text = telemovel
                   cell.tipoPagamento?.text = tipoPagamento
                   return cell
                   
               default:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "cellCheck1", for: indexPath) as! ItensCheckTableViewCell
                   
                   
                   
                   if tipoCompra == 1 {
                                  // enviar na class de celula
                    cell.nomeProduto?.text = produtoComprar.descricaoProdutoC
                    cell.estabelecimentoProduto?.text = produtoComprar.estabelecimento
                    cell.precoProduto?.text = "\( produtoComprar.precoUnid!)x\( 1)"
                    
                                      
                            if  produtoComprar.imagemProduto == nil {
                                          
                                cell.imgProduto.image = UIImage(named:"fota.jpg")
                                          
                            } else {
                        
                                cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                cell.imgProduto.sd_setImage(with: URL(string:  produtoComprar.imagemProduto!), placeholderImage: UIImage(named: "placeholder.phg"))
                                }
                    
                     } else {
                                 // enviar na class de celula
                                 cell.nomeProduto?.text = produtoCarrinho[indexPath.row - 1].nomeItem
                                 cell.estabelecimentoProduto?.text = produtoCarrinho[indexPath.row - 1].estabelecimento
                                 cell.precoProduto?.text = "\( produtoCarrinho[indexPath.row - 1].precoUnitario)x\( produtoCarrinho[indexPath.row - 1].quantidade)"
                                 
                                 //cell.imgProducto =  produtoCarrinho[indexPath.row - 1].
                                         
                                  
                                 if  produtoCarrinho[indexPath.row - 1].imagemProduto == "" {
                                      
                                             cell.imgProduto.image = UIImage(named:"fota.jpg")
                                      
                                  } else {
                                      cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                      cell.imgProduto.sd_setImage(with: URL(string:  produtoCarrinho[indexPath.row - 1].imagemProduto), placeholderImage: UIImage(named: "placeholder.phg"))
                                  }
                                 }
                   
                   
                   
                return cell
               }
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
             return 200
        } else {
             return 150
        }
        
        
      }
    
    
    
}


extension CheckoutViewController  {
    
    
    
    func chamarEnviarPedido() {
          
              if tipoCompra == 1 {
                
                  do {
                              
                  //
                    print("Já pode o local de entrega ")
                    if tipoPagamento == "Referência"  {
                        enviarItensPedidosReferencia()
                                                    
                    } else {
                        enviarItensPedidosTPA()
                                                   
                    }
                    
                  } catch let error {
                        print(error)
                    
                }
                
              } else {
                
                            do {
                                    
                        //            let realm = try Realm()
                                  let produtoCarrinhoAtualizado = realm.objects(ItemsCarrinho.self)
                                    
                                    if produtoCarrinhoAtualizado.isEmpty == true {
                                        
                                      showToast(controller: self, message: "O carrinho está vazio!", seconds: 2)
                                        
                                    } else {
                                        
                                            if produtoCarrinhoAtualizado.count > 0 {
                                                
                                                for item in produtoCarrinhoAtualizado {
                                                    //print(" IdPro: \(item.produtoId) - Qtd: \(item.quantidade) - Esta: \(item.ideStabelecimento)")
                                                    var itemCompra = ItensComprar()
                                                    itemCompra.produtoId = item.produtoId
                                                    itemCompra.quantidade = item.quantidade
                                                    itemCompra.ideStabelecimento = item.ideStabelecimento
                                                  itemCompra.observacoes = item.obseracoes
                                                    
                                                    itensParaComprar.append(itemCompra)
                                                    
                                                }
                                                
                                                for item in intensCompra {
                                                    print(item)
                                                }
                                               
                                               if tipoPagamento == "Referência"  {
                                                enviarItensPedidosReferencia()
                                                
                                               }
                                               
                                               if tipoPagamento == "Multicaixa" {
                                                enviarItensPedidosTPA()
                                                
                                                }
                                                
                                        }
                                        
                                }
                                
                            } catch let error {
                                    print(error)
                                
                }
                
        }
        
    }
    
    
    
    
    
    
    
    
    // FUNÇ\AO QUE ENVIA OS ITENS A COMPRAR
        //   http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/
           func enviarItensPedidosReferencia() {
  
            
               var itensFactura: [String:Any] = [:]
               var arrayItem = [[String:Any]]()
              // mudar array para dicionario ideStabelecimento
               
               
               
               
                if tipoCompra == 1 {

                    itensFactura.updateValue(produtoComprar.idProduto!, forKey: "produtoId")
                    itensFactura.updateValue(produtoComprar.emStock!, forKey: "quantidade")
                    itensFactura.updateValue("Obrigado", forKey: "observacoes")
                    itensFactura.updateValue(estabelecimentoId, forKey: "ideStabelecimento")
                    arrayItem.append(itensFactura)
                   
                    } else  {
                    
                    
                    for i in 0..<itensParaComprar.count {
                        
                        itensFactura.updateValue(itensParaComprar[i].produtoId!, forKey: "produtoId")
                        itensFactura.updateValue(itensParaComprar[i].quantidade!, forKey: "quantidade")
                        itensFactura.updateValue(itensParaComprar[i].ideStabelecimento!, forKey: "ideStabelecimento")
                        itensFactura.updateValue(itensParaComprar[i].observacoes!, forKey: "observacoes")
                                  arrayItem.append(itensFactura)
                              }
                          }
               
              
              
               let entrega = ["longitude" : longitude, "latitude" : latitude, "pontodeReferencia": referencia, "nTelefone": telemovel]
               
               
               
               let parametros = ["localEncomenda": entrega, "itensFacturaos": arrayItem] as [String : Any]
               
                let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/FacturaReferencia"
          
              
               mostrarProgresso()
               
               let token = UserDefaults.standard.string(forKey: "token")
              // print(token)
            guard let usuario = token, usuario != "" else {
                    print(token as Any)
                    terminarProgresso()
                   showPopUpErroPedido()
                    return
                   
                }
               
               let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
          
                   //  print(parametros)
               
               Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: headrs).responseString { response in
                              
                                 // print(parametros)
                              
                              if response.result.isSuccess{
                                  
                                  do {
                                      let jsonDecoder = JSONDecoder()
                                      self.resposta = try jsonDecoder.decode([respostaReferencia].self, from: response.data!)
                                      print(self.tipoPagamento)
                                    print(self.resposta[0])
                                   
                                    if self.tipoCompra == 0 {
                                        self.limparCarrinho()
                                    }
                                    self.terminarProgresso()
                                    self.showPopUpSucessoPedido()
                                    // self.performSegue(withIdentifier: "irSucessoId", sender: self)
                                    
                                  } catch {
                                     self.terminarProgresso()
                                   
                                      print("erro inesperado: \(error)")
                                      self.showToast(controller: self, message: "Não foi possivel enviar o pedido!", seconds: 1)
                                  }
                                 
                              } else {
                                   self.terminarProgresso()
                                  self.showPopUpErroPedido()
                                  
                                print("erro inesperado2: \(response.error!)")
                              }
                          }
               

               
               

           }
    
    
    
    // FUNÇ\AO QUE ENVIA OS ITENS A COMPRAR
           
           func enviarItensPedidosTPA() {
               
               var itensFactura: [String:Any] = [:]
               var arrayItem = [[String:Any]]()
              // mudar array para dicionario ideStabelecimento
               
               if tipoCompra == 1 {
                
                    itensFactura.updateValue(produtoComprar.idProduto!, forKey: "produtoId")
                    itensFactura.updateValue(1, forKey: "quantidade")
                    itensFactura.updateValue("Obrigado", forKey: "observacoes")
                    itensFactura.updateValue(estabelecimentoId, forKey: "ideStabelecimento")
                    arrayItem.append(itensFactura)
                                 
                } else  {
                
                    for i in 0..<itensParaComprar.count {
                                      
                        itensFactura.updateValue(itensParaComprar[i].produtoId!, forKey: "produtoId")
                        itensFactura.updateValue(itensParaComprar[i].quantidade!, forKey: "quantidade")
                        itensFactura.updateValue(itensParaComprar[i].ideStabelecimento!, forKey: "ideStabelecimento")
                        itensFactura.updateValue(itensParaComprar[i].observacoes!, forKey: "observacoes")
                        arrayItem.append(itensFactura)
                        
                }
                
            }
   
              
               // fazerLogin(usuario: usuario, senha: password)
               let entrega = ["longitude" : longitude, "latitude" : latitude, "pontodeReferencia": referencia, "nTelefone": telemovel]
               
               
               
               let parametros = ["itensFacturaos": arrayItem, "localEncomenda": entrega] as [String : Any]
               let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/FacturaTpa"
               
               let jsonData = try! JSONSerialization.data(withJSONObject: parametros, options: .prettyPrinted)

               if let jsonString = String(data: jsonData, encoding: .utf8) {
                   print(jsonString)
               }
            mostrarProgresso()
             
               
               let token = UserDefaults.standard.string(forKey: "token")
                guard let usuario = token, usuario != "" else {
                    print(token as Any)
                    terminarProgresso()
                    showPopUpErroPedido()
                    return
                                  
                }
              // print(token)
               
               let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
               
               Alamofire.request(URL, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: headrs).responseString { response in
                   
                   print(parametros)
                   
                   if response.result.isSuccess{
                       
                       do {
                        _ = JSONDecoder()
                           
                          if self.tipoCompra == 0 {
                               self.limparCarrinho()
                           }
                       self.terminarProgresso()
                       self.showPopUpSucessoPedido()
                        print(response.response?.statusCode ?? "")
                
                       } catch {
                        print(response.response?.statusCode ?? "")
                           print("erro inesperado: \(error)")
                          self.terminarProgresso()
                           self.showToast(controller: self, message: "Não foi possivel enviar o pedido!", seconds: 1)
                       }
                       
                      
                   } else {
                         self.terminarProgresso()
                    self.showPopUpErroPedido()
                    print(response.response?.statusCode ?? "")
                       //let erro: JSON = JSON(response.result.value!)
                       print("erro inesperado2: \(response.error!)")
                   }
               }
               
               
           }
           
       
}


extension CheckoutViewController {
    
    func showPopUpSucessoPedido() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sucessoReferenciaId") as! SucessoReferenciaViewController
        
        self.addChild(popOverVC)
        if tipoPagamento == "Referência" {
             popOverVC.resposta = resposta
        }
       
        if tipoPagamento == "Multicaixa" {
            popOverVC.tipoPag = 1
        }
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    
    func showPopUpErroPedido() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "erroPedidoId") as! PopupErroPedidoViewController
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    
    
}
