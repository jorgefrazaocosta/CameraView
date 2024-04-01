//
//  DefaultCameraPreview.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVKit

struct DefaultCameraPreview: CameraPreview {
    @Binding var media: MCameraMedia?
    let namespace: Namespace.ID
    @State private var player: AVPlayer = .init()
    @State private var shouldShowContent: Bool = false


    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            createContentView()
            Spacer()
            createButtons()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
        .onAppear(perform: onAppear)
    }
}
private extension DefaultCameraPreview {
    func createContentView() -> some View {
        ZStack {
            if let data = media?.data, let image = UIImage(data: data) { createImageView(image) }
            else if let video = media?.url { createVideoView(video) }
            else { EmptyView() }
        }
        .opacity(shouldShowContent ? 1 : 0)
    }
    func createButtons() -> some View {
        HStack(spacing: 32) {
            createRetakeButton()
            createSaveButton()
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
}
private extension DefaultCameraPreview {
    func createImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    func createVideoView(_ video: URL) -> some View {
        VideoPlayer(player: player).onAppear { onVideoAppear(video) }
    }
    func createRetakeButton() -> some View {
        BottomButton(icon: "icon-cancel", primary: false, action: onRetakeButtonTap).matchedGeometryEffect(id: "button-bottom-left", in: namespace)
    }
    func createSaveButton() -> some View {
        BottomButton(icon: "icon-check", primary: true, action: onSaveButtonTap).matchedGeometryEffect(id: "button-bottom-right", in: namespace)
    }
}

private extension DefaultCameraPreview {
    func onAppear() { DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        withAnimation(.defaultEase) { [self] in shouldShowContent = true }
    }}
    func onVideoAppear(_ url: URL) {
        player = .init(url: url)
        player.play()
    }
    func onRetakeButtonTap() {
        media = nil
    }
    func onSaveButtonTap() {

    }
}


// MARK: - BottomButton
fileprivate struct BottomButton: View {
    let icon: String
    let primary: Bool
    let action: () -> ()


    var body: some View {
        Button(action: action, label: createButtonLabel)
    }
}
private extension BottomButton {
    func createButtonLabel() -> some View {
        Image(icon, bundle: .module)
            .resizable()
            .frame(width: 26, height: 26)
            .foregroundColor(iconColor)
            .frame(width: 52, height: 52)
            .background(backgroundColor)
            .mask(Circle())
    }
}
private extension BottomButton {
    var iconColor: Color { switch primary {
        case true: .background
        case false: .white
    }}
    var backgroundColor: Color { switch primary {
        case true: .white
        case false: .white.opacity(0.12)
    }}
}