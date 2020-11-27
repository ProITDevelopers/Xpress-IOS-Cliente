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
    
   
    var longitude = 0.0
    var latitude = 0.0
    var telemovel = ""
    var referencia = ""
    var tipoPagamento = ""
     var resposta1 = [[respostaReferencia]]()
    var resposta = [respostaReferencia]()
    var produtoComprar = Produto()
    var tipoCompra = 0
    var estabelecimentoId = 0
    var indici = 0
    var realm = try! Realm()
    var produtoCarrinho: Results<ItemsCarrinho>!
    var estabelecimentoCarrinho: Results<EstabCarrinho>!
    var intensCompra = [ItensComprar]()
    var arrayCalcularTaxa = [CalculoTaxa]()
    var arrayTaxaCalculada = [TaxaCalculada]()
   
   
    var itensParaComprar = [ItensComprar]()
    @IBOutlet weak var itensLabel: UILabel!
    @IBOutlet weak var totalPagarLabel: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var itemConprar = ItemsCarrinho.self
     var arrayEstabelecimento = [EstabCarrinho]()
    var arrayEstabelecimento1 = [String]()
    var arrayProdutos = [[ItemsCarrinho]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         //desdobrarEstabelecimento()
        //CalcularTaxa()
      estabelecimentoCarrinho = realm.objects(EstabCarrinho.self)
      
      preencherTodosArray()
     //  quantidadePagarPorEstab()
        
        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "ItensCheckTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCheck1")
        tblView.register(UINib.init(nibName: "InfoPedidoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCheck2")
        tblView.register(UINib.init(nibName: "DetalheEstabTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCheck3")
        //carregar o array de itens
        if produtoComprar.idProduto != nil {
            
        } else {
             getRealm()
        }

         itensLabel?.text = "  \(quantidadeIten()) Items"
        totalPagarLabel?.text = "Total: \(quantidadePagar() + quantidadePagarTaxa() )0 AKZ"
        //mostrarDetalhes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if VerificarInternet.Connection() {
             
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
    }
    
    @IBAction func buttonInfo(_ sender: UIButton) {
       
    }
    
    func mostrarDetalhes() {
         let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "infoDetalheId") as! DetalhePedidoViewController
               self.addChild(popOverVC)
               popOverVC.endereco = referencia
               popOverVC.telefone = telemovel
               popOverVC.tipoPagamento = tipoPagamento
               popOverVC.view.frame = self.view.frame
               self.view.addSubview(popOverVC.view)
               popOverVC.didMove(toParent: self)
    }
    
    
    @IBAction func buttonEnviarPedido(_ sender: UIButton) {
        if VerificarInternet.Connection() {
              verificaToken()
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
      
    }
    
    func verificaToken(){
      let token = UserDefaults.standard.string(forKey: "token")
        if token!.isEmpty {
         
            self.showPopUpTelaLoguin()
         
        } else {
            
               chamarEnviarPedido()
            
        }
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
    func quantidadePagarEstab(idEstab: Int) -> Double {
        var valor : Double = 0.0
           for item in  produtoCarrinho {
                
                if item.ideStabelecimento == idEstab {
                 valor = valor + Double(item.quantidade * item.precoUnitario)
                }
             }
             return valor
        
        }
    
    
    func quantidadePagarTaxa() -> Double {
        var valor : Double = 0.0
     
             for item in  estabelecimentoCarrinho {
                valor = valor + item.taxaEntrega
             }
             return valor
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayEstabelecimento1.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         if section < arrayEstabelecimento1.count {
          
            return arrayEstabelecimento1[section]
            
        }

               return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           if let header = view as? UITableViewHeaderFooterView {
               header.backgroundView?.backgroundColor = UIColor.white
               header.textLabel?.textColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0)
           }
       }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        if section == 0 {
            return 1
        } else {
            return arrayProdutos[section - 1].count + 1
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellCheck2", for: indexPath) as! InfoPedidoTableViewCell


                              cell.enderecoLabel?.text = referencia
                              cell.telefoneLabel?.text = telemovel
                              cell.tipoPagamento?.text = tipoPagamento
                              return cell
            default :
            
            let indici = arrayProdutos[indexPath.section - 1].count + 1
        if (indexPath.row + 1)  == indici {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCheck3", for: indexPath) as! DetalheEstabTableViewCell

            let estab = estabelecimentoCarrinho[indexPath.section - 1]

            let valor = quantidadePagarEstab(idEstab: estab.ideStabelecimento)
                        cell.valorTaxaLabel?.text = ("\(estab.taxaEntrega)0 AKZ")
                        cell.valorItemLabel?.text = ("\(valor)0 AKZ")
                        let total = String(estab.taxaEntrega + valor)
                        cell.totalLabel?.text = "\(total)0 AKZ"
                        return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCheck1", for: indexPath) as! ItensCheckTableViewCell
            cell.nomeProduto?.text = ("\(arrayProdutos[indexPath.section - 1][indexPath.row].nomeItem)")
            cell.estabelecimentoProduto?.text = ("\(arrayProdutos[indexPath.section - 1][indexPath.row].estabelecimento)")
            cell.precoProduto?.text = ("\(arrayProdutos[indexPath.section - 1][indexPath.row].precoUnitario).00 AKZ x \(arrayProdutos[indexPath.section - 1][indexPath.row].quantidade)")
            //cell.imgProducto =  produtoCarrinho[indexPath.row].
            if  arrayProdutos[indexPath.section - 1][indexPath.row].imagemProduto == "" {
                cell.imgProduto.image = UIImage(named:"fota.jpg")
                
            } else {
                cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgProduto.sd_setImage(with: URL(string:  arrayProdutos[indexPath.section - 1][indexPath.row].imagemProduto), placeholderImage: UIImage(named: "placeholder.phg"))
                
            }
         
            return cell
            
            }
            
       }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
             return 200
        } else {
            
        return UITableView.automaticDimension
            
        }
    }
    
    
    
}


extension CheckoutViewController  {
    
    
    
    func chamarEnviarPedido() {
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
                        itemCompra.taxaEntrega = item.taxaEntrega1
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
    
    
    
    
    // FUNÇ\AO QUE ENVIA OS ITENS A COMPRAR
        //  https://apivendas.xpressentregas.com
           func enviarItensPedidosReferencia() {
  
            
               var itensFactura: [String:Any] = [:]
                             var arrayItem = [[String:Any]]()
                            // mudar array para dicionario ideStabelecimento
                          
                              
                                  for i in 0..<itensParaComprar.count {
                                                    
                                      itensFactura.updateValue(itensParaComprar[i].produtoId!, forKey: "produtoId")
                                      itensFactura.updateValue(itensParaComprar[i].quantidade!, forKey: "quantidade")
                                      itensFactura.updateValue(itensParaComprar[i].ideStabelecimento!, forKey: "ideStabelecimento")
                                      itensFactura.updateValue(itensParaComprar[i].observacoes!, forKey: "observacoes")
                                       itensFactura.updateValue(itensParaComprar[i].taxaEntrega!, forKey: "taxaEntrega")
                                      arrayItem.append(itensFactura)
                                      
                              }
                          // fazerLogin(usuario: usuario, senha: password)
                             let entrega = ["longitude" : String(longitude), "latitude" : String(latitude), "pontodeReferencia": referencia, "nTelefone": telemovel]
                             
                             
                             
                             let parametros = ["itensFacturaos": arrayItem, "localEncomenda": entrega] as [String : Any]
               
                let URL = "\(linkPrincipal.urlLink)/FacturaReferencia"
          
              
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
                                      self.resposta1 = try jsonDecoder.decode([[respostaReferencia]].self, from: response.data!)
                                      print(self.tipoPagamento)
                                    self.resposta = self.resposta1[0]
                                    print(self.resposta[0])
                                   
                                    if self.tipoCompra == 0 {
                                        self.limparCarrinho()
                                    }
                                    self.terminarProgresso()
                                    self.showPopUpSucessoPedido()
                                    // self.performSegue(withIdentifier: "irSucessoId", sender: self)
                                    
                                  } catch {
                                     self.terminarProgresso()
                                    print(response.response?.statusCode)
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
            
                
                    for i in 0..<itensParaComprar.count {
                                      
                        itensFactura.updateValue(itensParaComprar[i].produtoId!, forKey: "produtoId")
                        itensFactura.updateValue(itensParaComprar[i].quantidade!, forKey: "quantidade")
                        itensFactura.updateValue(itensParaComprar[i].ideStabelecimento!, forKey: "ideStabelecimento")
                        itensFactura.updateValue(itensParaComprar[i].observacoes!, forKey: "observacoes")
                         itensFactura.updateValue(itensParaComprar[i].taxaEntrega!, forKey: "taxaEntrega")
                        arrayItem.append(itensFactura)
                        
                }
            // fazerLogin(usuario: usuario, senha: password)
               let entrega = ["longitude" : String(longitude), "latitude" : String(latitude), "pontodeReferencia": referencia, "nTelefone": telemovel]
               
               
               
               let parametros = ["itensFacturaos": arrayItem, "localEncomenda": entrega] as [String : Any]
               let URL = "\(linkPrincipal.urlLink)/FacturaTpa"
               
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
    
    func showPopUpTelaLoguin() {
              let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPoupUpId") as! PoupUpLoginViewController
                        
                        self.addChild(popOverVC)
                        popOverVC.telaOrigem = 5
                        popOverVC.view.frame = self.view.frame
                        self.view.addSubview(popOverVC.view)
                        popOverVC.didMove(toParent: self)
          }
    
    
   
    
//    func quantidadePagarPorEstab() {
//        var valor : Double = 0.0
//        var posicao = 0
//
//        let estabCarrinhoAtualizado = realm.objects(EstabCarrinho.self)
//        for estabTaxa in estabCarrinhoAtualizado {
//
//            let itens = realm.objects(ItemsCarrinho.self).filter("ideStabelecimento == %@", estabTaxa.ideStabelecimento)
//
//            for item in itens {
//                valor = valor + Double(item.precoUnitario)
//
//            }
//
//            do {
//
//                  let realm = try Realm()
//                let itens1 = realm.objects(EstabCarrinho.self)
//
//                  if itens.isEmpty == false {
//                      print(itens)
//
//                   try realm.write {
//                    //realm.add(item)
//                    itens1[posicao].valorItens = valor
//                    print("taxa adicionada ")
//
//                    }
//                    valor = 0
//                    posicao += 1
//                }
//              } catch let error {
//                  print(error)
//              }
//
//
//        }
//
//    }
    
    
   
    func preencherTodosArray() {
           preencherEstabelecimento()
           arrayProdutos.removeAll()
           arrayProdutos = preenccherArraySessoes()
       }
    
    
    func preencherEstabelecimento() {
        arrayEstabelecimento1.removeAll()
        arrayEstabelecimento.removeAll()
         arrayEstabelecimento1.append("Dados Encomenda")
       let EstabCarrinhoAtualizado = realm.objects(EstabCarrinho.self)
             for item in  EstabCarrinhoAtualizado {
                arrayEstabelecimento.append(item)
                arrayEstabelecimento1.append(item.nomeEstab)
                
        }

       
        
        print(arrayEstabelecimento)
    }
    
    func preenccherArraySessoes() -> [[ItemsCarrinho]] {
            var arrayProdutos1 = [[ItemsCarrinho]]()
          
            let produtoCarrinhoAtualizado = realm.objects(ItemsCarrinho.self)
           for item1 in arrayEstabelecimento {
               var arrayProduto = [ItemsCarrinho]()
                for item in  produtoCarrinhoAtualizado {
                   if item.estabelecimento == item1.nomeEstab {
                           arrayProduto.append(item)
                       
                   }
               }
               arrayProdutos1.append(arrayProduto)
           }
           print(arrayProdutos1)
            return arrayProdutos1
       }
  
    
}
    
    
    



