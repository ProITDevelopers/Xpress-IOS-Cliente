//
//  MenuTableViewCell.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/22/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON


class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var ButtonVertudo: UIButton!
    @IBOutlet weak var colectionViewEstabelecimento: UICollectionView!
    
    var estabelecimentos = [Estabelecimento]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        obterEstabelecimentos()
        print(estabelecimentos)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func obterEstabelecimentos() {
            
           
           
            
         let URL = "http://ec2-18-188-197-193.us-east-2.compute.amazonaws.com:8083/ListarEstabPorTipo/1"
         
            Alamofire.request(URL, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"] ).responseString { response in
                  
                  if response.result.isSuccess{
                      
                      let estacionamentoJSON = JSON(response.data!)
                      print(estacionamentoJSON)
                      self.estabelecimentos.removeAll()
                      
                      do {
                          let jsonDecoder = JSONDecoder()
                          self.estabelecimentos = try jsonDecoder.decode([Estabelecimento].self, from: response.data!)
                        print(response.response?.statusCode as Any)
                        print("veja a lista")
                      
                         
                        if self.estabelecimentos.count == 0 {
                            print("Não tem estabelecimentos ativos!")
                        }
                       //  print(self.estabelecimentos[0])
                          
                      } catch {
                          print("erro inesperado: \(error)")
                      }
                    
                  } else {
                    print("Erro verifica por favor.")
                    print(response.response?.statusCode as Any)
                    print(response.debugDescription)
                      print(response.result)
                  }
              }
           
            

            
        }
     


}

extension MenuTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return estabelecimentos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "estabelecimentoCell", for: indexPath) as! Estabelecimento1CollectionViewCell
         cell.backgroundColor = UIColor.cyan
        //  cell.imgEstabelecimento.sd_setImage(with: URL(string: estabelecimentos[indexPath.row].logotipo ?? ""), placeholderImage: UIImage(named: "logo1.phg"))
       
        
        return cell
    }
    
    
}

extension MenuTableViewCell : UICollectionViewDelegateFlowLayout {
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
