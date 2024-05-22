//
//  PipeLineViewModel.swift
//  CombineTasksUIKit
//
//  Created by Anastasiya Omak on 20/05/2024.
//

import Foundation

class PipeLineViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var validatorName: String? = ""
    @Published var validatorSurname: String? = ""
    
    init() {
        $name
            .map { $0.isEmpty ? "❌" : "✅"}
            .assign(to: &$validatorName)
        $surname
            .map { $0.isEmpty  ? "❌" : "✅"}
            .assign(to: &$validatorSurname)
    }
}
