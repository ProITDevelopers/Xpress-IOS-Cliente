//
//  EncomendasViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/29/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//cellFactura
//   http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/
import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import SDWebImage

class EncomendasViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
      var pedidos = [FacturaActual]()
       var pedidos1 = [FacturaActual1]()
  var pedidoD = FacturaActual()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.register(UINib.init(nibName: "FacturaTableViewCell", bundle: nil), forCellReuseIdentifier: "cellFactura")
        // Do any additional setup after loading the view.
        obterFacturas( URL: "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/FacturasActualCliente")
        mostrarPopUpInternet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obterFacturas( URL: "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/FacturasActualCliente")
        mostrarPopUpInternet()
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
    
    
    func obterFacturas( URL: String) {
           
           //let URL = "http://3.18.194.189/FacturasActualCliente"
           
           let token = UserDefaults.standard.string(forKey: "token")
           print(token)
           
           let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
           
           Alamofire.request(URL, method: .get, headers: headrs).responseJSON { response in
               
               if response.result.isSuccess{
                   
                   let pedidosJSON = JSON(response.data!)
                   print(pedidosJSON)
                   self.pedidos.removeAll()
                   
                   do {
                       let jsonDecoder = JSONDecoder()
                       self.pedidos = try jsonDecoder.decode([FacturaActual].self, from: response.data!)
                       self.tblView.reloadData()
                   
                   } catch {
                       print("erro inesperado1: \(error)")
                   }
                   
                   
                   
                   if response.response?.statusCode == 200 {
                       print(response.response?.statusCode)
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
                           self.pedidos1.append(pedido)
                       }
                       }
                       
                       for item in self.pedidos1 {
                           print(item)
                       }
                       
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






