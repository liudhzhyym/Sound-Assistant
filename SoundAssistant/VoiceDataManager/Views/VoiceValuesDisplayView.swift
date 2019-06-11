//
//  VoiceValuesDisplayView.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 11/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import SVProgressHUD
import AudioIndicatorBars
protocol VoiceValuesDisplayViewDelegate: NSObjectProtocol {
    func didClickUploadButton(view: VoiceValuesDisplayView, content: String)
}
class VoiceValuesDisplayView: UIView {
    weak var delegate: VoiceValuesDisplayViewDelegate?
    class func displayView()->VoiceValuesDisplayView{
        let nib = UINib(nibName: "VoiceValuesDisplayView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! VoiceValuesDisplayView
        v.frame = UIScreen.main.bounds
        return v
    }
    override func awakeFromNib() {
        voiceDataManager.delegate = self
        setupCircleIndicatorView()
        addSubview(settingsView)
        settingsView.delegate = self
    }
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var indicatorBars: AudioIndicatorBarsView!
    @IBOutlet weak var circleIndicatorView: CircleIndicatorView!
    private lazy var voiceDataManager = VoiceDataManager.shared
    private lazy var audioHelper = AudioHelper()
    private lazy var settingsView = VoiceSettingsView.settingsView()
    
    @IBAction func clickPlayButton(_ sender: Any) {
        audioHelper.playMusic(filePath: SoundFilePath)
    }
    
    @IBAction func clickSettingsButton(_ sender: Any) {
        settingsView.isHidden = false
        endListening()
    }
    
}
extension VoiceValuesDisplayView: VoiceDataManagerDelegate{
    func getData(manager: VoiceDataManager?, decibel: Int, frequency: Int) {
        circleIndicatorView.centerValue = decibel
        circleIndicatorView.indicatorValue = UInt(circleIndicatorView.centerValue)
        frequencyLabel.text = "\(frequency) Hz"
        settingsView.setDecibelAndFrequencyValues(currentDbValue: decibel, currentFqValue: frequency)
    }
}

extension VoiceValuesDisplayView{
    private func setupCircleIndicatorView(){
        circleIndicatorView.minValue = 0
        circleIndicatorView.maxValue = 120
        circleIndicatorView.innerAnnulusValueToShowArray = [0, 20, 40, 60, 80, 100, 120]
        circleIndicatorView.indicatorValue = 0
        circleIndicatorView.addBlock = { [weak self]()->() in
            self?.endListening()
        }
        circleIndicatorView.minusBlock = { [weak self]()->() in
            AVAudioSession.sharedInstance().requestRecordPermission { (isGranted) in
                if isGranted{
                    DispatchQueue.main.async(execute: {
                        self?.startListening()
                    })
                }else{
                    SVProgressHUD.showInfo(withStatus: "Please allow this app to access your microphone.\n\n`You can update permission status in Settings.")
                }
            }
        }
    }
    func endListening(){
        voiceDataManager.end()
        circleIndicatorView.enableMinusButton()
        circleIndicatorView.shine(withTimeInterval: 0.01, pauseDuration: 0, finalValue: 0, finish: {
            
        })
        circleIndicatorView.centerValue = 0
        frequencyLabel.text = "0 Hz"
        indicatorBars.stop()
    }
   private func startListening(){
        self.voiceDataManager.start()
        self.circleIndicatorView.disableMinusButton()
        self.indicatorBars.start()
    }
}
extension VoiceValuesDisplayView: VoiceSettingsViewDelegate{
    func didClickUploadButton(view: VoiceSettingsView, content: String) {
        delegate?.didClickUploadButton(view: self, content: content)
    }
}
