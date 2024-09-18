//
//  MenuView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-09-17.
//

// DBStatus member 'storeUpdated' is simply used as a trigger to update adjacent views after a new quote is added.
class DBStatus: ObservableObject {
    @Published var storeUpdated: Bool = false
}

import SwiftUI
import SwiftData

struct MenuView: View {
    
    static func favPredicate() -> Predicate<Quote> {
        return #Predicate<Quote> { $0.isFavourite == true }
    }
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var dbStatus = DBStatus()
    @EnvironmentObject var dbStatusSelf: DBStatus
    @State var isAddingNewQuote: Bool = false
    @State private var quoteAuthor: String = ""
    @State private var quoteContent: String = ""
    @State private var newQuote = Quote(author: Author())
    @State var searchString: String = ""
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    QuoteListView(authorMode: false).environmentObject(dbStatus)
                } label: {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("Scroll random quotes")
                    }
                }
                NavigationLink {
                    AuthorListView().environmentObject(dbStatus)
                } label: {
                    HStack {
                        Image(systemName: "person")
                        Text("Authors")
                    }
                }
                NavigationLink {
                    QuoteListView(authorMode: false, favMode: true, quotes: fetchQuotesByPredicate(predicate: MenuView.favPredicate(), modelContext: modelContext)).environmentObject(dbStatus)
                } label: {
                    HStack {
                        Image(systemName: "heart")
                        Text("Favourites")
                    }
                }
                Button {
                    self.isAddingNewQuote.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add a new quote")
                    }
                }
            }
            .navigationTitle("Quotelic: Mindful scrolling")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchString)
        .sheet(isPresented: $isAddingNewQuote) {
            NavigationStack {
                QuoteEditor(qAuthor: $quoteAuthor, qContent: $quoteContent)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                let validAuthor = validateAuthor(authorName: quoteAuthor, modelContext: modelContext)
                                newQuote = Quote(quote: quoteContent, author: validAuthor, isFavourite: true)
                                modelContext.insert(newQuote)
                                try? modelContext.save()
                                quoteAuthor = ""
                                quoteContent = ""
                                isAddingNewQuote = false
                            }, label: {
                                Text("Add")
                            })
                            .disabled(self.quoteContent.isEmpty)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: {
                                quoteAuthor = ""
                                quoteContent = ""
                                isAddingNewQuote = false
                            }, label: {
                                Text("Cancel")
                            })
                        }
                    }
            }
        }
    }
}




func getQuoteCount(modelContext: ModelContext) -> Int {
    do {
        let count = try modelContext.fetchCount(FetchDescriptor<Quote>())
        return count
    } catch {
        print(error)
        return 0
    }
}

func getQuotesByIDs(quoteArray: [Quote], persistentIDs: [PersistentIdentifier], modelContext: ModelContext) -> [Quote] {
    var quotes: [Quote] = quoteArray
    let fetchOffset = quoteArray.count
    for modelID in persistentIDs[fetchOffset...fetchOffset+19] {
        quotes.append(modelContext.model(for: modelID) as! Quote)
    }
    return quotes
}

func shuffledFetchList(modelContext: ModelContext) -> [PersistentIdentifier] {
    // Fetch an array of all PersistentIdentifiers,
    //  then shuffle the list,
    //  then use it to retrieve quotes
    //  in randomized order.
    var persistentIDs: [PersistentIdentifier] = []
    var fetchDescriptor: FetchDescriptor<Quote> {
        var fetchDescriptor = FetchDescriptor<Quote>()
        fetchDescriptor.propertiesToFetch = []
        return fetchDescriptor
    }
    do {
        let models = try modelContext.fetch(fetchDescriptor)
        for model in models {
            persistentIDs.append(model.id)
        }
        return persistentIDs.shuffled()
    } catch {
        print(error)
        return []
    }
}



func fetchQuotesByPredicate(predicate: Predicate<Quote>, modelContext: ModelContext) -> [Quote] {
    let descriptor = FetchDescriptor<Quote>(
        predicate: predicate
    )
    do {
        let favQuotes = try modelContext.fetch(descriptor)
        return favQuotes
    } catch {
        print("Error: couldn't fetch favourites")
        return []
    }
}

@MainActor
let previewContainer: ModelContainer = {
    var container: ModelContainer
    do {
        guard let storeURL = Bundle.main.url(forResource: "quotes-v2", withExtension: "store") else {
            fatalError("Failed to find quotes-v2.store")
        }
        let config = ModelConfiguration(url: storeURL)
        let schema = Schema([
            Quote.self,
            Author.self,
            Tag.self,
        ])
        container = try ModelContainer(for: schema, configurations: config)
    } catch {
        fatalError("Failed to create Model Container")
    }
    return container
}()

#Preview {
    MenuView(dbStatus: DBStatus())
        .modelContainer(previewContainer).environmentObject(DBStatus())
}



