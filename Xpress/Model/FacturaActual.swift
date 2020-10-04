//
//  FacturaActual.swift
//  Xpress
//
//  Created by Adilson Ebo on 10/1/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import Foundation

class FacturaActual: Codable {
     
      var identificacaoPagamento: String? = ""
      var entidade: String = ""
      var idFactura: Int = 0
      var metododPagamento: String = ""
      var horaEntregueMotoboy: String = ""
      var horaRecebidoCliente: String = ""
      var estado: String = ""
      var estadoPagamento: String = ""
      var clienteID: Int = 0
      var dataPagamento: String = ""
      var dataPedido: String = ""
      var itens = [Iten]()
      var total: Double = 0.0
      var taxaboy: Int = 0
     
      init(identificacaoPagamento: String, entidade: String, idFactura: Int, metododPagamento: String, horaEntregueMotoboy: String, horaRecebidoCliente: String, estado: String, estadoPagamento: String, clienteID: Int, dataPagamento: String, dataPedido: String, itens: [Iten], total: Double, taxaboy: Int) {
        
          self.idFactura = idFactura
          self.metododPagamento = metododPagamento
          self.horaEntregueMotoboy = horaEntregueMotoboy
          self.horaRecebidoCliente = horaRecebidoCliente
          self.estado = estado
          self.estadoPagamento = estadoPagamento
          self.clienteID = clienteID
          self.dataPagamento = dataPagamento
          self.dataPedido = dataPedido
          self.itens = itens
          self.total = total
          
      }
      
      init() {
          
      }
}
