//
//  QuoteListView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-07-17.
//
// "Third time's the charm, right?"
// - Some idiot, 2024

import SwiftUI
import SwiftData

struct QuoteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dbStatus: DBStatus
    @State var selection: Quote?
    @State var quotes: [Quote]
    @State var isLoading: Bool = false
    @State var quoteCount: Int = 0
    @State var fullView: Bool
    @State var masterModelIDList: [PersistentIdentifier] = []
    private var darkCard = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    private var lightCard = #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
    @State var showSettings: Bool = false
    @State var authorMode: Bool
    @State var favMode: Bool
    var authorPersistentID: PersistentIdentifier? = nil
    
    init(authorMode: Bool) {
        self.authorMode = authorMode
        self.quotes = []
        self.favMode = false
        fullView = authorMode
    }
    
    init(authorMode: Bool, favMode: Bool, quotes: [Quote]) {
        self.authorMode = authorMode
        self.quotes = quotes
        self.favMode = favMode
        fullView = authorMode
    }
    
    init(authorMode: Bool, quotes: [Quote], authorPersistentID: PersistentIdentifier) {
        self.authorMode = authorMode
        self.favMode = false
        self.quotes = quotes
        self.authorPersistentID = authorPersistentID
        fullView = authorMode
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(quotes) { quote in
                    NavigationLink {
                        QuoteView(
                            displayedQuote: quote,
                            isFaved: quote.isFavourite!).environmentObject(dbStatus)
                    } label: {
                        if (fullView) {
                            QuoteFullView(quoteFull: quote)
                        } else {
                            QuoteRowView(quoteRow: quote)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                                       RoundedRectangle(cornerRadius: 10)
                                           .background(.clear)
                                           .foregroundColor(colorScheme == .dark ? Color(darkCard) : Color(lightCard))
                                           .padding(
                                               EdgeInsets(
                                                   top: 4,
                                                   leading: 10,
                                                   bottom: 4,
                                                   trailing: 10
                                               )
                                           )
                                   )
                }
                .onDelete(perform: deleteQuotes)
                VStack {
                    Text("Showing \(quotes.count) of \(quoteCount)")
                    Button(action: {
                        loadMoreQuotes()
                        quoteCount = getQuoteCount(modelContext: modelContext)
                    }, label: {
                        Text("Load more quotes")
                    }).disabled(quotes.count >= quoteCount)
                }
                .listRowBackground(
                                   RoundedRectangle(cornerRadius: 10)
                                       .background(.clear)
                                       .foregroundColor(colorScheme == .dark ? Color(darkCard) : Color(lightCard))
                                       .padding(
                                           EdgeInsets(
                                               top: 4,
                                               leading: 10,
                                               bottom: 4,
                                               trailing: 10
                                           )
                                       )
                               )
            }
        }
            .onAppear {
                if masterModelIDList.isEmpty && !authorMode {
                    masterModelIDList = shuffledFetchList(modelContext: modelContext)
                }
                if !authorMode  && !favMode{
                    loadMoreQuotes()
                    quoteCount = getQuoteCount(modelContext: modelContext)
                } else {
                    quoteCount = quotes.count
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        self.fullView.toggle()
                    }, label: {
                        Image(systemName: fullView ? "list.bullet" : "rectangle.grid.1x2")
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle(authorMode ? "Quotes by \(quotes.first?.author?.name ?? "nil author")" : "Quotes")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadMoreQuotes() {
//        quotes = getQuotes(quoteArray: quotes, modelContext: modelContext)
        
        quotes = getQuotesByIDs(quoteArray: quotes, persistentIDs: masterModelIDList, modelContext: modelContext)
    }
    
    private func deleteQuotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(quotes[index])
            }
        }
    }
}

#Preview {
    QuoteListView(authorMode: false)
        .modelContainer(previewContainer).environmentObject(DBStatus())
}
