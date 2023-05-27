//
//  ContentView.swift
//  Fitness+
//
//  Created by Nghia Le on 10/5/2023.
//

import SwiftUI

struct LandingView: View {
    @State private var isActive = false
    var body: some View {
        NavigationView {
            
            GeometryReader { proxy in
                VStack {
                    Spacer().frame(height: proxy.size.height * 0.25)
                    Text("Fitness+")
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: CreateView(), isActive: $isActive) {
                        Button(action: {
                            isActive = true
                        }) {
                            HStack(spacing: 15) {
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Tutorials")
                                    .font(.system(size: 24, weight: .semibold
                                                 ))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }.padding(.horizontal, 15)
                            .buttonStyle(PrimaryButtonStyle())
                    }
                }.frame(maxWidth: .infinity,
                        maxHeight: .infinity
                )
                .background(
                    Image("fitness 2")
                        .resizable()
                        .aspectRatio(contentMode: .fill).overlay(Color.black.opacity(0.4))
                        .frame(width: proxy.size.width)
                ).edgesIgnoringSafeArea(.all)
            }
        }.accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView().previewDevice("iphone 8")
        LandingView().previewDevice("iphone 11 Pro")
        LandingView().previewDevice("iphone 11 Pro Max")
    }
}
