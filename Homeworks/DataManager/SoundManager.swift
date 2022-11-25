//
//  File.swift
//  Homeworks
//
//  Created by Nate on 11/24/22.
//

import SwiftUI
import AVKit

class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "BackPackZip", withExtension: ".mp3") else { return }
        
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.3
            player?.play()
        }catch let error{
            print("Error playing sound \(error.localizedDescription)")
        }
    }
}
