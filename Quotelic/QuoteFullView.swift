//
//  QuoteFullView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-06-29.
//

import SwiftUI
import SwiftData

struct QuoteFullView: View {
    var quoteFull: Quote
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("\(quoteFull.author?.name ?? "nil text")").font(.headline)
                    .lineLimit(1)
                    .padding(.bottom, 1.0)
                Text("\(quoteFull.quote ?? "nil text")")
        }
    
    }
}

#Preview {
    QuoteFullView(quoteFull: fetchQuotesByPredicate(predicate: MenuView.favPredicate(), modelContext: previewContainer.mainContext).first!).modelContainer(previewContainer).environmentObject(DBStatus())
}
