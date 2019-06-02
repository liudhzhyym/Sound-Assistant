//
//  ViewController.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 1/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell_id"
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerDisplayButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    private lazy var voiceDataManager = VoiceDataManager.shared
    private lazy var audioHelper = AudioHelper()
    private var dataList: [VoiceSampleUnit]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceDataManager.delegate = self
        print(NSString.getDocumentDirectory())
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    deinit {
        print("quit")
    }
    
    @IBAction func clickEndButton(_ sender: Any) {
        voiceDataManager.end()
        startButton.isEnabled = true
    }
    @IBAction func clickStartButton(_ sender: Any) {
        voiceDataManager.start()
        tableView.isHidden = true
        startButton.isEnabled = false
    }
    @IBAction func clickPlayButton(_ sender: Any) {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent("VoiceTempFile.mp4")
        audioHelper.playMusic(filePath: path)
    }
    
    @IBAction func clickTimerDisplayButton(_ sender: UIButton) {
        sender.setTitle("0", for: [])
        dataList = nil
        tableView.reloadData()
    }
    
    @IBAction func clickDisplayButton(_ sender: Any) {
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    
}
extension ViewController: VoiceDataManagerDelegate{
    func getTimerCount(manager: VoiceDataManager?, count: Float) {
        timerDisplayButton.setTitle(String.init(format: "%.1lf", count), for: [])
        
    }
    
    func getDataList(manager: VoiceDataManager, list: [VoiceSampleUnit]) {
        dataList = list
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let voiceUnit = dataList?[indexPath.row]
        
        cell.textLabel?.text = "No." + String.init(format: "%.1lf", voiceUnit?.index ?? 0) + "------ \(voiceUnit?.db  ?? "") DB ----- \(voiceUnit?.frequency ?? "") HZ"
        return cell
    }
}

