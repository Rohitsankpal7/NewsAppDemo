//
//  NewsDetailView.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 11/02/25.
//

import SwiftUI

struct NewsDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    let newsItem: NewsItems
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // News Header Image
                if let imageUrl = newsItem.urlToImage, let url = URL(string: imageUrl) {
                    GeometryReader { geometry in
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                PlaceholderView()
                                    .frame(width: geometry.size.width - 20)
                                    .frame(height: 250)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width)
                                    .frame(height: 250)
                                    .clipped()
                            case .failure, _:
                                PlaceholderView()
                                    .frame(width: geometry.size.width - 20)
                                    .frame(height: 250)
                            }
                        }
                    }
                    .frame(height: 250)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        Text(newsItem.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white : .primary)
                        
                        // Author and Date
                        HStack {
                            if let author = newsItem.author {
                                HStack(spacing: 4) {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundColor(.secondary)
                                    Text(author)
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if let date = newsItem.publishedAt {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.secondary)
                                    Text(date.longDateFormatted())
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        // Description
                        if let description = newsItem.description {
                            Text(description)
                                .font(.body)
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Content
                        if let content = newsItem.content {
                            Text(content)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Divider()
                        
                        // Source Link
                        if let url = newsItem.url {
                            Link(destination: URL(string: url)!) {
                                HStack {
                                    Text("Read Full Article")
                                        .font(.headline)
                                    Image(systemName: "arrow.right.circle.fill")
                                }
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if let url = newsItem.url {
                        shareNews(url: url)
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
    
    private func shareNews(url: String) {
        guard let urlShare = URL(string: url) else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// Preview provider
#Preview {
    NavigationView {
        NewsDetailView(newsItem: NewsItems(
            source: Source(id: "1", name: "Test News"),
            author: "Rohit Sankpal",
            title: "U.S. Steel Activist Wants a New CEO. That’s Not Why the Stock Is Rising. - Barron's",
            description: "The financial watchdog agency was formed after a 2008 crisis.",
            url: "https://example.com",
            urlToImage: nil,
            publishedAt: Date(),
            content: "This is the full content of the article that contains more detailed information about the news story."
        ))
    }
}
