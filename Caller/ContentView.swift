//
//  ContentView.swift
//  Caller
//
//  Created by Pavel Semenchenko on 09.02.2025.
//

import SwiftUI
import CallKit

struct ContentView: View {
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Поле поиска
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                // Список контактов
                List(viewModel.filteredContacts) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                        HStack {
                            // ✅ Исправленный AsyncImage
                            if let imageURL = contact.imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else if phase.error != nil {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    } else {
                                        ProgressView()
                                    }
                                }
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // Кнопка обновления базы CallKit
                Button(action: {
                    reloadCallDirectory()
                }) {
                    Text("Обновить базу номеров")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .navigationTitle("Caller ID")
            .onAppear {
                reloadCallDirectory()
            }
        }
    }
    
    // Функция обновления базы CallKit
    func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.yourapp.CallDirectoryExtension", completionHandler: { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("⚠ Ошибка обновления CallKit: \(error.localizedDescription)")
                } else {
                    print("✅ База номеров успешно обновлена!")
                }
            }
        })
    }
}

#Preview {
    ContentView()
}


#Preview {
    ContentView()
}
