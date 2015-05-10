//
//  Guiaturismo.swift
//  KMGuiaTur
//
//  Created by Kaue Mendes on 4/25/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import Foundation
import CoreData

class Guiaturismo: NSManagedObject {

    @NSManaged var endereco: String
    @NSManaged var lat: NSNumber
    @NSManaged var lng: NSNumber
    @NSManaged var nome: String
    @NSManaged var isFavorito: NSNumber

}
