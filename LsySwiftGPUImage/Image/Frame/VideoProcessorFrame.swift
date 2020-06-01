//
//  VideoProcessorFrame.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/6/1.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation
import MetalKit
import AVFoundation

class VideoProcessorFrame : NSObject {
    open var context : VideoProccessorMetalContext! = nil
    open var texture : MTLTexture! = nil
    open weak var delegate : VideoProccessorFramePoolRecycleDelegate?
    open var framePoolKey : String! = nil
    
    var textureCache : CVMetalTextureCache! = nil
    var cvMetalTexture : CVMetalTexture! = nil
    var hasConvertToMTL = false
    var usingCount = 0
    
    //MARK: - Public
    public func use() {
        usingCount += 1
    }
    
    public func unuse() {
        usingCount -= 1
        if usingCount == 0 {
            self.delegate?.frameDidRecycle(frame: self)
        }
    }
    
    //MARK: - Setter & Getter
    open var buffer : CMSampleBuffer! = nil {
        didSet {
            if buffer != oldValue {
                convertBufferToMTLTexture()
            }
        }
    }
    
    //MARK:- Private
    func convertBufferToMTLTexture() {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            assert(true, "Can not get Image Buffer from SampleBuffer")
            return
        }
        
        if context.device == nil {
            assert(true, "Not initial context")
            return
        }
        
        let cacheCreateResult = CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, context.device, nil, &textureCache)
        if cacheCreateResult != kCVReturnSuccess {
            assert(true, "init textureCache failed")
            return
        }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let textureCreateResult = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, .bgra8Unorm, width, height, 0, &cvMetalTexture)
        if textureCreateResult != kCVReturnSuccess {
            assert(true, "making cvMetalTexture failed")
        }
        
        texture = CVMetalTextureGetTexture(cvMetalTexture)
    }
}
