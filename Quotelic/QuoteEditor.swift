//
//  QuoteEditor.swift
//  Quotelic
//
//  Created by Max Williams on 2024-05-15.
//

import SwiftUI
import SwiftData

struct QuoteEditor: View {
    //@Binding var qAuthor: String
    //@Binding var qContent: String
    @Binding var qAuthor: String
    @Binding var qContent: String
    var body: some View {
        List {
            TextField("Write a quote here", text: $qContent)
            TextField("Author (Optional)", text: $qAuthor)
        }
    }
}

#Preview {
    QuoteEditor(qAuthor: .constant(String()), qContent: .constant(String()))
}
