//
//  AVAuthorizationStatusChecker.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/5/29.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AVAuthorizationStatusChecker : NSObject {
    static let checker = AVAuthorizationStatusChecker()
    
    public class func shared() -> AVAuthorizationStatusChecker {
        return checker
    }
    
    private override init() {
        
    }
    
    public func getCameraAuthorizationStatus(withClosure : @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted : Bool) in
                if granted {
                    withClosure(true)
                } else {
                    withClosure(false)
                }
            }
            break;
        case .authorized:
            withClosure(true)
            break;
        case .denied:
            withClosure(false)
            break
        case .restricted:
            withClosure(false)
            break
        default:
            withClosure(false)
        }
    }
    
    public func getMicrophoneAuthorizationStatus(withClosure : @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { (granted : Bool) in
                if granted {
                    withClosure(true)
                } else {
                    withClosure(false)
                }
            }
            break;
        case .authorized:
            withClosure(true)
            break;
        case .denied:
            withClosure(false)
            break
        case .restricted:
            withClosure(false)
            break
        default:
            withClosure(false)
        }
    }
}
