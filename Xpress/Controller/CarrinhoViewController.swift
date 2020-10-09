//
//  CarrinhoViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SDWebImage




class CarrinhoViewController: UIViewController {
    
     
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var viewInformacao: UIView!
    @IBOutlet weak var btnConfirmar: UIButton!
  
    var produtoCarrinho: Results<ItemsCarrinho>!
    var intensCompra = [ItensComprar]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mostrarPopUpInternet()
        verificarSessao()
        getRealm()
        verificarCarrinho()
        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "ItemCarrinhoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCarrinho")
        atualizarTotalCarrinho()
        mostrarButtonDelete()
        mostrarPopUpInternet()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarPopUpInternet()
        verificarCarrinho()
    }
    
    
    
    func verificarCarrinho() {
        if quantidadeIten() == 0 {
            viewInformacao.isHidden = true
            btnConfirmar.isHidden = true
            showToast1(controller: self, message: "Carrinho está vazio!", seconds: 3)
        } else {
            viewInformacao.isHidden = false
            btnConfirmar.isHidden = false
        }
    }
    
    func atualizarTotalCarrinho() {
        itemsLabel.text = "\(quantidadeIten()) Items"
        totalLabel.text = "Total: \(quantidadePagar())0 AKZ"
    }
    
    @IBAction func buttonConfirmar(_ sender: UIButton) {
        if quantidadeIten() != 0 {
            performSegue(withIdentifier: "irMapa", sender: self)
        } else {
            showToast(controller: self, message: "Carrinho está vazio!", seconds: 1)
        }
        
    }
     // MARK: - Busca dos dados do carrinho
    func getRealm() {
       
           produtoCarrinho = realm.objects(ItemsCarrinho.self)
            tblView.reloadData()
       }

    func mostrarButtonDelete() {
         // button
                     let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                     rightButton.setBackgroundImage(UIImage(named: "icons8-trash-30"), for: .normal)
                     rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)

                    // rightButton.addSubview(label)
                     
                     // Bar button item
                     let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
                     
                     navigationItem.rightBarButtonItems  = [rightBarButtomItem]
    }
    

    @objc func rightButtonTouched() {
         print("right button touched")
        if quantidadeIten() != 0 {
            showPopUpFuncao1()
        } else {
            showToast1(controller: self, message: "O carrinho está vazio!", seconds: 2)
        }
            
       }
    
    
    
    func showPopUpFuncao1() {
        
     let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.popUpLimparCarrinho) as! PopUpLimparCarrinhoViewController
        self.addChild(popOverVC)
         popOverVC.delegate1 = self
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    
    func showPopUpFuncao() {
           
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.popUpPagamento) as! PopUpPagamentoViewController
           self.addChild(popOverVC)
           
           popOverVC.view.frame = self.view.frame
           self.view.addSubview(popOverVC.view)
           popOverVC.didMove(toParent: self)
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func quantidadePagar() -> Double {
          var valor : Double = 0.0
          
          for item in  produtoCarrinho {
              valor = valor + Double(item.quantidade * item.precoUnitario)
          }
          return valor
      }
    
    func quantidadeIten() -> Int {
        var valor : Int = 0
        
        valor = produtoCarrinho.count
        
        return valor
    }
    
    func eliminarItemCarrinho(posicaoItem: Int){
        if let item = produtoCarrinho?[posicaoItem] {
                do {
                    try realm.write {
                        realm.delete(item)
                                    
                        }
                    } catch{
                    print("Erro ao Eliminar o produto, \(error)")
                    }
                }
    }

}


extension CarrinhoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtoCarrinho.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cellCarrinho", for: indexPath) as! ItemCarrinhoTableViewCell

             
               // enviar na class de celula
               //cell. = produtoCarrinho[indexPath.row].itemId
               cell.idProduto = produtoCarrinho[indexPath.row].produtoId
               cell.idEstabelecimento1 = produtoCarrinho[indexPath.row].ideStabelecimento
               cell.nomeEstabelecimento = produtoCarrinho[indexPath.row].estabelecimento
               cell.precoUnidade = produtoCarrinho[indexPath.row].precoUnitario
               cell.urlImagemProduto = produtoCarrinho[indexPath.row].imagemProduto
              cell.emStock1 = produtoCarrinho[indexPath.row].emStock
               cell.observacoes = produtoCarrinho[indexPath.row].obseracoes
        
             
               cell.nomeProduto?.text = ("\(produtoCarrinho[indexPath.row].nomeItem)")
               cell.descricaoProduto?.text = ("\(produtoCarrinho[indexPath.row].estabelecimento)")
               cell.precoProduto?.text = ("\(produtoCarrinho[indexPath.row].precoUnitario).00 AKZ x \(produtoCarrinho[indexPath.row].quantidade)")
               cell.quantidadeProduto?.text = ("\(produtoCarrinho[indexPath.row].quantidade)")
               
               if produtoCarrinho[indexPath.row].imagemProduto == nil
               {
                   cell.imgProduto.image = UIImage(named:"fota.jpg")
               } else {
                cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                   cell.imgProduto.sd_setImage(with: URL(string: produtoCarrinho[indexPath.row].imagemProduto ), placeholderImage: UIImage(named: "placeholder.phg"))
               }
               
               //cell.qtdProdutoLabel?.text = ("\(produtoCarrinho[indexPath.row].quantidade)")
               cell.delegate = self
              
               return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {

            eliminarItemCarrinho(posicaoItem: indexPath.row)
                    //produtoCarrinho[indexP
                     atualizarTotalCarrinho()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    //tableView.reloadData()
                }
    }
    
}


extension CarrinhoViewController: AtualizarListaCarrinhoDelegate {
    func didListarProduto() {
        tblView.reloadData()
    }
    
    func didAvisarLimiteProduto() {
        showToast(controller: self, message: "Já atingiu o limite do produto para o pedido.", seconds: 3)
        }
    
    func didAtualizarTotalCarrinho() {
         atualizarTotalCarrinho()
    }
    
}
 
extension CarrinhoViewController: atualizarCarrinhoDelegate {
    func didAtualizarCarrinho() {
        atualizarTotalCarrinho()
        tblView.reloadData()
    }
    func didverificarCarrinho() {
        verificarCarrinho()
    }
    
    
}
