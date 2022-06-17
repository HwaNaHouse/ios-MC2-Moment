//
//  MoveSettingView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/17.
//

import SwiftUI
import AVKit

struct MoveSettingView: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 50) {
                Text("위치 정보 서비스를 \n켜주세요")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("1. 설정 메뉴에서 '개인정보 보호'를 선택합니다")
                    Text("2. '위치 정보 서비스'를 누릅니다")
                    Text("3. 마지막으로 '위치 정보 서비스'를 켭니다")
                }
                .font(.body)
                .foregroundColor(.white)
                
                SettingLocationView()
                    .frame(height: 250)
                
                Button {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("설정화면 이동")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.defaultColor))
                }
            }
            .padding(20)
        }
    }
}

struct MoveSettingView_Previews: PreviewProvider {
    static var previews: some View {
        MoveSettingView()
    }
}

struct SettingLocationView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        return PlayerSettingView(frame: .zero) //why zero?
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class PlayerSettingView: UIView {
    
    
    private var playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let file = Bundle.main.url(forResource: "SettingLocation", withExtension: "mp4")!
        let item = AVPlayerItem(url: file)
        
        let player = AVPlayer(playerItem: item)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(rewindVideo(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        player.play()
    }
    
    @objc
    func rewindVideo(notification: Notification) {
        playerLayer.player?.seek(to: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
