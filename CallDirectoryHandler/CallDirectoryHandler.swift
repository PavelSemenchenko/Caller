//
//  CallDirectoryHandler.swift
//  CallDirectoryHandler
//
//  Created by Pavel Semenchenko on 09.02.2025.
//
import Foundation
import CallKit



@objcMembers
class CallDirectoryHandler: CXCallDirectoryProvider, CXCallDirectoryExtensionContextDelegate {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        // Назначаем делегата для получения обратной связи об обновлении
        context.delegate = self
        
        // Для полного обновления (isIncremental == false) вызов removeAllIdentificationEntries не требуется
        // (и не поддерживается), поэтому его нужно убрать.
        
        // Задаём список номеров в формате Int64 (CXCallDirectoryPhoneNumber)
        // Номера должны идти по возрастанию:
        // Преобразования: "0688880168" -> 380688880168, "0955555555" -> 380955555555
        let phoneNumbers: [CXCallDirectoryPhoneNumber] = [
            380688880168,
            380955555555
        ]
        
        // Единая подпись для всех номеров
        let label = "Есть в базе агентов"
        
        // Добавляем каждый номер с заданной подписью
        for number in phoneNumbers {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: number, label: label)
        }
        
        // Завершаем запрос обновления базы номеров
        do {
            try context.completeRequest()
            NSLog("✅ Call Directory обновлено успешно")
        } catch {
            NSLog("❌ Ошибка завершения запроса: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CXCallDirectoryExtensionContextDelegate
    
    func requestCompleted(for extensionContext: CXCallDirectoryExtensionContext) {
        NSLog("✅ Delegate: Запрос обновления завершён успешно")
    }
    
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        NSLog("❌ Delegate: Ошибка обновления: \(error.localizedDescription)")
    }
}

/*
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
        var contacts: [(CXCallDirectoryPhoneNumber, String)] = [(380937021096, "Agent"),
                                                                (0688880168, "Pavlo")]
        
        if let data = UserDefaults(suiteName: appGroupID)?.data(forKey: contactsKey),
           let savedContacts = try? JSONDecoder().decode([Contact].self, from: data) {
            contacts = savedContacts.map { ($0.phoneNumber, $0.label) }
        } else {
            NSLog("Нет сохранённых контактов. Используем дефолтные значения.")
            contacts = [
                (380937021096, "Мои"),
                (0688880168, "Свои")
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
*/
