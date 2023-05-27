//
//  CreateView.swift
//  Fitness+
//
//  Created by Nghia Le on 17/5/2023.
//

import SwiftUI
import AVKit

struct CreateView: View {
    @StateObject var viewModel = CreateReps()
    @State private var isActive = false
    
    var dropdownList: some View {
        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
            DropdownView(viewModel: $viewModel.dropdowns[index])
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                dropdownList
                Spacer()
                NavigationLink(destination: RemindView(), isActive: $isActive) {
                    Button(action: {
                        isActive = true
                    }) {
                        Text("Start").font(.system(size: 24, weight: .medium))
                    }
                }
            }
            .actionSheet(isPresented: Binding<Bool>(get: {
                viewModel.hasSelectedDropdown
            }, set: { _ in }), content: { () -> ActionSheet in
                ActionSheet(title: Text("Select"),
                            buttons: viewModel.displayedOptions.indices.map { index in
                    let option = viewModel.displayedOptions[index]
                    return ActionSheet.Button.default(Text(option.formatted)) {
                        viewModel.send(action: .selectOption(index: index))
                    }
                })
            })
            .navigationBarTitle("Fat Burning")
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, 15)
        }
    }
}
