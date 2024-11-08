//
//  Home.swift
//  HeaderAnimation
//
//  Created by Kiet Truong on 01/11/2024.
//

import SwiftUI

struct AnimatedHeader_1: View {
    let COORDINATE_SPACE = "SCROLL"
    
    @State var offsetY: CGFloat = 0
    @State var showSearchBar: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            let safeAreaTop = proxy.safeAreaInsets.top

            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    Header(safeAreaTop)
                        .offset(y: -offsetY)
                        .zIndex(1)
                    
                    VStack {
                        ForEach(1...10, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue.gradient)
                                .frame(height: 200)
                        }
                    }
                    .padding(15)
                    .zIndex(0)
                }
                .offset(coordinateSpace: .named(COORDINATE_SPACE)) { value in
                    offsetY = value
                    showSearchBar = (-value > 80) && showSearchBar
                }
            }
            .coordinateSpace(name: COORDINATE_SPACE)
            .edgesIgnoringSafeArea(.top)
        }
    }

    @ViewBuilder
    private func Header(_ safeAreaTop: CGFloat) -> some View {
        let progress = calculateHeaderProgress(offsetY / 80)
        
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    
                    TextField("Search", text: .constant(""))
                        .tint(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.black)
                        .opacity(0.15)
                }
                .opacity(showSearchBar ? 1 : 1 + progress)

                Button {
                    print("Tap avatar")
                } label: {
                    Image("doge")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                }
                .opacity(showSearchBar ? 0 : 1)
                .overlay { // Display "x" button
                    if showSearchBar {
                        Button {
                            showSearchBar = false
                        } label: {
                            IconImage(name: "xmark")
                        }
                    }
                }
            }
            
            HStack(spacing: 0) {
                CustomButton(symbolName: "rectangle.portrait.and.arrow.forward", title: "Deposit") {
                        
                }
                
                CustomButton(symbolName: "dollarsign", title: "Withdraw") {
                        
                }
                
                CustomButton(symbolName: "qrcode", title: "QR Code") {
                        
                }
                
                CustomButton(symbolName: "qrcode.viewfinder", title: "Scanning") {
                        
                }
            }
            .padding(.horizontal, -progress * 50) // Shrink buttons bar
            .padding(.top, 10)
            .offset(y: progress * 65) // Move buttons up when scroll up
            .opacity(showSearchBar ? 0 : 1)
        }
        .overlay(alignment: .topLeading) { // Display search button when shrinked
            Button {
                showSearchBar = true
            } label: {
                IconImage(name: "magnifyingglass")
            }
            .offset(x: 13, y: 10)
            .opacity(showSearchBar ? 0 : -progress)
        }
        .animation(.easeInOut(duration: 0.2), value: showSearchBar)
        .environment(\.colorScheme, .dark)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, safeAreaTop)
        .background {
            Rectangle()
                .fill(.blue.gradient)
                .padding(.bottom, -progress * 85)
        }
    }
    
    @ViewBuilder
    private func CustomButton(symbolName: String,
                      title: String,
                      action: @escaping () -> Void) -> some View {
        let progress = calculateHeaderProgress(offsetY / 80)

        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: symbolName)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .frame(width: 35, height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.white)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .opacity(1 + progress)
            .overlay { // Display alternative icons
                IconImage(name: symbolName)
                    .opacity(-progress)
                    .offset(y: -8)
            }
        }

    }
    
    private func IconImage(name symbolName: String) -> some View {
        Image(systemName: symbolName)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.white)
    }
    
    private func calculateHeaderProgress(_ offset: CGFloat) -> CGFloat {
        let scrollUpThreshold = -offset > 1
        return scrollUpThreshold ? -1 : (offsetY > 0 ? 0 : offset)
    }
}

struct AnimatedHeader_1_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedHeader_1()
    }
}


