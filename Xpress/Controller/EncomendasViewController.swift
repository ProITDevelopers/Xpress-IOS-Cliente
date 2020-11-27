//
//  EncomendasViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//cellFactura
//   https://apixpress.lengueno.com
import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import SDWebImage

class EncomendasViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnLogin: UIButton!
    
    //    @IBOutlet weak var seguimento: UISegmentedControl!
     
      var pedidos = [FacturaActual]()
       var pedidos1 = [FacturaActual1]()
  var pedidoD = FacturaActual()
     var token = UserDefaults.standard.string(forKey: "token")
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        mostrarPopUpInternet()
//        verificarSessao()
//        tblView.register(UINib.init(nibName: "FacturaTableViewCell", bundle: nil), forCellReuseIdentifier: "cellFactura")
//        // Do any additional setup after loading the view.
//        
//        mostrarEncomendas()
//        
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//         mostrarPopUpInternet()
//         verificarSessao()
//         mostrarEncomendas()
//    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       verificarSessao()
             tblView.register(UINib.init(nibName: "FacturaTableViewCell", bundle: nil), forCellReuseIdentifier: "cellFactura")
        if VerificarInternet.Connection() {
               mostrarEncomendas()
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }

    }

   func mostrarEncomendas() {
           token = UserDefaults.standard.string(forKey: "token")
                 pedidos.removeAll()
                 tblView.reloadData()
                 if token!.isEmpty {
                     tblView.separatorStyle = .none
                    btnLogin.isHidden = false
                    
                 } else {
                     btnLogin.isHidden = true
                    tblView.separatorStyle = .singleLine
                    obterFacturas( URL: "\(linkPrincipal.urlLink)/FacturasActualCliente")


                 }
      }
      
    @IBAction func ButtonLogin(_ sender: UIButton) {
         showPopUpTelaLoguin()
    }
    
   func showPopUpTelaLoguin() {
             let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPoupUpId") as! PoupUpLoginViewController
                       
                       self.addChild(popOverVC)
                       popOverVC.telaOrigem = 1
                       popOverVC.delegate2 = self
                       popOverVC.view.frame = self.view.frame
                       self.view.addSubview(popOverVC.view)
                       popOverVC.didMove(toParent: self)
         }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "irDetalhesFaturas"  {
            
            let detalhesTVC = segue.destination as! DetalhesFacturaViewController
            detalhesTVC.pedido = pedidoD
            
        }
    }
    
//    @IBAction func seguimentoController(_ sender: Any) {
//
//        let getIndex = seguimento.selectedSegmentIndex
//               print(getIndex)
//
//               switch getIndex {
//               case 0:
//                   obterFacturas(URL: "\(linkPrincipal.urlLink)/FacturasActualCliente")
//               case 1:
//                   obterFacturas(URL: "\(linkPrincipal.urlLink)/api/listagemFactura/v1/cliente/FacturaAcaminho")
//               case 2:
//                   obterFacturas(URL: "\(linkPrincipal.urlLink)/api/listagemFactura/v1/cliente/FacturaEntregue")
//                case 3:
//                obterFacturas(URL: "\(linkPrincipal.urlLink)/HistoricoFacturasCliente")
//               default:
//                   print("Erro nenhuma selecionada!")
//               }
//    }
    
    func obterFacturas( URL: String) {
           
           //let URL = "\(linkPrincipal.urlLink)/FacturasActualCliente"
           
         
           
           mostrarProgresso()
           let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
           
           Alamofire.request(URL, method: .get, headers: headrs).responseJSON { response in
               
               if response.result.isSuccess{
                   
                   let pedidosJSON = JSON(response.data!)
                   print(pedidosJSON)
                   self.pedidos.removeAll()
                   
                   do {
                       let jsonDecoder = JSONDecoder()
                       self.pedidos = try jsonDecoder.decode([FacturaActual].self, from: response.data!)
                    self.terminarProgresso()
                    if response.response?.statusCode == 200 {
                      
                         print("veja a lista")
                        // print("\(self.pedidos[0].clienteID ?? "" )")
                      
                         if self.pedidos.count > 0 {
                             
                             
                         self.pedidos.reverse()
                         for item in self.pedidos {
                             
                         let pedido = FacturaActual1()
                              pedido.open = false
                             pedido.clienteID = item.clienteID
                             pedido.metododPagamento = item.metododPagamento
                             pedido.horaEntregueMotoboy = item.horaEntregueMotoboy
                             pedido.horaRecebidoCliente = item.horaRecebidoCliente
                             pedido.estado = item.estado
                             pedido.estadoPagamento = item.estadoPagamento
                             pedido.idFactura = item.idFactura
                             pedido.dataPagamento = item.dataPagamento
                             pedido.dataPedido = item.dataPedido
                             pedido.itens = item.itens
                             pedido.total = item.total
                            pedido.taxaboy = item.taxaboy
                             self.pedidos1.append(pedido)
                         }
                         }
                         
                       
                     } else {
                         print("Erro verifica por favor.")
                    self.terminarProgresso()
                         print(response.debugDescription)
                     }

                    
                    
                       self.tblView.reloadData()
                   
                   } catch {
                    self.terminarProgresso()
                       print("erro inesperado1: \(error)")
                   }
                   
                   
                   
               } else {
                self.terminarProgresso()
                   print(response.result)
               }
           }
           
       }


}


extension EncomendasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return pedidos.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellFactura", for: indexPath) as! FacturaTableViewCell
           cell.facturaLabel?.text = ("Factura #\(pedidos[indexPath.row].idFactura)")
        let data = converterData(dataConverter:  pedidos[indexPath.row].dataPedido)
          cell.dataFacturaLabel?.text = data
        cell.estabelecimentoLabel.text = ("\(pedidos[indexPath.row].estado)")
        
        
        
         
           return cell
       }
       
       
       
       
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       
       
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         pedidoD = pedidos[indexPath.row]
        performSegue(withIdentifier: "irDetalhesFaturas", sender: self)

       }
       
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80

           
       }
    
    
}


extension EncomendasViewController: atualizarTokenDelegate {
    func didAtualizarEncomendas() {
       mostrarEncomendas()
    }
   
}



