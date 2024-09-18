//
//  StoreManage.swift
//  Quotelic
//
//  Created by Max Williams on 2024-09-13.
//

import Foundation
import SwiftUI
import SwiftData



// Retrieve a list of all Quotes
func getAllQuotes(quoteArray: [Quote], modelContext: ModelContext) -> [Quote] {
    var fetchDescriptor: FetchDescriptor<Quote> {
        var fetchDescriptor = FetchDescriptor<Quote>()
        fetchDescriptor.fetchOffset = quoteArray.count
        fetchDescriptor.fetchLimit = 20
        return fetchDescriptor
    }
    var newQuoteArray: [Quote] = quoteArray
    do {
        let quotes = try modelContext.fetch(fetchDescriptor)
        newQuoteArray.append(contentsOf: quotes)
    } catch {
        print(error)
    }
    return newQuoteArray
}

// Retrieve a list of all Authors
func getAllAuthors(authorArray: [Author], modelContext: ModelContext) -> [Author] {
    var fetchDescriptor: FetchDescriptor<Author> {
        let fetchDescriptor = FetchDescriptor<Author>()
        return fetchDescriptor
    }
    var newAuthorArray: [Author] = authorArray
    do {
        let quotes = try modelContext.fetch(fetchDescriptor)
        newAuthorArray.append(contentsOf: quotes)
    } catch {
        print(error)
    }
    return newAuthorArray
}

func getQuoteByID() -> Quote {
    // retrieve a Quote using its persistent ID
    return Quote(author: Author())
}

func getAuthorByID() -> Author {
    // retrieve an author by its persistent ID
    Author()
}

func getAuthorQuotesByID() -> [Quote] {
    // retrieve a list of all quotes by a specific author using the author's persistent ID
    return [Quote(author: Author())]
}

func getFavouriteQuotes() -> [Quote] {
    // retrieve a list of al favourited quotes
    return [Quote(author: Author())]
}

func insertNewQuote(quote: String, author: String = "Unknown") {
    // inserts a new quote into the store
}

func authorExists(authorName: String) -> Bool {
    // returns whether an author is already in the store
    return true
}

//func createAuthorSearchPredicate(searchTerm: String) -> Predicate<Author> {
//    return #Predicate<Author> { $0.name == searchTerm }
//}

// Takes authorName string and finds corresponding Author entity in the store, or creates a new one. Returns the existing or new Author entity.
func validateAuthor(authorName: String, modelContext: ModelContext) -> Author {
    var name: String
    if authorName.count == 0 {
        name = "Me"
    } else {
        name = authorName
    }
    let descriptor = FetchDescriptor<Author>(
        predicate: #Predicate<Author> { $0.name == name }
    )
    do {
        let foundAuthor = try modelContext.fetch(descriptor)
        if foundAuthor.isEmpty {
            let newAuthor = Author(name: name)
            modelContext.insert(newAuthor)
            try? modelContext.save()
            return newAuthor
        } else {
            return foundAuthor.first ?? Author(name: "Error")
        }
    } catch {
        print("Error: couldn't validate author by name.")
        return Author(name: "Error")
    }
}

