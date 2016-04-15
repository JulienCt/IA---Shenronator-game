//
//  UiViewExtension.swift
//  Shenronator
//
//  Created by Julien Catteau on 08/04/16.
//  Copyright © 2016 Julien Catteau. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBackground(nameImg: String) {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: nameImg)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}