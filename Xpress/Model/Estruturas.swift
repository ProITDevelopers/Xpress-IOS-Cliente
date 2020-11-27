//
//  Estruturas.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/21/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import Foundation
import UIKit


struct Token: Decodable {
    var expiracao: String?
    var tokenuser: String?
    var role: String?
}

struct Resposta: Codable {
    var message: String?
  
}

struct Estabelecimento: Codable {
    
    var estabelecimentoID: Int?
    var nomeEstabelecimento: String?
    var descricao: String?
    var contacto1: String?
    var contacto2: String?
    var valorMinimoEncomenda: Int?
    var website: String?
    var logotipo: String?
    var imagemCapa: String?
    var longitude: String?
    var latitude: String?
    var provincia: String?
    var municipio: String?
    var bairro: String?
    var rua: String?
    var nCasa: String?
    var take_away: Bool?
    var bloqueio: Bool?
    var delivery: Bool?
    var popularidade: Int?
    
    struct tipoDeEstacionamento {
        var idTipo: String?
        var descricao: String?
    }
    
    var tipoDeEstabelecimentoID: Int?
    var userID: String?
    var contacos: String?
    var endereco: String?
    var estadoEstabelecimento: String?
    
}

struct Produto: Codable {
    var idProduto: Int?
    var idCategoria: Int?
    var descricaoProdutoC: String?
    var descricaoProduto: String?
    var precoUnid: Int?
    var emStock: Int?
    var estabelecimento: String?
    var tempo_de_preparacao: Int?
    var imagemProduto: String?
    var idEstabelecimento: Int?
    var longitude: String?
    var latitude: String?
    
}

struct Categoria: Codable {
    let idCategoria: Int
    let descricao: String
    let bloqueio: Bool
    let imagemcategoria: String
}


struct Perfil: Codable {
    var nomeCompleto: String?
    var primeiroNome: String?
    var ultimoNome: String?
    var sexo: String?
    var rua: String?
    var bairro: String?
    var municipio: String?
    var provincia: String?
    var contactoMovel: String?
    var contactoAlternativo: String?
    var userName: String?
    var nCasa: String?
    var email: String?
    var imagem: String?
}

struct ItensComprar: Codable {
    var produtoId: Int?
    var quantidade: Int?
    var ideStabelecimento: Int?
    var observacoes: String?
    var taxaEntrega: Double?
   
}

struct EstabComprar: Codable {
    var ideStabelecimento: Int?
    var nomeEstab: String?
    var latitude: String?
    var longitude: String?
   
}


struct localEncomenda: Codable {
    var longitude: String
    var latitude: String
    var pontodeReferencia: String
    var nTelefone: String
}


struct respostaReferencia: Codable {
    var id: String?
    var codigo: String?
    var valor: String
    var dateExpiracao: String?
    var  dataCriacao: String?
    var estado: String?
    var entidade: String?
    var nome: String?
    var email: String?
    var descricao: String?
}

struct Factura: Codable {
     var idFactura: Int
     var entidade: String
     var  metododPagamento: String
     var  horaEntregueMotoboy: String
     var horaRecebidoCliente: String
     var estado, estadoPagamento: String
     var clienteID: Int
     var dataPagamento: String
     var dataPedido: String
     var taxaboy: Double
     var horaPedido: String
     var  latitude: String
     var longitude: String
     var pontodeReferencia: String
     var itens: [Iten]
     var total: Int
}

struct Iten: Codable {
    
       var produto: String?
        var estado: String?
        var horaProntoEntrega: String?
        var horaPedido: String?
        var quantidade: Int?
        var observacoes: String?
  
}


struct CalculoTaxa: Codable {
    var idEstabelecimento: String?
    var latitudeDestino: Double?
    var latitudeOrigem: Double?
    var longitudeDestino: Double?
    var longitudeOrigem: Double?
}

struct TaxaCalculada: Codable {
    var raio: String?
    var taxaFixa: String?
    var idEstabelecimento: String?
    var taxaVariavel: String?
    var distanciaKm: String?
    var valorTaxa: String?
}
