//
//  SearchBar.swift
//  Caller
//
//  Created by Pavel Semenchenko on 09.02.2025.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    // Координатор для обработки событий UISearchBarDelegate
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }
        
        // Вызывается при изменении текста в строке поиска
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        // При нажатии на кнопку «Поиск» закрываем клавиатуру
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Поиск по имени или номеру"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
