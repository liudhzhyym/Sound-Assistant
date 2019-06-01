//
//  VoiceSampleUnit.swift
//  VoiceRecorder
//
//  Created by Stephen Cao on 29/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

class VoiceSampleUnit{
    var index: Float
    var db: String
    var frequency: String
    
    init(index: Float, db: String, frequency: String) {
        self.index = index
        self.db = db
        self.frequency = frequency
    }
}
