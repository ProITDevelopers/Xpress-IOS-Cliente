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
    
   let realm = try! Realm()
     var verificador = true
     var estabelecimentoCarrinho: Results<EstabCarrinho>!
     
    var produtoCarrinho: Results<ItemsCarrinho>!
    var intensCompra = [ItemsCarrinho]()
   
    var token = UserDefaults.standard.string(forKey: "token")
    
    var arrayEstabelecimento = [EstabCarrinho]()
   
    var arrayEstabelecimento1 = [String]()
    var arrayProdutos = [[ItemsCarrinho]]()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        if VerificarInternet.Connection() {
//
//        } else {
//            print("nao esta conectado")
//           showPopUpInternet()
//        }
//
//        getRealm()
//        verificarCarrinho()
//        // Do any additional setup after loading the view.
//        tblView.register(UINib.init(nibName: "ItemCarrinhoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCarrinho")
//        atualizarTotalCarrinho()
//        mostrarButtonDelete()
//
////         selecionarEstabelecimento ()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getRealm()
        preencherTodosArray()
       if VerificarInternet.Connection() {
            
       } else {
           print("nao esta conectado")
          showPopUpInternet()
       }
        
               verificarCarrinho()
               // Do any additional setup after loading the view.
               tblView.register(UINib.init(nibName: "ItemCarrinhoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCarrinho")
               atualizarTotalCarrinho()
               mostrarButtonDelete()
      
    }
    
    func showPopUpTelaLoguin() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPoupUpId") as! PoupUpLoginViewController
        
        self.addChild(popOverVC)
        popOverVC.telaOrigem = 3
        popOverVC.delegate3 = self
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func verificarCarrinho() {
        if quantidadeIten() == 0 {
             tblView.reloadData()
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
        
        token = UserDefaults.standard.string(forKey: "token")
        if quantidadeIten() != 0 {
            
            verificaToken()
            
        } else {
           
            showToast(controller: self, message: "Carrinho está vazio!", seconds: 1)
        }
        
    }
    
        
    
    func verificaToken(){
        if token!.isEmpty {
         
            self.showPopUpTelaLoguin()
         
        } else {
            
             performSegue(withIdentifier: "irMapa", sender: self)
            
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
             arrayEstabelecimento1.removeAll()
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
    
    func preencherTodosArray() {
        preencherEstabelecimento()
        arrayProdutos.removeAll()
        arrayProdutos = preenccherArraySessoes()
    }
    
    func preencherEstabelecimento() {
        arrayEstabelecimento1.removeAll()
        arrayEstabelecimento.removeAll()
       let EstabCarrinhoAtualizado = realm.objects(EstabCarrinho.self)
             for item in  EstabCarrinhoAtualizado {
                arrayEstabelecimento.append(item)
                arrayEstabelecimento1.append(item.nomeEstab)
                
        }

        
        print(arrayEstabelecimento)
    }
    
    func preencherItens(nomeEstab: String) -> [ItemsCarrinho] {
           var arrayProduto = [ItemsCarrinho]()
       
          let produtoCarrinhoAtualizado = realm.objects(ItemsCarrinho.self)
                for item in  produtoCarrinhoAtualizado {
                    if item.estabelecimento == nomeEstab {
                        arrayProduto.append(item)
                    }
                
           }

           print(arrayEstabelecimento)
           return arrayProduto
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
                           verificarCarrinho()
                        }
                    } catch{
                    print("Erro ao Eliminar o produto, \(error)")
                    }
                }
    }
    
    
    
    
    
    
    
    func selecionarEstabelecimento () {
     
        
        
        let arrayOrdenado = produtoCarrinho.sorted {
            $0.ideStabelecimento < $1.ideStabelecimento
        }

        print(arrayOrdenado)
       
        let estab = EstabCarrinho()
        var arrayEstab = [EstabCarrinho]()
        for item in arrayOrdenado {
            estab.ideStabelecimento = item.ideStabelecimento
            estab.nomeEstab = item.estabelecimento
            estab.longitude = 0.0
             estab.latitude = 0.0
        
            arrayEstab.append(estab)
            
        }
        
        //let setArray = arrayEstab.unique()
        
       
    }
    
    func eliminarEstabelecimento(idEstab: Int)  {
              
//          let item = EstabCarrinho()
//          item.ideStabelecimento = idEstabelecimento!
//          item.nomeEstab = nomeEstabelecimento
//          item.latitude = latitude
//          item.longitude = longitude
          do {
              let realm = try Realm()
              let itens = realm.objects(ItemsCarrinho.self).filter("ideStabelecimento == %@", idEstab)
              let estabelecimento = realm.objects(EstabCarrinho.self).filter("ideStabelecimento == %@", idEstab)

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
              print(Realm.Configuration.defaultConfiguration.fileURL)
              //showToast(message: "adicionado", seconds: 1)
              
          } catch let error {
              print(error)
              
          }
          
      }

}


extension CarrinhoViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayProdutos.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = arrayEstabelecimento1[section]
//        return label
//
//    }
    
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
        
        arrayProdutos[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cellCarrinho", for: indexPath) as! ItemCarrinhoTableViewCell

               // enviar na class de celula
               //cell. = produtoCarrinho[indexPath.row].itemId
                cell.idProduto = arrayProdutos[indexPath.section][indexPath.row].produtoId
               cell.idEstabelecimento1 = arrayProdutos[indexPath.section][indexPath.row].ideStabelecimento
               cell.nomeEstabelecimento = arrayProdutos[indexPath.section][indexPath.row].estabelecimento
               cell.precoUnidade = arrayProdutos[indexPath.section][indexPath.row].precoUnitario
               cell.urlImagemProduto = arrayProdutos[indexPath.section][indexPath.row].imagemProduto
              cell.emStock1 = arrayProdutos[indexPath.section][indexPath.row].emStock
               cell.observacoes = arrayProdutos[indexPath.section][indexPath.row].obseracoes
        
             
               cell.nomeProduto?.text = ("\(arrayProdutos[indexPath.section][indexPath.row].nomeItem)")
               cell.descricaoProduto?.text = ("\(arrayProdutos[indexPath.section][indexPath.row].estabelecimento)")
        
               cell.precoProduto?.text = ("\(arrayProdutos[indexPath.section][indexPath.row].precoUnitario).00 AKZ x \(arrayProdutos[indexPath.section][indexPath.row].quantidade)")
        
               cell.quantidadeProduto?.text = ("\(arrayProdutos[indexPath.section][indexPath.row].quantidade)")
               
               if arrayProdutos[indexPath.section][indexPath.row].imagemProduto == ""
               {
                   cell.imgProduto.image = UIImage(named:"fota.jpg")
               } else {
                cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                   cell.imgProduto.sd_setImage(with: URL(string: arrayProdutos[indexPath.section][indexPath.row].imagemProduto ), placeholderImage: UIImage(named: "placeholder.phg"))
               }
               
               //cell.qtdProdutoLabel?.text = ("\(produtoCarrinho[indexPath.row].quantidade)")
               cell.delegate = self
              
               return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension CarrinhoViewController: AtualizarListaCarrinhoDelegate {
    func didListarProduto() {
         preencherTodosArray()
        tblView.reloadData()
    }
    
    func didAvisarLimiteProduto() {
        showToast(controller: self, message: "Já atingiu o limite do produto para o pedido.", seconds: 3)
        }
    
    func didAtualizarTotalCarrinho() {
        preencherTodosArray()
         atualizarTotalCarrinho()
    }
    
}
 
extension CarrinhoViewController: atualizarCarrinhoDelegate {
    func didAtualizarCarrinho() {
         preencherTodosArray()
        tblView.reloadData()
    }
    func didverificarCarrinho() {
         preencherTodosArray()
        verificarCarrinho()
         //preencherTodosArray()
    }
    
    
}

extension CarrinhoViewController: atualizarTokenDelegate2 {
    
    func didAtualizarCarrinho2() {
         preencherTodosArray()
        atualizarTotalCarrinho()
        tblView.reloadData()
        print("atualizado com sucesso!")
    }
    
}
