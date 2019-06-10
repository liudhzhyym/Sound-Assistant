//
//  ViewController.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 1/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import AudioIndicatorBars
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var indicatorBars: AudioIndicatorBarsView!
    @IBOutlet weak var circleIndicatorView: CircleIndicatorView!
    private lazy var voiceDataManager = VoiceDataManager.shared
    private lazy var audioHelper = AudioHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceDataManager.delegate = self
        setupCircleIndicatorView()
    }
    deinit {
        endListening()
        print("quit")
    }
    
    @IBAction func clickPlayButton(_ sender: Any) {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent("VoiceTempFile.mp4")
        audioHelper.playMusic(filePath: path)
    }
}
extension ViewController: VoiceDataManagerDelegate{
    func getData(manager: VoiceDataManager?, decibel: Int, frequency: Int) {
        circleIndicatorView.centerValue = decibel
        circleIndicatorView.indicatorValue = UInt(circleIndicatorView.centerValue)
        frequencyLabel.text = "\(frequency) Hz"
    }
}

private extension ViewController{
    func setupCircleIndicatorView(){
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
                    SVProgressHUD.showInfo(withStatus: "Please allow this app to access your microphone.\n\nYou can update permission status in Settings.")
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
    func startListening(){
        self.voiceDataManager.start()
        self.circleIndicatorView.disableMinusButton()
        self.indicatorBars.start()
    }
}


