//
//  NewsListRow.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 11/02/25.
//

import SwiftUI
// Seperate row for List
struct NewsListRow: View {
    @Environment(\.colorScheme) var colorScheme // Add this to detect dark mode
    
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.news) { item in
                    HStack(alignment: .center, spacing: 12) {
                        // Content on left side
                        VStack(alignment: .leading, spacing: 8) {
                            if let author = item.author {
                                Text(author)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(item.title)
                                .font(.system(size: 15, weight: .semibold))
                                .lineSpacing(4)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                            
                            if let date = item.publishedAt {
                                Text(date.longDateFormatted())
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.leading, 16)
                        
                        Spacer(minLength: 0)
                        
                        // Image on right side
                        ZStack(alignment: .center) {
                            if let imageUrl = item.urlToImage, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        PlaceholderView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    case .failure, _:
                                        PlaceholderView()
                                    }
                                }
                            } else {
                                PlaceholderView()
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing, 16)
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .cornerRadius(12)
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1), 
                           radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
    }
}
