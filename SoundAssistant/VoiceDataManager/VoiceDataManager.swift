//
//  VoiceDataManager.swift
//  VoiceRecorder
//
//  Created by Stephen Cao on 29/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

protocol VoiceDataManagerDelegate: NSObjectProtocol{
    func getData(manager: VoiceDataManager?, decibel: Int, frequency: Int)
}

class VoiceDataManager{
    static let shared = VoiceDataManager()
    
    private lazy var dbHelper = DecibelMeterHelper()
    private lazy var listener = SCListener.shared()
    
    weak var delegate: VoiceDataManagerDelegate?
   
    var counter: Float = 0
    
    private init(){
        dbHelper.decibelMeterBlock = {[weak self](dbSPL)->() in
            self?.delegate?.getData(manager: self, decibel: Int(dbSPL), frequency: Int(self?.listener?.frequency() ?? 0))
            self?.counter += 0.1
        }
    }
    
    func start(){
        counter = 0
        dbHelper.startMeasuring(withIsSaveVoice: true)
        listener?.listen()
    }
    func end(){
        dbHelper.stopMeasuring()
        listener?.stop()
    }
    
}
