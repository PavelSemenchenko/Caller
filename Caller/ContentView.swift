//
//  ContentView.swift
//  Caller
//
//  Created by Pavel Semenchenko on 09.02.2025.
//

import SwiftUI
import CallKit
/*
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
}*/
struct ContentView: View {
    @State private var contacts: [Contact] = []
    @State private var phoneNumberInput: String = ""
    @State private var labelInput: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Добавить контакт")) {
                        TextField("Номер телефона", text: $phoneNumberInput)
                            .keyboardType(.numberPad)
                        TextField("Метка", text: $labelInput)
                        Button("Добавить") {
                            addContact()
                        }
                    }
                    
                    Section(header: Text("Список контактов")) {
                        if contacts.isEmpty {
                            Text("Список контактов пуст")
                        } else {
                            List {
                                ForEach(contacts) { contact in
                                    VStack(alignment: .leading) {
                                        Text(contact.label)
                                            .font(.headline)
                                        Text(String(contact.phoneNumber))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .onDelete(perform: deleteContact)
                            }
                        }
                    }
                }
                .navigationTitle("Контакты")
                .onAppear(perform: loadContacts)
                
                Button(action: reloadCallDirectoryExtension) {
                    Text("Обновить Call Directory")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .alert(item: $errorMessage) { msg in
                Alert(title: Text("Ошибка"), message: Text(msg), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addContact() {
        guard let phone = Int64(phoneNumberInput.filter({ $0.isNumber })) else {
            errorMessage = "Неверный формат номера"
            return
        }
        
        let newContact = Contact(phoneNumber: phone, label: labelInput)
        contacts.append(newContact)
        ContactsStorage.saveContacts(contacts)
        phoneNumberInput = ""
        labelInput = ""
    }
    
    func deleteContact(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
        ContactsStorage.saveContacts(contacts)
    }
    
    func loadContacts() {
        contacts = ContactsStorage.loadContacts()
    }
    
    func reloadCallDirectoryExtension() {
        let manager = CXCallDirectoryManager.sharedInstance
        let extensionIdentifier = "leksovich.Caller.CallDirectoryHandler" // Замените на реальный идентификатор вашего расширения
        manager.reloadExtension(withIdentifier: extensionIdentifier) { error in
            if let error = error {
                errorMessage = "Ошибка обновления расширения: \(error.localizedDescription)"
            } else {
                NSLog("Расширение обновлено успешно")
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
#Preview {
    ContentView()
}


