//
//  ProfileRow.swift
//  PlatziStore
//
//  Created by mac on 27/05/25.
//

import SwiftUI

struct ProfileRow<Destination: View>: View {
    let title: String
    let systemImage: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: Icons.chevronRight.description)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 14)
            .padding(.horizontal)
        }
        .background(Color.clear)
    }
}
