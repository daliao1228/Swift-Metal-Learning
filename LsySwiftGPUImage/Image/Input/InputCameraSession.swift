//
//  InputCameraSession.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/5/29.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class InputCameraSession : NSObject {
    var captureSession : AVCaptureSession! = nil
    
    var videoCaptureDevice  : AVCaptureDevice! = nil
    var audioCaptureDevice : AVCaptureDevice! = nil
    
    var videoCaptureInput : AVCaptureDeviceInput! = nil
    var audioCapureInput : AVCaptureDeviceInput! = nil
    
    var videoCaptureOutput : AVCaptureVideoDataOutput! = nil
    var audioCaptureOutput : AVCaptureAudioDataOutput! = nil
    
    var captureConnection : AVCaptureConnection! = nil
    
    var previewLayer : AVCaptureVideoPreviewLayer! = nil
    
    var hasPreparedSesssion = false
    
    var videoOutputQueue : DispatchQueue! = nil
    var audioOutputQueue : DispatchQueue! = nil
    
    var isCaptureSessionRunning = false
    
    override init() {
        super.init()
        
        captureSession = AVCaptureSession()
    }
    
    //MARK: - public
    
    public func prepareSession() {
        if hasPreparedSesssion {
            return
        }
        
        hasPreparedSesssion = true
        reloadAudioOutputAndInput()
        reloadVideoDeviceInput()
        prepareVideoOutput()
    }
    
    public func startRunning() {
        if isCaptureSessionRunning {
            return
        }
        
        isCaptureSessionRunning = true
        prepareSession()
        captureSession.startRunning()
    }
    
    public func stopRunning() {
        if !isCaptureSessionRunning {
            return
        }
        
        isCaptureSessionRunning = false
        captureSession.stopRunning()
    }
    
    //MARK: - debug
    public func insertPreviewLayer(inView : UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = inView.bounds
        
        inView.layer.addSublayer(previewLayer)
    }
    
    //MARK: - private
    func sessionBeginConfiguration() {
        captureSession.beginConfiguration()
    }
    
    func sessionCommitConfiguration() {
        captureSession.commitConfiguration()
    }
    
    func prepareVideoOutput() {
        sessionBeginConfiguration()
        if videoCaptureOutput != nil {
            captureSession.removeOutput(videoCaptureOutput);
            videoCaptureOutput = nil
        }
        
        if videoOutputQueue == nil {
            videoOutputQueue = DispatchQueue(label: "video_output_queue")
        }
        
        videoCaptureOutput = AVCaptureVideoDataOutput();
        videoCaptureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        videoCaptureOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        
        if captureSession.canAddOutput(videoCaptureOutput) {
            captureSession.addOutput(videoCaptureOutput)
        }
        
        sessionCommitConfiguration()
    }
    
    func reloadAudioOutputAndInput() {
        sessionBeginConfiguration()
        
        if isAudioCaptureEnabled {
            if audioCaptureDevice == nil {
                audioCaptureDevice = AVCaptureDevice.default(for: .audio)
            }
            
            if audioCapureInput == nil {
                audioCapureInput = try! AVCaptureDeviceInput(device: audioCaptureDevice)
                if captureSession.canAddInput(audioCapureInput) {
                    captureSession.addInput(audioCapureInput)
                }
            }
            
            if audioCaptureOutput == nil {
                if audioOutputQueue == nil {
                    audioOutputQueue = DispatchQueue(label: "audio_output_queue")
                }
                
                audioCaptureOutput = AVCaptureAudioDataOutput()
                if captureSession.canAddOutput(audioCaptureOutput) {
                    captureSession.addOutput(audioCaptureOutput)
                }
            }
            
        } else {
            if audioCapureInput != nil {
                captureSession.removeInput(audioCapureInput)
                audioCapureInput = nil
            }
            
            if audioCapureInput != nil {
                captureSession.removeOutput(audioCaptureOutput)
                audioCaptureOutput = nil
            }
        }
        
        sessionCommitConfiguration()
    }
    
    func reloadVideoDeviceInput() {
        sessionBeginConfiguration()
        if videoCaptureInput != nil {
            captureSession.removeInput(videoCaptureInput)
            videoCaptureInput = nil
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) {
            videoCaptureInput = try! AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(videoCaptureInput) {
                captureSession.addInput(videoCaptureInput)
            }
        }
        sessionCommitConfiguration()
    }
    
    //MARK: - Setter & Getter
    open var sessionPresentInternal : AVCaptureSession.Preset! = .hd1280x720 {
        didSet {
            if sessionPresentInternal != oldValue {
                reloadVideoDeviceInput()
            }
        }
    }
    open var cameraPosition : AVCaptureDevice.Position! = .front {
        didSet {
            if cameraPosition != oldValue {
                reloadVideoDeviceInput()
            }
        }
    }
    open var isAudioCaptureEnabled = true {
        didSet {
            if isAudioCaptureEnabled != oldValue {
                reloadAudioOutputAndInput()
            }
        }
    }
}

extension InputCameraSession : InputSouceProtocol {
    
}

extension InputCameraSession : AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
