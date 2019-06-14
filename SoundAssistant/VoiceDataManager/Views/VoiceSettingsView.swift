//
//  VoiceSettingsView.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 11/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
private let appId = "1468191026"
private let emailAddress = "stephen.cao0805@outlook.com"
protocol VoiceSettingsViewDelegate: NSObjectProtocol {
    func didClickUploadButton(view:VoiceSettingsView, content: String)
}
class VoiceSettingsView: UIView {
    weak var delegate: VoiceSettingsViewDelegate?
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var moreOptionsView: UIView!
    @IBOutlet weak var aboutUsTextView: UITextView!
    @IBOutlet weak var valuesView: UIView!
    @IBOutlet var dbLabels: [UILabel]!
    @IBOutlet var fqLabels: [UILabel]!
    
    private var previousDbValue: Int = 0
    private var maxDbValue: Int = 0
    private var minDbValue: Int = 0
    
    private var previousFqValue: Int = 0
    private var maxFqValue: Int = 0
    private var minFqValue: Int = 0
    private let userDefault = UserDefaults.standard
    
    class func settingsView()->VoiceSettingsView{
        let nib = UINib(nibName: "VoiceSettingsView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! VoiceSettingsView
        v.frame = UIScreen.main.bounds
        v.isHidden = true
        return v
    }
    override func awakeFromNib() {
        textField.text = userDefault.object(forKey: UploadFileEmailAddressDefaultKey) as? String
        textField.borderStyle = .none
    }

    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        moreOptionsView.isHidden = sender.selectedSegmentIndex != 1
        valuesView.isHidden = !moreOptionsView.isHidden
        if moreOptionsView.isHidden{
            disableTextField()
        }
    }
    
    @IBAction func clickSettingsMaskButton(_ sender: Any) {
        isHidden = true
        resetAllValues()
    }
    @IBAction func clickMoreButtons(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + appId) else{
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case 102:
            guard let url = URL(string: "mailto:\(emailAddress)") else{
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case 103:
            aboutUsTextView.text = "Produced by: Rui Cao\n\nVersion: v1.0.5\n\nCopyright © 2019 Rui Cao. All rights reserved."
        case 104:
            if !textField.isEnabled{
                enableTextField()
            } else{
                disableTextField()
            }
        case 105:
            aboutUsTextView.text = "Tips: Previous sound record will be covered by the current one. Please send it to your email before starting the next recording."
        default:
            break
        }
    }
    
    @IBAction func textFieldDidEnd(_ sender: Any) {
        userDefault.set(textField.text, forKey: UploadFileEmailAddressDefaultKey)
    }
    
    @IBAction func clickUploadButton(_ sender: Any) {
        let content = "Decibel(dB): max(\(dbLabels[0].text ?? "")),min(\(dbLabels[1].text ?? "")),avg(\(dbLabels[2].text ?? ""))\nFrequency(Hz): max(\(fqLabels[0].text ?? "")),min(\(fqLabels[1].text ?? "")),avg(\(fqLabels[2].text ?? ""))\n\nData comes from Sound Detector"
        delegate?.didClickUploadButton(view: self, content: content)
    }
    private func resetAllValues(){
        previousDbValue = 0
        maxDbValue = 0
        minDbValue = 0
        
        previousFqValue = 0
        maxFqValue = 0
        minFqValue = 0
        
        aboutUsTextView.text.removeAll()
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl(segmentControl)
        
        disableTextField()
    }
    
    private func enableTextField(){
        textField.backgroundColor = UIColor.white
        textField.isEnabled = true
        textField.becomeFirstResponder()
        textField.borderStyle = .roundedRect
        editButton.setBackgroundImage(UIImage(named: "btn_edit_selected"), for: [])
    }
    private func disableTextField(){
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.isEnabled = false
        textField.resignFirstResponder()
        editButton.setBackgroundImage(UIImage(named: "btn_edit"), for: [])
    }
}
extension VoiceSettingsView{
    func setDecibelAndFrequencyValues(currentDbValue: Int, currentFqValue: Int){
        previousDbValue = previousDbValue == 0 ? currentDbValue : (previousDbValue + currentDbValue) / 2
        maxDbValue = max(maxDbValue, currentDbValue)
        minDbValue = minDbValue == 0 ? currentDbValue : min(minDbValue, currentDbValue)
        // max value
        dbLabels[0].text = "\(maxDbValue)"
        // min value
        dbLabels[1].text = "\(minDbValue)"
        // avg value
        dbLabels[2].text = "\(previousDbValue)"
        
        previousFqValue = previousFqValue == 0 ? currentFqValue : (previousFqValue + currentFqValue) / 2
        maxFqValue = max(maxFqValue, currentFqValue)
        minFqValue = minFqValue == 0 ? currentFqValue : min(minFqValue, currentFqValue)
        // max value
        fqLabels[0].text = "\(maxFqValue)"
        // min value
        fqLabels[1].text = "\(minFqValue)"
        // avg value
        fqLabels[2].text = "\(previousFqValue)"
    }
    
}
