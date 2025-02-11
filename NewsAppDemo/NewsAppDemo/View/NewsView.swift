//
//  NewsView.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel: NewsViewModel
    
    init() {
        let networkService = NetworkService()
        _viewModel = StateObject(wrappedValue: NewsViewModel(newsServiceProtocol: networkService))
    }
    
    var body: some View {
        NavigationView {
            NewsListRow(viewModel: viewModel)
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchNews()
                    } catch {
                        print("failed to load data")
                    }
                }
            }
            .navigationTitle("Top Headlines")
        }
        .padding(15)
    }
}

#Preview {
    NewsView()
}
