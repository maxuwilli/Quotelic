//
//  QuoteRowView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-06-29.
//

import SwiftUI
import SwiftData

struct QuoteRowView: View {
    @Environment(\.modelContext) private var modelContext
    var quoteRow: Quote
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(quoteRow.author?.name ?? "nil text")").font(.headline)
                .lineLimit(1)
                .padding(.bottom, 1.0)
            Text("\(quoteRow.quote ?? "nil text")")
                .lineLimit(1)
        }
        
    }
}

#Preview {
    QuoteRowView(quoteRow: Quote(author: Author())).environmentObject(DBStatus())
}
