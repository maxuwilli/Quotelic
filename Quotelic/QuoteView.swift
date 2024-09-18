//
//  QuoteView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-05-16.
//

import SwiftUI
import SwiftData


struct QuoteView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dbStatus: DBStatus
    var displayedQuote: Quote
    @State var isFaved: Bool
    var body: some View {
        VStack {
            Text("\(displayedQuote.quote ?? "nil text")")
                .padding()
            Text("\n- \(displayedQuote.author?.name ?? Author().name ?? "Unknown")").font(.headline)
                .padding()
            HStack {
                Button(action: {
                    self.isFaved.toggle()
                    if displayedQuote.isFavourite! {
                        displayedQuote.isFavourite = false
                    } else {
                        displayedQuote.isFavourite = true
                    }
                    try? modelContext.save()
                    dbStatus.storeUpdated.toggle()
                }) {
                    Image(systemName: isFaved ? "heart.fill" : "heart")
                        .imageScale(.large)
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    QuoteView(displayedQuote: Quote(author: Author()), isFaved: true).environmentObject(DBStatus())
}


