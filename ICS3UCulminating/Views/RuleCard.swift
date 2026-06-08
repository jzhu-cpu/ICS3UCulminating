//
//  RuleCard.swift
//  ICS3UCulminating
//
//  Created by Judy Z on 2026/6/8.
//


import SwiftUI

struct RuleCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            // THE ICON BOX: We use a ZStack to place the icon on top of our Hexagon shape
            ZStack {
                Hexagon()
                    .fill(color.opacity(0.2)) // Subtle tinted background
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
            }
            
            // THE TEXT BOX
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    // Allows the text to grow vertically if the description is long
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            // Matching colored border for the card
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}