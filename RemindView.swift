//
//  RemindView.swift
//  Fitness+
//
//  Created by Nghia Le on 18/5/2023.
//

import SwiftUI

struct RemindView: View {
    var body: some View {
        VStack {
//            DropdownView()
            Spacer()
            Button(action: {}) {
                Text("Finish")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
            }.padding(.bottom, 15)
        }.navigationTitle("Tutorials Start")
    }
}

struct RemindView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RemindView()
        }
    }
}
