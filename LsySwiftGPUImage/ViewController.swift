//
//  ViewController.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/5/29.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cameraSession = InputCameraSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraSession.insertPreviewLayer(inView: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let group = DispatchGroup()
        var totalGranted = true
        group.enter()
        AVAuthorizationStatusChecker.shared().getCameraAuthorizationStatus { (granted : Bool) in
            if !granted {
                totalGranted = false
            }
            group.leave()
        }
        
        group.enter()
        AVAuthorizationStatusChecker.shared().getMicrophoneAuthorizationStatus { (granted : Bool) in
            if !granted {
                totalGranted = false
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            if totalGranted {
                self.cameraSession.startRunning()
            }
        }
    }
}

