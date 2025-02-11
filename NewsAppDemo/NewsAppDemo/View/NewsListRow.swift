//
//  NewsListRow.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 11/02/25.
//

import SwiftUI
// Seperate row for List
struct NewsListRow: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.news) { item in
                    HStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            if let author = item.author {
                                Text(author)
                                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .frame(height: 15)
                            }
                            
                            Text(item.title)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(0.5)
                                .foregroundColor(.primary)
                            Spacer()
                            
                            if let date = item.publishedAt {
                                Text(date.longDateFormatted())
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        
                        if let imageUrl = item.urlToImage, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.gray)
                                        .padding()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image("placeholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .frame(height: 140)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
            }
        }
    }
}
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long // Sets the date style to "February 11, 2025"
    formatter.timeStyle = .none // Removes the time from the output
    return formatter
}()
