//
//  AuthorListView.swift
//  Quotelic
//
//  Created by Max Williams on 2024-07-22.
//

import SwiftUI
import SwiftData

struct AuthorListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dbStatus: DBStatus
    @State var authors: [Author] = []
    var body: some View {
        NavigationStack {
            List {
                ForEach(authors) { author in
                    NavigationLink {
                        AuthorView(authorPersistentID: author.persistentModelID).environmentObject(dbStatus)
                    } label: {
                        Text("\(author.name ?? "nil text")")
                    }
                }
            }
            .onAppear {
                if authors.isEmpty {
                    authors = fetchAuthorList(modelContext: modelContext)
                }
            }
            .navigationTitle("Authors")
        }
        
    }
}

func fetchAuthorList(modelContext: ModelContext) -> [Author] {
    // Fetch an array of all PersistentIdentifiers,
    //  then shuffle the list,
    //  then use it to retrieve quotes in randomized order.
    var fetchDescriptor: FetchDescriptor<Author> {
        var fetchDescriptor = FetchDescriptor<Author>()
        // NOTE: Don't try to fetch the persistentModelID
        //  in the fetch descriptor. It's unnecessary and
        //  will result in nothing being fetched.
        fetchDescriptor.propertiesToFetch = [\.name]
        return fetchDescriptor
    }
    do {
        let authors = try modelContext.fetch(fetchDescriptor)
        return authors.sorted { $0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending }
    } catch {
        print(error)
        return []
    }
}

#Preview {
    AuthorListView()
        .modelContainer(previewContainer).environmentObject(DBStatus())
}
