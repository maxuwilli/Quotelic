//
//  QuotelicApp.swift
//  Quotelic
//
//  Created by Max Williams on 2024-05-15.
//

import SwiftUI
import SwiftData





@main
struct QuotelicApp: App {
    
    var container: ModelContainer
    
    
    
//    init() {
//            do {
//                guard let storeURL = Bundle.main.url(forResource: "quotes", withExtension: "store") else {
//                    fatalError("Failed to find quotes.store")
//                }
//                print("Found quote database...")
//                let schema = Schema([
//                    Quote.self,
//                ])
//                let config = ModelConfiguration(url: storeURL)
//                print("Creating ModelContainer...")
//                container = try ModelContainer(for: schema, configurations: config)
//            } catch {
//                fatalError("Failed to create model container: \(error)")
//            }
//        }
    
    // This might fix the loadissuemodelcontainer
    init() {
        do {
            guard let bundleURL = Bundle.main.url(forResource: "quotes-v2", withExtension: "store") else {
                fatalError("Failed to find quotes-v2.store in app bundle")
            }
            
            let fileManager = FileManager.default
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentURL = documentDirectoryURL.appendingPathComponent("quotes-v4.store")
            // Additional logging to verify paths
            print("Bundle URL: \(bundleURL)")
            print("Document URL: \(documentURL)")
            
            // Remove any pre-existing stores with outdated attributes
            if fileManager.fileExists(atPath: documentURL.path) {
                try fileManager.removeItem(atPath: documentURL.path)
            }
            // Only copy the store from the bundle to the Documents directory if it doesn't exist
            if !fileManager.fileExists(atPath: documentURL.path) {
                try fileManager.copyItem(at: bundleURL, to: documentURL)
            }
            
            let schema = Schema([
                Quote.self,
                Author.self,
                Tag.self,
            ])
            
           
            
            let configuration = ModelConfiguration(schema: schema, url: documentURL)
            self.container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Quote.self,
//        ])
//        let storeURL = URL.documentsDirectory.appending(path: "theQuotesDatabase.sqlite")
//        let modelConfiguration = ModelConfiguration(url: storeURL)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    

    
}

