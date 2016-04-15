//
//  Question.swift
//  Shenronator
//
//  Created by Julien Catteau on 07/04/16.
//  Copyright © 2016 Julien Catteau. All rights reserved.
//

import Foundation
class Question {
    var id : String = ""
    var libelle : String = ""
    
    init(JSONDictionary: NSDictionary) {
        if let idQ = JSONDictionary["idQuestion"] as? Int
        {
            if let lib = JSONDictionary["libelleQuestion"] as? String
            {
                self.id = String(idQ);
                self.libelle = lib;
            }
        }
    }
}