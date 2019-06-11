//
//  SoundAssistantCommon.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 11/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

let SoundFilePath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent("VoiceTempFile.mp4")
let UploadFileEmailAddressDefaultKey = "email_address"
