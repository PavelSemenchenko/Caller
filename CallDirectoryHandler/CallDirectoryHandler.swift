//
//  CallDirectoryHandler.swift
//  CallDirectoryHandler
//
//  Created by Pavel Semenchenko on 09.02.2025.
//
import Foundation
import CallKit

struct Contact: Codable {
    var id: UUID
    var phoneNumber: Int64
    var label: String
}

final class CallDirectoryHandler: CXCallDirectoryProvider {
    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        // Назначаем делегата для обработки событий обновления
        context.delegate = self
        
        // Добавляем номера для идентификации, считывая данные из общего хранилища
        addIdentificationPhoneNumbers(to: context)
        
        // Завершаем запрос
        context.completeRequest()
    }
    
    /// Функция добавления номеров с метками из общего хранилища.
    func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        let appGroupID = "leksovich.Caller.CallDirectoryHandler" // ! надо сертификат Замените на ваш App Group ID
        let contactsKey = "contacts"
        var contacts: [(CXCallDirectoryPhoneNumber, String)] = []
        
        if let data = UserDefaults(suiteName: appGroupID)?.data(forKey: contactsKey),
           let savedContacts = try? JSONDecoder().decode([Contact].self, from: data) {
            contacts = savedContacts.map { ($0.phoneNumber, $0.label) }
        } else {
            NSLog("Нет сохранённых контактов. Используем дефолтные значения.")
            contacts = [
                (380937021096, "Agent"),
                (0688880168, "Pavlo")
            ]
        }
        
        // Сортировка контактов по номеру (обязательно!)
        contacts.sort { $0.0 < $1.0 }
        
        // Добавляем контакты в CallKit
        for (phoneNumber, label) in contacts {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
            NSLog("Добавлен номер: \(phoneNumber) - \(label)")
        }
    }
}

// Реализация делегата для обработки ошибок или успешного завершения
extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestCompleted(for extensionContext: CXCallDirectoryExtensionContext) {
        NSLog("✅ Call Directory Extension: Request completed")
    }
    
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        NSLog("❌ Call Directory Extension: Request failed with error: \(error.localizedDescription)")
    }
}
/*
final class CallDirectoryHandler: CXCallDirectoryProvider {
    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        // Назначаем делегата для обработки событий обновления
        context.delegate = self
        
        // Добавляем номера для идентификации
        addIdentificationPhoneNumbers(to: context)
        
        // Завершаем запрос
        context.completeRequest()
    }
    
    /// Функция добавления номеров с метками.
    func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Создаём список номеров и их меток
        var contacts: [(CXCallDirectoryPhoneNumber, String)] = [
            (380937021096, "Спам"),
            (380501234567, "Алексей Петров"),
            (380671234567, "Доставка еды"),
            (380931234567, "Техподдержка"),
            (380991234567, "Банк")
        ]
        
        // Отсортировать список по номеру в порядке возрастания
        contacts.sort { $0.0 < $1.0 }
        
        // Добавляем номера в CallKit
        for (phoneNumber, label) in contacts {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
            NSLog("Добавлен номер: \(phoneNumber) - \(label)")
        }
    }
}

// Реализация делегата для обработки ошибок или успешного завершения
extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestCompleted(for extensionContext: CXCallDirectoryExtensionContext) {
        // Запрос успешно завершён
        NSLog("✅ Call Directory Extension: Request completed")
    }
    
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // Обработка ошибки обновления
        NSLog("❌ Call Directory Extension: Request failed with error: \(error.localizedDescription)")
    }
}*/
