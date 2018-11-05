//
//  Message.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class Message: NSObject{
    var fromID: String?
    var text: String?
    var toID: String?
    var timeStamp: NSNumber?
}

//import MessageKit
//
//struct Member {
//    let name: String
//    let color: UIColor
//}
//
//struct Message {
//    let member: Member
//    let text: String
//    let messageId: String
//}
////
//extension Message: MessageType {
//    var sender: Sender {
//        return Sender(id: member.name, displayName: member.name)
//    }
//
//    var sentDate: Date {
//        return Date()
//    }
//
//    var kind: MessageKind {
//        return .text(text)
//    }
//}
//
//extension Member {
//    var toJSON: Any {
//        return ["name": name, "color": color.hexString]
//    }
//
//    init?(fromJSON json: Any) {
//        guard
//            let data = json as? [String: Any],
//            let name = data["name"] as? String,
//            let hexColor = data["color"] as? String
//            else {
//                print("Couldn't parse Member")
//                return nil
//        }
//        self.name = name
//        self.color = UIColor(hex: hexColor)
//    }
//}
