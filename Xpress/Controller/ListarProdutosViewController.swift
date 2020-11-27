//
//  ListarProdutosViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/23/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import RealmSwift
import UserNotifications

class ListarProdutosViewController: UIViewController {
    
    

 
    var produtos = [Produto]()
    var idEstabelecimento: Int?
    var produtoShow: Produto?
    
   
   
    @IBOutlet weak var tblView: UITableView!
     var label = UILabel()
    
   
    var estabelecimento = Estabelecimento()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         print(Realm.Configuration.defaultConfiguration.fileURL)
        tblView.register(UINib.init(nibName: "ProdutoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellProdudo")
        
        tblView.register(UINib.init(nibName: "DetalheShowProdutoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellEstab")
         idEstabelecimento = estabelecimento.estabelecimentoID
        if VerificarInternet.Connection() {
             obterProdutos(idEstabelecimentoF: (estabelecimento.estabelecimentoID)!)
            
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
        configuracaoNotification()
        contarItem(label: label)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           
        
        if VerificarInternet.Connection() {
            obterProdutos(idEstabelecimentoF: (estabelecimento.estabelecimentoID)!)
            tblView.reloadData()
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
        
        contarItem(label: label)
        
     
       
    }
    
    
    
    private func configuracaoNotification(){
                          //NOTIFICACOES
                          UNUserNotificationCenter.current().requestAuthorization(options:
                              [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                               // Handle Error
                          })
                          UNUserNotificationCenter.current().delegate = self
                      }
    
    
    
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

  
    
    func saltarCarrinho() {
        
        let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.carrinho) as! CarrinhoViewController
             self.navigationController?.pushViewController(carrinhoVC, animated: true)
    
               
    }
    

     
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
       if segue.identifier == "showProdutoId" {
            let showProdutoVC = segue.destination as? ProdutoShowViewController
            
                showProdutoVC?.produto = produtoShow!
               showProdutoVC?.nomeEstabelecimento = estabelecimento.nomeEstabelecimento!
               showProdutoVC?.estabelecimentoId = idEstabelecimento!
            
        }
    }
    

    func obterProdutos(idEstabelecimentoF: Int ) {
           
           let URL = "\(linkPrincipal.urlLink)/ListarProdutosEstab/\(idEstabelecimentoF)"
           
           let token = UserDefaults.standard.string(forKey: "token")
           let headrs: HTTPHeaders = ["Accept": "application/json", "Content-Type" : "application/json"]
           mostrarProgresso()
           
           Alamofire.request(URL, method: .get, encoding: JSONEncoding.default, headers: headrs).responseString { response in
                      
                      if response.result.isSuccess{
                          self.terminarProgresso()
                          let produtoJSON = JSON(response.data!)
                          print(produtoJSON)
                          self.produtos.removeAll()
                          
                          do {
                              let jsonDecoder = JSONDecoder()
                              self.produtos = try jsonDecoder.decode([Produto].self, from: response.data!)
 
                             
                              self.tblView.reloadData()
                              
                          } catch {
                              print("erro inesperado: \(error)")
                          }
                          
                          if response.response?.statusCode == 200 {
                              print("veja a lista")
                             // print(self.produtos[0].descricaoProdutoC)
                              self.terminarProgresso()
                              
                          } else {
                              print("Erro verifica por favor.")
                              print(response.debugDescription)
                          }
                      } else {
                          print(response.result)
                      }
                  }
       
       }
    
    
    
    
   
    
}


extension ListarProdutosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtos.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "cellEstab", for: indexPath) as! DetalheShowProdutoTableViewCell
             
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
             if traitCollection.userInterfaceStyle == .dark {
                cell.btnCarrinho.setImage(UIImage(named: "carrinho30.jpg"), for: .normal)
             } else {
                cell.btnCarrinho.setImage(UIImage(named: "carrinho.jpg"), for: .normal)
             }
            
                cell.btnCarrinho.addSubview(label)
          
             cell.delegate = self
             cell.estabelecimentoLabel.text = estabelecimento.nomeEstabelecimento
             cell.enderecoEstsLabel.text = estabelecimento.endereco
                cell.imgCapaEstabelecimento.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
             cell.imgCapaEstabelecimento.sd_setImage(with: URL(string: estabelecimento.imagemCapa ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
             
             
             
             
            return cell
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: "CellProdudo", for: indexPath) as! ProdutoTableViewCell
                          
                          
                         
                   cell.nomeProduto.text = produtos[indexPath.row - 1].descricaoProdutoC
                   cell.descricaoProduto.text = produtos[indexPath.row - 1].descricaoProduto
                   cell.imgProduto.sd_setImage(with: URL(string: produtos[indexPath.row - 1].imagemProduto ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                   cell.precoProduto.text = " \(String(produtos[indexPath.row - 1].precoUnid!)),00 AKZ"
                   
                   // enviar na class de celula
                   cell.idProduto = produtos[indexPath.row - 1].idProduto
                   cell.idEstabelecimento = produtos[indexPath.row - 1].idEstabelecimento
                   cell.nomeEstabelecimento = produtos[indexPath.row - 1].estabelecimento!
                   cell.produtoNome = produtos[indexPath.row - 1].descricaoProdutoC!
                   cell.precoUnidade = produtos[indexPath.row - 1].precoUnid!
                   cell.urlImagemProduto = produtos[indexPath.row - 1].imagemProduto!
                   cell.emStock1 = (produtos[indexPath.row - 1].emStock!)
             cell.longitude = produtos[indexPath.row - 1].longitude!
             cell.latitude = produtos[indexPath.row - 1].latitude!
             
                   let url = produtos[indexPath.row - 1].imagemProduto
                              if url != "Sem Imagem" && url != nil {
                               cell.imgProduto.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                               cell.imgProduto.sd_setImage(with: URL(string: produtos[indexPath.row - 1].imagemProduto ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
                              } else {
                                  cell.imgProduto.image = UIImage(named:"fota.jpg")
                              }

                   cell.qtdProduto.text = String(mostrarQtdIten(idItem: produtos[indexPath.row - 1].idProduto!))
                   
                   if mostrarQtdIten(idItem: produtos[indexPath.row - 1].idProduto!) == 0 {
                       cell.stackViewButton.isHidden = true
                        cell.carrinhoAddProduto.isHidden = false
                   } else {
                       cell.carrinhoAddProduto.isHidden = true
                     cell.stackViewButton.isHidden = false
                   }
                   cell.delegate = self
                  return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("Selecionado")
        
        if indexPath.row != 0 {
            produtoShow = produtos[indexPath.row - 1]
            performSegue(withIdentifier: "showProdutoId", sender: self)
        }
           
    }
    
}


extension ListarProdutosViewController: AtualizarListaProdutosDelegate {
    func didListarProduto() {
        tblView.reloadData()
       
    }
    
    func mostrarBtnCarrinho() {
     
         tblView.reloadData()
    }
    
    func didAvisarLimiteProduto() {
    showToast(controller: self, message: "Já atingiu o limite do  produto para o pedido..", seconds: 3)
    }
    
}

extension ListarProdutosViewController: SaltarParaCarrinhoDelegate {
    func didIrCarrinho() {
        saltarCarrinho()
    }
    
    
}
    
//MARK: EXTENSION QUE CONFIGURA AS NOTIFICAOES
extension ListarProdutosViewController: UNUserNotificationCenterDelegate {
func mostrarNotificacao(_ title: String, _ subtitile: String, _ body: String?=nil){
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitile
    content.body = body ?? ""
    content.badge = 0
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                    repeats: false)
    
    let requestIdentifier = UUID().uuidString
    let request = UNNotificationRequest(identifier: requestIdentifier,
                                        content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request,
                                           withCompletionHandler: { (error) in
                                            // Handle error
    })
}




func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
}



func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let application = UIApplication.shared
    let userInfo = response.notification.request.content
    //background
    if(application.applicationState == .active){
        print(userInfo.title)
        print(userInfo.subtitle)
        print(userInfo.body)
    }
    
    
    //foreground
    if(application.applicationState == .inactive)
    {
        print(userInfo.title)
        print(userInfo.subtitle)
        print(userInfo.body)
    }
    
    
    
    completionHandler()
}
}
