//
//  Author.swift
//  Quotelic
//
//  Created by Max Williams on 2024-07-22.
//

import Foundation
import SwiftData
import SwiftUI

//@Model
//final class Author {
//    var id: UUID
//    var name: String
//    var quotes: [Quote]
//    
//    init(id: UUID = UUID(), name: String = "Sample name", quotes: [Quote] = []) {
//        self.id = id
//        self.name = name
//        self.quotes = quotes
//    }
//}

@Model public class Author {
    public var id: UUID?
    var name: String?
    @Relationship(inverse: \Quote.author) var quotes: [Quote]?
//    public init() {
//
//    }
    
    init(id: UUID = UUID(), name: String = "Sample name", quotes: [Quote] = []) {
        self.id = id
        self.name = name
//        self.quotes = quotes
    }
    
}
