//
//  Reponse.swift
//  Shenronator
//
//  Created by Julien Catteau on 14/04/16.
//  Copyright © 2016 Julien Catteau. All rights reserved.
//

import Foundation
import EVReflection

class Reponse : EVObject {
    var idQuestion : String
    var choix : String
    
    init(idQuestion: String, choix: String) {
        self.idQuestion = idQuestion;
        self.choix = choix;
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}