//
//  ListarEstabelecimentosViewController.swift
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
import SwiftSignalRClient


class ListarEstabelecimentosViewController: UIViewController, HubConnectionDelegate {
    
    
    
    // metodos do SwiftSignalR (HubConnectionDelegate)
    func connectionDidOpen(hubConnection: HubConnection) {
        print(hubConnection)
    }
    
    func connectionDidFailToOpen(error: Error) {
        print("Erro: \(error)")
    }
    
    func connectionDidClose(error: Error?) {
         print("Erro: \(error)")
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var estabelecimentos = [Estabelecimento]()
    var filteredTableData = [Estabelecimento]()
    var searchEstabelecimentos = [Estabelecimento]()
    var estabelecimento: Estabelecimento?
    var searching = false
    var label = UILabel()
     var perfil = [Perfil]()
    //Dados para a notificacao
    private let serverUrl = "\(linkPrincipal.urlLink)/eventhub"
     let token = UserDefaults.standard.string(forKey: "token")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(UINib.init(nibName: "EstabelecimentoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
               
               btnCarrinhoBarra()
        if VerificarInternet.Connection() {
             verificarSessao()
            obterEstabelecimentos()
             // mostrar notificacoes SinalR
                   // metodos do SignalR
                          let connection = HubConnectionBuilder(url: URL(string: self.serverUrl)!).withHttpConnectionOptions(configureHttpOptions: { (options)  in
                                    options.accessTokenProvider =  {
                                        return self.token
                                        
                                }
                                }).withLogging(minLogLevel: .debug)
                                .build()
                            
            
                          connection.on(method: "ReceiveMessage"){( message: String) in
                              print(connection)
                             print("\(message)")
                            self.mostrarNotificacao(message, message)
                             
                          }
                          
                           connection.delegate = self
                            connection.start()
                          configuracaoNotification()
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if VerificarInternet.Connection() {
                   obterEstabelecimentos()
                    btnCarrinhoBarra()
               } else {
                   print("nao esta conectado")
                  showPopUpInternet()
               }     
    }
    

    // MARK: - mostra o numero de items no carrinho no botao carrino superior direito
    private func configuracaoNotification(){
                    //NOTIFICACOES
                    UNUserNotificationCenter.current().requestAuthorization(options:
                        [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                         // Handle Error
                    })
                    UNUserNotificationCenter.current().delegate = self
                }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irProdutos" {
            let estabelecimentoVC = segue.destination as? ListarProdutosViewController
            
            estabelecimentoVC?.estabelecimento = estabelecimento!
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    func obterEstabelecimentos() {
                
        let URL = "\(linkPrincipal.urlLink)/ListagemEstabelecimentoA"
           
                mostrarProgresso()
          
        
               let token = UserDefaults.standard.string(forKey: "token")
        
                      let headrs: HTTPHeaders = ["Accept": "application/json", "Content-Type" : "application/json"]
                
                Alamofire.request(URL, method: .get, encoding: JSONEncoding.default, headers: headrs).responseString { response in
                      
                      if response.result.isSuccess{

                        self.terminarProgresso()
                         self.estabelecimentos.removeAll()
                          do {
                           
                              let jsonDecoder = JSONDecoder()
                           self.estabelecimentos = try jsonDecoder.decode([Estabelecimento].self, from: response.data!)
                           
                           
                           self.tblView.reloadData()
                          
                          } catch {
                              print("erro inesperado: \(error)")
                          }
                        
                      } else {
                        self.terminarProgresso()
                        print("Erro verifica por favor.")
                        print(response.response?.statusCode as Any)
                        print(response.debugDescription)
                          print(response.result)
                      }
                  }
               
                

                
            }
}



extension ListarEstabelecimentosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchEstabelecimentos.count
        } else {
        return estabelecimentos.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! EstabelecimentoTableViewCell
        
        
        if searching {
           cell.nomeEstabelecimento.text = searchEstabelecimentos[indexPath.row].nomeEstabelecimento
            cell.descricaoEstabelecimento.text = searchEstabelecimentos[indexPath.row].descricao
            if searchEstabelecimentos[indexPath.row].estadoEstabelecimento == "Aberto" {
                cell.estadoLabel.textColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0)
                
                cell.estadoLabel.text =  searchEstabelecimentos[indexPath.row].estadoEstabelecimento
            } else {
                cell.estadoLabel.text = searchEstabelecimentos[indexPath.row].estadoEstabelecimento
            }
            
          
            let url = searchEstabelecimentos[indexPath.row].logotipo
            if url != "Sem Imagem" && url != nil {
                 cell.imgEstabelecimento.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
             cell.imgEstabelecimento.sd_setImage(with: URL(string: searchEstabelecimentos[indexPath.row].logotipo ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
            } else {
                cell.imgEstabelecimento.image = UIImage(named:"fota.jpg")
            }
            
            
           
        } else {
        cell.nomeEstabelecimento.text = estabelecimentos[indexPath.row].nomeEstabelecimento
        cell.descricaoEstabelecimento.text = estabelecimentos[indexPath.row].descricao
        cell.imgEstabelecimento.sd_setImage(with: URL(string: estabelecimentos[indexPath.row].logotipo ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
            
            
            
            if estabelecimentos[indexPath.row].estadoEstabelecimento == "Aberto" {
                cell.estadoLabel.textColor = UIColor(red: 28.0/255.0, green: 136.0/255.0, blue: 101.0/255.0, alpha: 1.0)
                cell.estadoLabel.text =  estabelecimentos[indexPath.row].estadoEstabelecimento
                
            } else {
                cell.estadoLabel.text = "Fechado"
                cell.estadoLabel.textColor = UIColor(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                //estabelecimentos[indexPath.row].estadoEstabelecimento
                
            }
            
            
            let url = estabelecimentos[indexPath.row].logotipo
            if url != "Sem Imagem" && url != nil {
                 cell.imgEstabelecimento.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
             cell.imgEstabelecimento.sd_setImage(with: URL(string: estabelecimentos[indexPath.row].logotipo ?? ""), placeholderImage: UIImage(named: "placeholder.phg"))
            } else {
                cell.imgEstabelecimento.image = UIImage(named:"fota.jpg")
            }
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        estabelecimento = estabelecimentos[indexPath.row]
        if estabelecimentos[indexPath.row].estadoEstabelecimento == "Aberto" {
             performSegue(withIdentifier: "irProdutos", sender: self)
        } else {
            showToast1(controller: self, message: "O estabelecimento encontra-se fechado.", seconds: 2)
        }
       
    }
    
    
}

extension ListarEstabelecimentosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchEstabelecimentos = estabelecimentos.filter({$0.nomeEstabelecimento!.prefix(searchText.count) == searchText})
        searching = true
        tblView.reloadData()
    }
}


extension ListarEstabelecimentosViewController {
    
    
    @objc func rightButtonTouched() {
      print("right button touched")
       let carrinhoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.carrinho) as! CarrinhoViewController
        self.navigationController?.pushViewController(carrinhoVC, animated: true)
    }
    
   
    
    func btnCarrinhoBarra() {
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
                                 
                // button
                let rightButton = UIButton(frame: CGRect(x: 30, y: 0, width: 18, height: 16))
                rightButton.setBackgroundImage(UIImage(named: "carrinho30"), for: .normal)
                                 rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)
      

               if contarItem1() > 0 {
                    rightButton.addSubview(label)
               }
        
               // Bar button item
               let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
               
        
               navigationItem.rightBarButtonItems  = [rightBarButtomItem]
    }
}

//MARK: EXTENSION QUE CONFIGURA AS NOTIFICAOES
extension ListarEstabelecimentosViewController: UNUserNotificationCenterDelegate {
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


extension ListarEstabelecimentosViewController {
  func obterPerfil() {
         
           let URL = "\(linkPrincipal.urlLink)/PerfilCliente"
         
          let token = UserDefaults.standard.string(forKey: "token")
        
         let headrs: HTTPHeaders = ["Authorization": "Bearer \(token!)", "Accept": "application/json", "Content-Type" : "application/json"]
         Alamofire.request(URL, method: .get, headers: headrs).responseJSON { response in
                  
                  if response.result.isSuccess{
                      
                      let perfilJSON = JSON(response.data!)
                      print(perfilJSON)
                     
                      do {
                     
                          let jsonDecoder = JSONDecoder()
                          self.perfil = try jsonDecoder.decode([Perfil].self, from: response.data!)
                       
                      print("veja o perfil")
                        
                         UserDefaults.standard.setValue(self.perfil[0].nomeCompleto, forKey: "nomeCompleto")
                          UserDefaults.standard.setValue(self.perfil[0].email, forKey: "emailUsuario")
                        UserDefaults.standard.setValue(self.perfil[0].imagem, forKey: "imgUsuario")
                        
                        self.mostrarNotificacao("Olá \(self.perfil[0].primeiroNome!)","Seja bem-vindo(a) ao Xpress!")
                      } catch {
                          print("erro inesperado: \(error)")
                      }
                      

                  } else {
                     print("Erro verifica por favor.")
                     print(response.debugDescription)
                      print(response)
                  }
              }
  
     }
}
