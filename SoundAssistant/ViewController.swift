//
//  ViewController.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 1/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController {
    private let displayView = VoiceValuesDisplayView.displayView()
    private lazy var userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(displayView)
        displayView.delegate = self
    }
    deinit {
        displayView.endListening()
    }
}
extension ViewController: VoiceValuesDisplayViewDelegate{
    func didClickUploadButton(view: VoiceValuesDisplayView, content: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Sound data results")
            mailComposer.setMessageBody(content, isHTML: false)
            let emailAddress = userDefault.object(forKey: UploadFileEmailAddressDefaultKey) as? String ?? ""
            mailComposer.setToRecipients([emailAddress])
            mailComposer.mailComposeDelegate = self
            
            let url = URL(fileURLWithPath: SoundFilePath)
            do {
                let attachmentData = try Data(contentsOf: url)
                mailComposer.addAttachmentData(attachmentData, mimeType: "audio/mp4", fileName: "SoundRecord")
                mailComposer.mailComposeDelegate = self
                self.present(mailComposer, animated: true
                    , completion: nil)
            } catch let error {
                print("We have encountered error \(error.localizedDescription)")
            }

        } else {
            print("Email is not configured in settings app or we are not able to send an email")
        }
    }
}
extension ViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break
            
        case .saved:
            print("Mail is saved by user")
            break
            
        case .sent:
            print("Mail is sent successfully")
            break
            
        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}



