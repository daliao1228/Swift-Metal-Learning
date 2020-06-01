//
//  VideoProccessorFramePool.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/6/1.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation

protocol VideoProccessorFramePoolRecycleDelegate : AnyObject {
    func frameDidRecycle(frame : VideoProcessorFrame)
}

class VideoProccessorFramePool : NSObject {
    
    var poolsContainer : Dictionary<String, Array<VideoProcessorFrame>> = Dictionary<String, Array<VideoProcessorFrame>>()
    var lock = NSLock()
    var context : VideoProccessorMetalContext = VideoProccessorMetalContext()
    
    //MARK: - Public
    public func frame(withKey : String) -> VideoProcessorFrame {
        lock.lock()
        
        var pool = poolsContainer[withKey]
        if pool == nil {
            pool = Array<VideoProcessorFrame>()
        }
        
        var frame = pool?.first
        if frame == nil {
            frame = VideoProcessorFrame()
            frame?.context = context
            frame?.framePoolKey = withKey
            frame?.delegate = self
        }
        
        lock.unlock()
        return frame!
    }
    
    //MARK: - Private
}

extension VideoProccessorFramePool : VideoProccessorFramePoolRecycleDelegate {
    func frameDidRecycle(frame : VideoProcessorFrame) {
        lock.lock()
        var pool = poolsContainer[frame.framePoolKey]
        pool?.append(frame)
        lock.unlock()
    }
}


