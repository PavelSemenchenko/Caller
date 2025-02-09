//
//  CallDirectoryHandler.swift
//  CallDirectoryHandler
//
//  Created by Pavel Semenchenko on 09.02.2025.
//
import Foundation
import CallKit

final class CallDirectoryHandler: CXCallDirectoryProvider {

    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        // Назначаем делегата для обработки событий обновления
        context.delegate = self
        
        // Добавляем номера для идентификации
        addIdentificationPhoneNumbers(to: context)
        
        // Завершаем запрос
        context.completeRequest()
    }
    
    
    // Функция добавления номеров с метками
    func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Создаём список номеров и их меток
        let contacts: [(CXCallDirectoryPhoneNumber, String)] = [
            (380937021096, "Спам"),
            (1987654321, "Иван Иванов"),
            (380501234567, "Алексей Петров"),
            (380671234567, "Доставка еды"),
            (380931234567, "Техподдержка"),
            (380991234567, "Банк")
        ]

        // Добавляем номера в CallKit
        for (phoneNumber, label) in contacts {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
            print("Добавлен номер: \(phoneNumber) - \(label)")
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
}
