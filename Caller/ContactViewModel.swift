//
//  ContactViewModel.swift
//  Caller
//
//  Created by Pavel Semenchenko on 09.02.2025.
//

import SwiftUI

// Модель контакта: хранит идентификатор, имя, номер, URL картинки и дополнительную информацию.
struct Contact: Identifiable, Codable {
    var id: Int
    var name: String
    var phoneNumber: String
    var imageURL: String?       // URL изображения (если есть)
    var additionalInfo: String? // Дополнительная информация, например, комментарии
}

// ViewModel для управления списком контактов и поиском.
class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var searchText: String = ""
    
    init() {
        loadContacts()
    }
    
    static func loadContacts() -> [Contact] {
        if let data = UserDefaults(suiteName: appGroupID)?.data(forKey: contactsKey),
           let contacts = try? JSONDecoder().decode([Contact].self, from: data) {
            return contacts
        }
        return [] // Если данных нет, возвращаем пустой список
    }
    
    static func saveContacts(_ contacts: [Contact]) {
        if let data = try? JSONEncoder().encode(contacts) {
            UserDefaults(suiteName: appGroupID)?.set(data, forKey: contactsKey)
        }
    }
}
/*
 // ViewModel для управления списком контактов и поиском.
 class ContactViewModel: ObservableObject {
 @Published var contacts: [Contact] = []
 @Published var searchText: String = ""
 
 init() {
 loadContacts()
 }
 
 // Функция загрузки контактов. В реальном приложении данные можно получать с сервера.
 func loadContacts() {
 // Для демонстрации создаём тестовые данные
 contacts = [
 Contact(id: 1, name: "Систер", phoneNumber: "380986762831", imageURL: nil, additionalInfo: "Дружеский контакт"),
 Contact(id: 2, name: "Колокольчиков", phoneNumber: "380669648871", imageURL: nil, additionalInfo: "Дружеский контакт"),
 Contact(id: 3, name: "Pavel", phoneNumber: "380688880168", imageURL: nil, additionalInfo: "Family"),
 Contact(id: 4, name: "Колокольчиков лайф", phoneNumber: "380937021096", imageURL: nil, additionalInfo: "Family")
 ]
 }
 
 // Фильтрация контактов по введённому поисковому запросу (имя или номер)
 var filteredContacts: [Contact] {
 if searchText.isEmpty {
 return contacts
 } else {
 return contacts.filter { contact in
 contact.name.lowercased().contains(searchText.lowercased()) ||
 contact.phoneNumber.contains(searchText)
 }
 }
 }
 }*/
