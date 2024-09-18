//
//  Tag.swift
//  Quotelic
//
//  Created by Max Williams on 2024-07-22.
//

import Foundation
import SwiftData
import SwiftUI

//@Model
//final class Tag {
//    var id: UUID
//    var name: String
//    @Relationship(inverse: \Quote.var quotes: [Quote]
//    
//    init(id: UUID = UUID(), name: String = "sample-tag", quotes: [Quote] = []) {
//        self.id = id
//        self.name = name
//        self.quotes = quotes
//    }
//}

@Model public class Tag {
    public var id: UUID?
    var name: String?
    var quotes: [Quote]?
//    public init() {
//
//    }
    
    init(id: UUID = UUID(), name: String = "sample-tag", quotes: [Quote] = []) {
        self.id = id
        self.name = name
        self.quotes = quotes
    }
    
}
