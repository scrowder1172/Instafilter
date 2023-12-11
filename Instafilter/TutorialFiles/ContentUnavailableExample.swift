//
//  ContentUnavailableExample.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/11/23.
//

import SwiftUI

struct ContentUnavailableExample: View {
    var body: some View {
        TabView {
            ViewOne()
                .tabItem {
                    Label("View1", systemImage: "swift")
                }
            ViewTwo()
                .tabItem {
                    Label("View2", systemImage: "square.and.pencil.circle.fill")
                }
        }
    }
}

struct ViewOne: View {
    var body: some View {
        ContentUnavailableView("No data provided", systemImage: "swift", description: Text("You haven't provided data!"))
    }
}

struct ViewTwo: View {
    var body: some View {
        ContentUnavailableView {
            Label("Data Required", systemImage: "square.and.pencil.circle.fill")
        } description: {
            Text("Please provide data")
        } actions: {
            Button("Load Data") {
                // load some data
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentUnavailableExample()
}
