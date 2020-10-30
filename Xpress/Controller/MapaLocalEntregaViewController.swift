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
      
      var longitude = ""
      var latitude = ""
      var telemovel = ""
      var referencia = ""
    var tipoPagamento = ""
    var estabelecimentoId = 0
     var vv = ""
    var endereco1 = ""
    var verifica = true
    
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(produtoCompra)
        mostrarPopUpInternet()
           
        mapa.delegate = self
        mapa.showsUserLocation = true
        mapa.userTrackingMode = .follow
               
               enableLocationServices()
               handleRequesteLocation()
               
              let looCoord = CLLocationCoordinate2D(latitude: 25.123, longitude: 55.123)
               let annotation = MKPointAnnotation()
               annotation.coordinate = looCoord
               annotation.title = "My Location"
               annotation.subtitle = "Location of store"
               mapa.addAnnotation(annotation)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(telemovel)
        print(referencia)
        mostrarPopUpInternet()
       
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
                      
                      let annotation = MKPointAnnotation()
                      annotation.coordinate = looCoord
                      annotation.title = "Localização entrega"
                      annotation.subtitle = "Location of store"
                      //localizacaoEntrega.addAnnotation(annotation)
                      latitude = ("\(looCoord.latitude)")
                      longitude = ("\(looCoord.longitude)")
       
                      print("Lat: \(latitude), Long: \(longitude)")
                      mapa.removeAnnotations(mapa.annotations)
                      mapa.addAnnotation(annotation)
                     print(vv)
                      print(telemovel)
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
    
    @IBAction func buttonMinhaLocalizacao(_ sender: UIButton) {
        print(verifica)
        if verifica == true {
            if latitudeM == 0.0 && longitudeM == 0.0 {
                showToast(controller: self, message:  "Não foi possivel pegar a localização!", seconds: 3)
                
            } else {
                latitude = ("\(latitudeM)")
                longitude = ("\(longitudeM)")
                mostrarEndereco(latitude: Double("\(latitude)")!, withLongitude: Double("\(longitude)")!)
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
                  // print("Got Location \(locations.coordinate.latitude) , \(locations.coordinate.longitude)")
            
                    let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
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

