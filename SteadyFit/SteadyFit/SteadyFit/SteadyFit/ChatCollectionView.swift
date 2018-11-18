//
//  ChatCollectionView.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-17.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class ChatCollectionView: UICollectionView{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    override func touc(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(event)
//        self.superview?.endEditing(true)
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(event)
        self.superview?.endEditing(true)
    }
}
