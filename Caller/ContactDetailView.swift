//
//  ContactDetailView.swift
//  Caller
//
//  Created by Pavel Semenchenko on 09.02.2025.
//

import SwiftUI

struct ContactDetailView: View {
    var contact: Contact
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Отображение изображения контакта, если есть
            if let imageURL = contact.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }
            
            Text(contact.name)
                .font(.title)
                .padding(.top)
            Text(contact.phoneNumber)
                .font(.headline)
            if let info = contact.additionalInfo {
                Text(info)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Детали контакта")
    }
}
