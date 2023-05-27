//
//  CreateReps.swift
//  Fitness+
//
//  Created by Nghia Le on 19/5/2023.
//

import SwiftUI

final class CreateReps: ObservableObject {
    @Published var dropdowns: [RepsPartViewModel] = [
        .init(type: .exercise),
        .init(type: .startAmount),
        .init(type: .increase),
        .init(type: .length),
    ]
    enum Action {
        case selectOption(index: Int)
    }
    
    var hasSelectedDropdown: Bool {
        selectedDropdownIndex != nil
    }
    
    var selectedDropdownIndex: Int? {
        dropdowns.enumerated().first(where: { $0.element.isSelected})?.offset
    }
    
    var displayedOptions: [DropdownOption] {
        guard let selectedDropdownIndex = selectedDropdownIndex else { return []}
        return dropdowns[selectedDropdownIndex].options
    }
    
    func send(action: Action) {
        switch action {
        case let .selectOption(index):
            guard let selectedDropdownIndex = selectedDropdownIndex else { return }
            clearSelectedOptions()
            dropdowns[selectedDropdownIndex].options[index].isSelected = true
            clearSelectedDropdown()
        }
    }
    
    func clearSelectedOptions() {
        guard let selectedDropdownIndex = selectedDropdownIndex else { return }
        dropdowns[selectedDropdownIndex].options.indices.forEach { index in
            dropdowns[selectedDropdownIndex].options[index].isSelected = false
        }
    }
    
    func clearSelectedDropdown() {
        guard let selectedDropdownIndex = selectedDropdownIndex else { return }
        dropdowns[selectedDropdownIndex].isSelected = false
        }
    }


extension CreateReps {
    struct RepsPartViewModel: DropdownItemProtocol {
        var options: [DropdownOption]
        
        var headerTitle: String {
            type.rawValue
        }
        
        var dropdownTitle: String {
            options.first(where: {$0.isSelected})?.formatted ?? ""
        }
        
        var isSelected: Bool = false
        private let type: RepsPartType
        
        init(type: RepsPartType) {
            
            switch type {
            case .exercise:
                self.options = ExerciseOption.allCases.map { $0.toDropdownOption }
            case .startAmount:
                self.options = StartOption.allCases.map { $0.toDropdownOption }
            case .increase:
                self.options = IncreaseOption.allCases.map { $0.toDropdownOption }
            case .length:
                self.options = LengthOption.allCases.map { $0.toDropdownOption }
            }
            self.type = type
        }
        
        enum RepsPartType: String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Sets per time"
            case increase = "Sets per day"
            case length = "Challenge Length"
        }
        
        enum ExerciseOption: String, CaseIterable, DropdownOptionProtocol {
            case pullUps
            case pushUps
            case Skipping
            
            var toDropdownOption: DropdownOption {
                .init(type: .text(rawValue),
                      formatted: (rawValue).capitalized,
                      isSelected: self == .pullUps
                )
            }
        }
        
        enum StartOption:Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue),
                      formatted: "\(rawValue)",
                      isSelected: self == .one
                )
            }
        }
        
        enum IncreaseOption:Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue),
                      formatted: "\(rawValue)",
                      isSelected: self == .one
                )
            }
        }
        
        enum LengthOption:Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, fourteen = 14, twentyone = 21, twentyEight = 28
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue),
                      formatted: "\(rawValue) days",
                      isSelected: self == .seven
                )
            }
        }
    }
}
