//
//  DetalhesFacturaViewController.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/1/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetalhesFacturaViewController: UIViewController {
    
    var pedido = FacturaActual()
    
      var itens = [Iten]()

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        mostrarPopUpInternet()
             
        // Do any additional setup after loading the view.
        itens = pedido.itens
        tblView.register(UINib.init(nibName: "ItemFacturaTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItem")
        tblView.register(UINib.init(nibName: "DetalhesFacturaTableViewCell", bundle: nil), forCellReuseIdentifier: "cellDetalhe")
        tblView.register(UINib.init(nibName: "PagamentoReferenciaTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReferencia")
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarPopUpInternet()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DetalhesFacturaViewController: UITableViewDataSource, UITableViewDelegate {
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return itens.count + 1
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
         print(indexPath.row)
          switch indexPath.row {
          
          case 0:
            
            if pedido.metododPagamento == "Referencia" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellReferencia", for: indexPath) as! PagamentoReferenciaTableViewCell
                
                cell.estadoPagamentoLabel?.text = pedido.estadoPagamento
                              cell.estadoPedidoLabel?.text = pedido.estado
                             
                              
                              
                              cell.metodoPagamentoLabel?.text = pedido.metododPagamento
                              cell.totalLabel?.text = ("\(pedido.total)0 AKZ")
                              let data = converterData(dataConverter:  pedido.dataPagamento)
                               cell.dataLabel?.text = ("Data: \(data)")
                cell.entidadeLabel.text = pedido.entidade
                cell.referenciaLabel.text = pedido.identificacaoPagamento
                              cell.facturaLabel?.text = ("Factura #\(pedido.idFactura)")
                              let data2 = converterData2(dataConverter:  pedido.dataPedido)
                              cell.dataLabel?.text = data2
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetalhe", for: indexPath) as! DetalhesFacturaTableViewCell
                 
                 cell.estadoPagamentoLabel?.text = pedido.estadoPagamento
                 cell.estadoLabel?.text = pedido.estado
                
                 
                 
                 cell.tipoPagamentoLabel?.text = pedido.metododPagamento
                 cell.totalPagarLabel?.text = ("\(pedido.total)0 AKZ")
                 let data = converterData(dataConverter:  pedido.dataPagamento)
                  cell.dataLabel?.text = ("Data: \(data)")
                 
                 cell.facturaLabel?.text = ("Factura #\(pedido.idFactura)")
                 let data2 = converterData2(dataConverter:  pedido.dataPedido)
                 cell.dataLabel?.text = data2
                 
                 return cell
            }
             
            
              
              
          default:
            
            
            
            
            
              let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath) as! ItemFacturaTableViewCell
              
              let qtd = itens[indexPath.row - 1].quantidade
              let produto = itens[indexPath.row - 1].produto
              cell.nomeItemLabel.text = produto
              cell.qtdLabel.text = "\(qtd!)"
             
              
              return cell
          }
          
         
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
         
         
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         // if indexPath.row == 0 {
              return UITableView.automaticDimension
         // } else {
           //   return 80
         // }
      }
    
}
