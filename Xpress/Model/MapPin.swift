//
//  MapPin.swift
//  Xpress
//
//  Created by Adilson Ebo on 11/27/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import MapKit

class MapPin: NSObject, MKAnnotation {
   let title: String?
   let locationName: String
   let coordinate: CLLocationCoordinate2D
    
init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
      self.title = title
      self.locationName = locationName
      self.coordinate = coordinate
   }
}
