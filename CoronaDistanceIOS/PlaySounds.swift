//
//  PlaySounds.swift
//  CoronaDistanceIOS
//
//  Created by Jose Morales on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: - AUDIO PLAYER

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Couldn't find and play sound file.")
        }
    }
}
