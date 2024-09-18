//
//  AuthorView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-07-22.
//

import SwiftUI
import SwiftData

struct AuthorView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dbStatus: DBStatus
//    @State var authors: [Author] = []
    @State var authorPersistentID: PersistentIdentifier
    var body: some View {
        QuoteListView(authorMode: true, quotes: fetchQuotesByAuthor(authorPersistentID: authorPersistentID, modelContext: modelContext), authorPersistentID: authorPersistentID).environmentObject(dbStatus)
//            .onAppear {
//                if quotes.isEmpty {
//                    quotes = fetchQuotesByAuthor(authorName: authorName, modelContext: modelContext)
//                }
//            }
    }
}

//func fetchQuotesByAuthor(authorPersistentID: PersistentIdentifier, modelContext: ModelContext) -> [Quote] {
//    var fetchDescriptor: FetchDescriptor<Quote> {
//        var descriptor = FetchDescriptor<Quote>(
//            predicate: #Predicate<Quote> { $0.author.contains(authorName) }
//        )
//        return descriptor
//    }
//    do {
//        let models = try modelContext.fetch(fetchDescriptor)
//        return models
//    } catch {
//        print(error)
//        return [Quote(quote: "error", author: Author(), user: false)]
//    }
//}

func fetchQuotesByAuthor(authorPersistentID: PersistentIdentifier, modelContext: ModelContext) -> [Quote] {
    var quotes: [Quote]
    var author: Author
    author = modelContext.model(for: authorPersistentID) as! Author
    quotes = author.quotes ?? []
    return quotes
}

#Preview {
    AuthorView(authorPersistentID: shuffledFetchList(modelContext: previewContainer.mainContext).first!)
        .modelContainer(previewContainer).environmentObject(DBStatus())
}
