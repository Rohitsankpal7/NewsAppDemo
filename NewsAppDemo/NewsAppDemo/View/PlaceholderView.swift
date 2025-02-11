//
//  PlaceholderView.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 11/02/25.
//
import SwiftUI

struct PlaceholderView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray5))
            VStack(spacing: 6) {
                Image(systemName: "newspaper.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
                Text("No Image")
                    .font(.caption2)
                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
            }
        }
    }
}
