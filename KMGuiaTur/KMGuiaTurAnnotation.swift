//
//  KMGuiaTurAnnotation.swift
//  KMGuiaTur
//
//  Created by Kaue Mendes on 4/25/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//


import UIKit
import MapKit

class KMGuiaTurAnnotation: NSObject {
   
    @objc var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var guia : Guiaturismo!
    
    init(coordinate: CLLocationCoordinate2D, guia : Guiaturismo) {
        self.title = guia.nome
        self.subtitle = guia.endereco
        self.coordinate = coordinate
        self.guia = guia
    }
    
    func getFavoritoImage() -> UIImage {
     
        if ( guia.isFavorito.boolValue ){
            return UIImage(named: "simplePin")!
        } else {
            return UIImage(named: "favPin")!
        }
        
    }
    
}
