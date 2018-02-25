//
//  Message.swift
//  movie-database-lex-ios
//
//  Created by Morgan, Carter on 2/24/18.
//  Copyright © 2018 Carter Morgan Personal. All rights reserved.
//

import Foundation

struct Message{
    var content: String
    var userSent: Bool
    
    init(_ content: String, _ didUserSend: Bool){
        self.content = content
        self.userSent = didUserSend
    }
}
