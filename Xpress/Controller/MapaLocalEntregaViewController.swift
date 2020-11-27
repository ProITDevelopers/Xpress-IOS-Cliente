//
//  MapaLocalEntregaViewController.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import RealmSwift

class MapaLocalEntregaViewController: UIViewController, MKMapViewDelegate {
    
   var locationManager: CLLocationManager!
    var myPosition = CLLocationCoordinate2D()
    lazy var geocoder = CLGeocoder()
    var produtoCompra = Produto()
    var longitudeM: Double = 0.0
    var latitudeM : Double = 0.0
      
     var estabelecimentoCarrinho1: Results<EstabCarrinho>!
    var arrayCalcularTaxa = [CalculoTaxa]()
    var arrayTaxaCalculada = [TaxaCalculada]()
     var realm = try! Realm()
    
    var longitude: Double = 1.0
    var latitude: Double = 1.0
      var telemovel = ""
      var referencia = ""
    var tipoPagamento = ""
    var estabelecimentoId = 0
     var vv = ""
    var endereco1 = ""
    var verifica = true
    
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var btnMinhaLocalizacao: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(produtoCompra)
        if VerificarInternet.Connection() {
             
        } else {
            print("nao esta conectado")
           showPopUpInternet()
        }
           
        mapa.delegate = self
        mapa.showsUserLocation = true
        mapa.userTrackingMode = .follow

               enableLocationServices()
               handleRequesteLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(telemovel)
        print(referencia)
        if VerificarInternet.Connection() {
             
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
               
                 self.showPopUpFuncao()
               
           }
       }
    
    @IBAction func piAdd(_ sender: Any) {
        
        let location = (sender as AnyObject).location(in: mapa)
        let looCoord = mapa.convert(location, toCoordinateFrom: mapa)
        latitude = looCoord.latitude
        longitude = looCoord.longitude
        let looCoord1 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapa.removeAnnotations(mapa.annotations)
        setPinUsandoMKAnnotation(location: looCoord1)
        print("Lat: \(latitude), Long: \(longitude)")
        print(vv)
        print(telemovel)
        desdobrarEstabelecimento()
        //print(referencia)
        //showToast(controller: self, message: "localizacao selecionada click em seguinte.", seconds: 2)
        mostrarEndereco(latitude: Double("\(latitude)")!, withLongitude: Double("\(longitude)")!)
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleRequesteLocation() {
        guard let locationManager = self.locationManager else {return}
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func buttonContinuar(_ sender: UIButton) {
        showPopUpFuncao1()
    }
    
    
    @IBAction func buttomMostrarLocalizacaoMapa(_ sender: UIButton) {
        
        print("ja click")
        
       
        mapa.showsUserLocation = true
        mapa.userTrackingMode = .follow
        enableLocationServices()
        handleRequesteLocation()
         let looCoord = CLLocationCoordinate2D(latitude: 25.123, longitude: 55.123)
        let annotation = MKPointAnnotation()
        annotation.coordinate = looCoord
        annotation.title = "Você está aqui"
        annotation.subtitle = "\(referencia)"
        mapa.removeAnnotations(mapa.annotations)
        mapa.addAnnotation(annotation)
        
        
//               mapa.delegate = self
//               mapa.showsUserLocation = true
//               mapa.userLocation.title = "Você está aqui"
               //mapa.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
             //  mapa.tintColor = UIColor.init(named: "XPCorInicial")
    }
    
    
    
    
    @IBAction func buttonMinhaLocalizacao(_ sender: UIButton) {
        print(verifica)
        if verifica == true {
            if latitudeM == 0.0 && longitudeM == 0.0 {
                showToast(controller: self, message:  "Não foi possivel pegar a localização!", seconds: 3)
                
            } else {
                
                latitude = latitudeM
                longitude = longitudeM
                
                desdobrarEstabelecimento()
                mapa.removeAnnotations(mapa.annotations)
                mostrarEndereco(latitude: latitude, withLongitude: longitude)
                print("lat: \(latitude)  log:\(longitude)")
                print("endereco: \(referencia)")
                
            }
            
          
        }
       verifica = false
        
    }
    
    
}


//MARK: - CLLocationManagerDelegate
extension MapaLocalEntregaViewController: CLLocationManagerDelegate {
    
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            
            
           // let locationM = locations[0]
            
            print("Got Location \(location.coordinate.latitude) , \(location.coordinate.longitude)")
                    myPosition = location.coordinate
                    locationManager.stopUpdatingLocation()
                  
                    let span = MKCoordinateSpan(latitudeDelta: 0.0275, longitudeDelta: 0.0275)
                   let region = MKCoordinateRegion(center: myPosition, span: span)
                    mapa.setRegion(region, animated: true)
                    locationManager.stopUpdatingLocation()
            
            
            longitudeM = location.coordinate.longitude
            latitudeM = location.coordinate.latitude
            
        }
        
        
        
        
    }
    

    
    func enableLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
             print("Autorização de Localização não determinada")
            
        case .restricted:
            print("Autorização de Localização Restrita")
        case .denied:
            print("Autorização de Localização  denied")
        case .authorizedAlways:
            print("Autorização de Localização autorizado")
        case .authorizedWhenInUse:
            print("Autorização de Localização quando tiver em uso")
        @unknown default:
           print("error")
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager?.location != nil else {
            print("Erro na definição da localização")
            return
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let Identificador = "pin"
        let anotacaoView = mapView.dequeueReusableAnnotationView(withIdentifier: Identificador) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Identificador)
        
        anotacaoView.canShowCallout = true
        
         if annotation is MKUserLocation {
           
          // anotacaoView.image = UIImage(imageLiteralResourceName:"pin_green")
          // return anotacaoView
            return nil

           } else if annotation is MapPin {
               // handle other annotations
            anotacaoView.image = UIImage(imageLiteralResourceName:"icons8-place-marker-50")
            return anotacaoView

         }
             return nil
     
    }
    
    func setPinUsandoMKAnnotation(location: CLLocationCoordinate2D) {
        
       // mostrarEndereco(latitude: location.latitude, withLongitude: location.longitude)
        let pin1 = MapPin(title: referencia, locationName: referencia, coordinate: location)
        let coordinateRegion = MKCoordinateRegion(center: pin1.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        
       // mapa.setRegion(coordinateRegion, animated: true)
        mapa.addAnnotations([pin1])
    }
    
}


extension MapaLocalEntregaViewController {
    
    // metodo que inverte cordenadas (latitude e longitude em endereco)
    
    
    
    func mostrarEndereco(latitude: Double, withLongitude longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                  
                    //construcao do endereco
                    var addressString : String = ""
                    if pm.thoroughfare != nil {
                       addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        
                         addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                    self.referencia = addressString
                    self.verificaToken()
                    
                }
        })
        
    }
    
}

extension MapaLocalEntregaViewController {
    
     func showPopUpFuncao(){
           
           let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.popUpSalvarEndereco) as! PopUpSalvarEnderecoViewController
           self.addChild(popOverVC)
        
           popOverVC.delegate5 = self
           popOverVC.endereco = referencia
        popOverVC.longitude = longitude
        popOverVC.latitude = latitude
       
        if produtoCompra.idProduto != nil {
                popOverVC.produtoComprar = produtoCompra
            popOverVC.estabelecimentoId = estabelecimentoId
            }
        
           //  popOverVC.delegate = self
           popOverVC.view.frame = self.view.frame
           self.view.addSubview(popOverVC.view)
           popOverVC.didMove(toParent: self)
       }
    
    
    
    
    
    func showPopUpFuncao1(){
              
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.popUpPagamento) as! PopUpPagamentoViewController
              self.addChild(popOverVC)
              // popOverVC.endereco = referencia
              // popOverVC.delegate1 = self
              popOverVC.view.frame = self.view.frame
              self.view.addSubview(popOverVC.view)
              popOverVC.didMove(toParent: self)
          }
    
    func showPopUpTelaLoguin() {
           let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPoupUpId") as! PoupUpLoginViewController
           
           self.addChild(popOverVC)
           popOverVC.telaOrigem = 4
           popOverVC.delegate4 = self
           popOverVC.view.frame = self.view.frame
           self.view.addSubview(popOverVC.view)
           popOverVC.didMove(toParent: self)
       }
}


 // extension MapaLocalEntregaViewController: passarDados {
    
  
    
  //    func dados(telef: String, ref: String) {
       //       print(telef)
         //     print(ref)
          //    telemovel = telef
          //    referencia = ref
            //  print(longitude)
           //   print(latitude)
            
        //  }
    
    
    
 // }


//extension MapaLocalEntregaViewController: passarPagamento {
    
 //   func guardarTipoPagamento(pagamento: String) {
  //      tipoPagamento = pagamento
   //     print(telemovel)
   //     print(referencia)
   //     print(longitude)
   //     print(latitude)
   //     print(tipoPagamento)
  //  }
    
//}

extension MapaLocalEntregaViewController: atualizarBotaoDelegate {
   
    func didAtualizarBotao() {
        verifica = true
    }
 
}


extension MapaLocalEntregaViewController: atualizarBotaoDelegate2 {
   
    func didAtualizarBotao2() {
         verifica = true
    }
    
   
 
}

extension MapaLocalEntregaViewController: atualizarVerificarDelegate {
    func didAtualizarVerificarMap() {
        verifica = true
    }
    
}

extension MapaLocalEntregaViewController {
    
    func desdobrarEstabelecimento() {
            estabelecimentoCarrinho1 = realm.objects(EstabCarrinho.self)
           var calcularTaxa = CalculoTaxa()
           var arrayCalcularTaxa2 = [CalculoTaxa]()
        
           for item in estabelecimentoCarrinho1 {
            
            calcularTaxa.idEstabelecimento = "\(item.ideStabelecimento)"
            
            calcularTaxa.latitudeDestino = latitude
            calcularTaxa.longitudeDestino = longitude
            
            calcularTaxa.latitudeOrigem = item.latitude
            calcularTaxa.longitudeOrigem = item.longitude
         
            
          
            
               arrayCalcularTaxa2.append(calcularTaxa)
           }
           print(arrayCalcularTaxa2)
           //arrayCalcularTaxa = arrayCalcularTaxa2
        CalcularTaxa(arrayList: arrayCalcularTaxa2)
       }
       
       
    func CalcularTaxa(arrayList:[CalculoTaxa]) {

           
           
           var itensTaxa: [String:Any] = [:]
           var arrayItem = [[String:Any]]()
        
           for i in 0..<arrayList.count {
              
               itensTaxa.updateValue(arrayList[i].idEstabelecimento!, forKey: "idEstabelecimento")
            
             itensTaxa.updateValue(arrayList[i].latitudeDestino!, forKey: "latitudeDestino")
            
          
               itensTaxa.updateValue(arrayList[i].latitudeOrigem!, forKey: "latitudeOrigem")
            
            itensTaxa.updateValue(arrayList[i].longitudeDestino!, forKey: "longitudeDestino")
            
               itensTaxa.updateValue(arrayList[i].longitudeOrigem!, forKey: "longitudeOrgin")
            
              
               
               print(itensTaxa)
               arrayItem.append(itensTaxa)
               
           }
           
        let url = "\(linkPrincipal.urlLinkTaxa)"

                  var request = URLRequest(url: URL.init(string: url)!)
                  request.httpMethod = "POST"
                  

                  
                 
                  // let headrs: HTTPHeaders = ["Key": "PIq12oaO9opUyE482pgrY"]
                  
                  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                  request.setValue("PIq12oaO9opUyE482pgrY", forHTTPHeaderField: "Key")
                  request.setValue("application/json", forHTTPHeaderField: "Accept")
                 
                  let dataToSync = arrayItem
                  
                  request.httpBody = try! JSONSerialization.data(withJSONObject: dataToSync)

                  Alamofire.request(request).responseJSON{ (response) in

                      print("Success: \(response)")
                      switch response.result{
                      case .success:
                          let statusCode: Int = (response.response?.statusCode)!
                          switch statusCode{
                          case 200:
                              //completionHandler(true)
                              do {
                                  let jsonDecoder = JSONDecoder()
                                  print(response.response?.statusCode ?? "")
                                  self.arrayTaxaCalculada = try jsonDecoder.decode([TaxaCalculada].self, from: response.data!)
                                 // print(self.arrayTaxaCalculada)
                               self.adicionarTaxaEntrega(listaTaxa:self.arrayTaxaCalculada)
                               self.adicionarTaxaEntregaEstab(listaTaxa: self.arrayTaxaCalculada)
                                
                                print(" dicionario enviado:\(itensTaxa)")
                               
                              } catch {
                                  print(response.response?.statusCode ?? "")
                                  print("erro inesperado: \(error)")
                                  
                              }
                              break
                          default:
                             // completionHandler(false)
                              break
                          }
                          break
                      case .failure:
                         // completionHandler(false)
                          print("erro 1")
                          break
                      }
                  }
           
       }
    
    
//    func adicionarPontoDestino() {
//        let estabCarrinhoAtualizado = realm.objects(EstabCarrinho.self)
//        let long = longitude
//        let lat = latitude
//
//                  for estabTaxa in estabCarrinhoAtualizado {
//
//                    do {
//
//                        try realm.write {
//                              //realm.add(item)
//                              estabTaxa.longitudeD = long
//                              estabTaxa.latitudeD = lat
//                              print("taxa adicionada ")
//
//                              }
//
//
//                        } catch let error {
//                            print(error)
//                        }
//
//
//                  }
//    }
//
//
    
    func adicionarTaxaEntrega(listaTaxa: [TaxaCalculada]) {
           
           let produtoCarrinhoAtualizado = realm.objects(ItemsCarrinho.self)
           
           for estabTaxa in listaTaxa {
               
               for item in produtoCarrinhoAtualizado {
                   
                   let idEsta = Int(estabTaxa.idEstabelecimento!)
                   
                   if item.ideStabelecimento == idEsta {
                      
                      
                       do {
                              
                              let realm = try Realm()
                              let itens = realm.objects(ItemsCarrinho.self).filter("itemId == %@", item.itemId)
                              
                              if itens.isEmpty == false {
                                  print(itens)
                              
                               try realm.write {
                                       //realm.add(item)
                                       
                                   itens[0].taxaEntrega1 = Double(estabTaxa.valorTaxa!)!
                                       print("taxa adicionada ")
                                   }
                               
                              }
                          } catch let error {
                              print(error)
                          }
                   }
               }
           }
       }
       
//       func quantidadePagarPorEstab() {
//           var valor : Double = 0.0
//           var posicao = 0
//
//           let estabCarrinhoAtualizado = realm.objects(EstabCarrinho.self)
//           for estabTaxa in estabCarrinhoAtualizado {
//
//               let itens = realm.objects(ItemsCarrinho.self).filter("ideStabelecimento == %@", estabTaxa.ideStabelecimento)
//
//               for item in itens {
//                   valor = valor + Double(item.precoUnitario)
//
//               }
//
//               do {
//
//                     let realm = try Realm()
//                   let itens1 = realm.objects(EstabCarrinho.self)
//
//                     if itens.isEmpty == false {
//                         print(itens)
//
//                      try realm.write {
//                       //realm.add(item)
//                       itens1[posicao].valorItens = valor
//                       print("taxa adicionada ")
//
//                       }
//                       valor = 0
//                       posicao += 1
//                   }
//                 } catch let error {
//                     print(error)
//                 }
//
//
//           }
//
//       }
       
       
       func adicionarTaxaEntregaEstab(listaTaxa: [TaxaCalculada]) {
              
              let estabCarrinhoAtualizado = realm.objects(EstabCarrinho.self)
              
              for estabTaxa in listaTaxa {
                  
                  for item in estabCarrinhoAtualizado {
                      
                      let idEsta = Int(estabTaxa.idEstabelecimento!)
                      
                      if item.ideStabelecimento == idEsta {
                         
                         
                          do {
                                 
                                 let realm = try Realm()
                           let itens = realm.objects(EstabCarrinho.self).filter("ideStabelecimento == %@", item.ideStabelecimento)
                                 
                                 if itens.isEmpty == false {
                                     print(itens)
                                 
                                  try realm.write {
                                          //realm.add(item)
                                          
                                      itens[0].taxaEntrega = Double(estabTaxa.valorTaxa!)!
                                          print("taxa adicionada ")
                                      }
                                  
                                 }
                             } catch let error {
                                 print(error)
                             }
                      }
                  }
              }
          }
}
