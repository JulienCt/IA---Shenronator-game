//
//  Personnage.swift
//  Shenronator
//
//  Created by Julien Catteau on 06/04/16.
//  Copyright © 2016 Julien Catteau. All rights reserved.
//

import Foundation

class Personnage {
    var id : String = ""
    var nom : String = ""
    
    init(JSONDictionary: NSDictionary) {
        if let idP = JSONDictionary["idPersonnage"] as? Int
        {
            if let name = JSONDictionary["nomPersonnage"] as? String
            {
                self.id = String(idP);
                self.nom = name;
            }
        }
    }
}