//
//  VoiceDataManager.swift
//  VoiceRecorder
//
//  Created by Stephen Cao on 29/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

protocol VoiceDataManagerDelegate: NSObjectProtocol{
    func getDataList(manager: VoiceDataManager, list: [VoiceSampleUnit])
    func getTimerCount(manager: VoiceDataManager?, count: Float)
}

class VoiceDataManager{
    static let shared = VoiceDataManager()
    
    private lazy var dbHelper = DecibelMeterHelper()
    private lazy var listener = SCListener.shared()
    
    weak var delegate: VoiceDataManagerDelegate?
    var voiceData = [VoiceSampleUnit]()
    var counter: Float = 0
    
    private init(){
        dbHelper.decibelMeterBlock = {[weak self](dbSPL)->() in
            let db = String.init(format: "%.2lf", dbSPL)
            let frequency = String.init(format: "%.2lf", self?.listener?.frequency() ?? 0)
            let unit = VoiceSampleUnit(index: self?.counter ?? 0, db: db, frequency: frequency)
            self?.voiceData.append(unit)
            self?.delegate?.getTimerCount(manager: self, count: self?.counter ?? 0)
            self?.counter += 0.1
        }
    }
    
    func start(){
        counter = 0
        voiceData.removeAll()
        dbHelper.startMeasuring(withIsSaveVoice: true)
        listener?.listen()
    }
    func end(){
        dbHelper.stopMeasuring()
        listener?.stop()
        delegate?.getDataList(manager: self, list: voiceData)
    }
    
}
