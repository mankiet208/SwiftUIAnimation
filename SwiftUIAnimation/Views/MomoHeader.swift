//
//  MomoHeader.swift
//  SwiftUIAnimation
//
//  Created by Kiet Truong on 07/11/2024.
//

import SwiftUI

struct MomoHeader: View {
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
                                .fill(AppColor.dogeColor.gradient)
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
        let isScrollDown = offsetY > 0
        
        VStack(spacing: 15) {
            SearchBar(progress)
            FeaturesBar(progress)
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
            Image("doge")
                .resizable()
                .frame(maxWidth: .infinity)
                .opacity(showSearchBar ? 1 : 1 + progress)
                .scaleEffect(isScrollDown ? 1 + offsetY / 1000 : 1, anchor: .top)
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: .black, location: 0.8),
                                .init(color: .clear, location: 1),
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .background {
            Rectangle()
                .fill(AppColor.dogeColor)
                .padding(.bottom, 80)
                .opacity(showSearchBar ? 0 : -progress)
        }
    }
    
    private func SearchBar(_ progress: CGFloat) -> some View {
        HStack(spacing: 15) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                TextField(
                    "",
                    text: .constant(""),
                    prompt: Text("Search doges...")
                        .foregroundColor(.white)
                )
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black)
                    .opacity(0.5)
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
    }
    
    private func FeaturesBar(_ progress: CGFloat) -> some View {
        HStack(spacing: 0) {
            CustomButton(symbolName: "rectangle.portrait.and.arrow.forward", title: "Deposit") {}
            CustomButton(symbolName: "dollarsign.arrow.circlepath", title: "Withdraw") {}
            CustomButton(symbolName: "qrcode.viewfinder", title: "QR Code") {}
            CustomButton(symbolName: "creditcard", title: "Your cards") {}
        }
        .padding(.horizontal, -progress * 50) // Shrink buttons bar
        .padding(.top, 10)
        .offset(y: progress * 65) // Move buttons up when scroll up
        .opacity(showSearchBar ? 0 : 1)
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
                    .foregroundColor(AppColor.dogeColor)
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

struct MomoHeader_Previews: PreviewProvider {
    static var previews: some View {
        MomoHeader()
    }
}
