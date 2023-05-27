//
//  PrimaryButtonStyle.swift
//  Fitness+
//
//  Created by Nghia Le on 11/5/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var fillColor: Color = .darkPrimaryButton
    func makeBody(configuration: Configuration) -> some View {
        return PrimaryButton(
            configuration: configuration,
            fillColor: fillColor
        )
    }
    
    struct PrimaryButton: View {
        let configuration: Configuration
        let fillColor: Color
        var body: some View {
            return configuration.label
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 8).fill(fillColor))
        }
    }
}

struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Tutorials")
        }.buttonStyle(PrimaryButtonStyle())
    }
}
