//
//  ViewController.swift
//  Modules
//
//  Created by Darko Dujmovic
//  Copyright © 2020 Darko Dujmovic. All rights reserved.
//

import UIKit
import WorkdayState

class ViewController: UIViewController {

    let formatter = DateComponentsFormatter()

    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!

    let playIcon = UIImage(systemName: "play")
    let pauseIcon = UIImage(systemName: "pause")
    let stopIcon = UIImage(systemName: "stop")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configButtons(forState: WorkdayState.sharedInstance.workdayState.currentState)
        addActionsToButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerUpdated(_:)), name: Notification.Name("elapsedTime"), object:nil)
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
    }

    @objc
    func timerUpdated(_ notification:Notification){
        if let dict = notification.userInfo as Dictionary? {
            if let seconds = dict["seconds"] as? Int{
                currentTimeLabel.text = formatter.string(from: TimeInterval(seconds))!
            }
        }
    }
    
    private func addActionsToButtons(){
        startPauseButton.addTarget(self, action: #selector(playPauseDay), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endDay), for: .touchUpInside)
    }
    
    private func configButtons(forState workdayState:WorkdayStateType){
        
        startPauseButton.setImage(playIcon, for: .normal)
        endButton.setImage(stopIcon, for: .normal)
        
        switch workdayState {
        case .none:
            startPauseButton.isEnabled = true
            endButton.isEnabled = false
            currentStatusLabel.text = "Workday not started"
        case .workdayInProgress:
            startPauseButton.setImage(pauseIcon, for: .normal)
            endButton.isEnabled = true
            currentStatusLabel.text = "Workday in progress"
        case .workdayPaused:
            startPauseButton.setImage(playIcon, for: .normal)
            endButton.isEnabled = true
            currentStatusLabel.text = "Workday paused"
        case .workdayFinished:
            startPauseButton.setImage(playIcon, for: .normal)
            startPauseButton.isEnabled = false
            endButton.isEnabled = false
            currentStatusLabel.text = "Workday ended"
        }
        
    }
    
    @objc
    private func playPauseDay(){
        WorkdayManager.sharedInstance.playPauseDay{[weak self] result in
            switch result{
            case .success:
                self?.configButtons(forState: WorkdayState.sharedInstance.workdayState.currentState)
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
    
    @objc
    private func endDay(){
        WorkdayManager.sharedInstance.endDay{[weak self] result in
            switch result{
            case .success:
                self?.configButtons(forState: WorkdayState.sharedInstance.workdayState.currentState)
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }

}

