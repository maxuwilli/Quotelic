//
//  Quote.swift
//  Quotelic
//
//  Created by Max Williams on 2024-05-15.
//

import Foundation
import SwiftData
import SwiftUI

// Example of a decodable struct to use for JSON decoding
//struct BlogPost: Decodable {
//    enum Category: String, Decodable {
//        case swift, combine, debugging, xcode
//    }
//
//    let title: String
//    let url: URL
//    let category: Category
//    let views: Int
//}

//Original
//@Model
//final class Quote {
//    var quoteText: String
//    var author: String
//    
//    init() {
//        self.quoteText = "Sample quote"
//        self.author = "Sample author"
//    }
//    init(qText: String, qAuthor: String) {
//        self.quoteText = qText
//        self.author = qAuthor
//    }
//    func setQuoteText(text: String) {
//        self.quoteText = text
//    }
//    func setQuoteAuthor(author: String) {
//        self.author = author
//    }
//}

// Version without tags:
//@Model
//final class Quote {
//    var quote: String
//    var author: String
//    var tags: [String]
//    var userCreated: Bool
//    var isFavourite: Bool
//    
//    init() {
//        self.quote = "Sample quote"
//        self.author = "Sample author"
//        self.tags = []
//        self.userCreated = true
//        self.isFavourite = false
//    }
//    
//    
//    
//    init(qText: String, qAuthor: String, qTags: [String], user: Bool) {
//        self.quote = qText
//        self.author = qAuthor
//        self.tags = qTags
//        self.userCreated = user
//        self.isFavourite = false
//    }
//}

// Version with tags
//@Model
//final class Quote {
//    var id: UUID
//    var quote: String
//    var author: Author
//    var userCreated: Bool
//    var isFavourite: Bool
//    var tags: [Tag]
//    
//    init(id: UUID = UUID(), quote: String = "Sample quote", author: Author, userCreated: Bool = true, isFavourite: Bool = false, tags: [Tag] = []) {
//        self.id = id
//        self.quote = quote
//        self.author = author
//        self.userCreated = userCreated
//        self.isFavourite = isFavourite
//        self.tags = tags
//    }
//}

@Model public class Quote {
    public var id: UUID
    var isFavourite: Bool?
    var quote: String?
    var userCreated: Bool?
    var author: Author?
    @Relationship(inverse: \Tag.quotes) var tags: [Tag]?
//    public init(id: UUID) {
//        self.id = id
//
//    }
    
    init(id: UUID = UUID(), quote: String = "Sample quote", author: Author, userCreated: Bool = true, isFavourite: Bool = false, tags: [Tag] = []) {
        self.id = id
        self.quote = quote
        self.author = author
        self.userCreated = userCreated
        self.isFavourite = isFavourite
    }
    
}


