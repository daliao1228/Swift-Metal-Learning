//
//  VideoProccessSerialPipeline.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/6/1.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation

class VideoProccessSerialPipeline : NSObject {
    open var isProccessing = false
    open var filters : Array<VideoProccessorFilter> = Array<VideoProccessorFilter>()
    
    var context : VideoProccessorMetalContext! = nil
    var framePool : VideoProccessorFramePool! = nil
    
    init(withContext : VideoProccessorMetalContext, filters : Array<VideoProccessorFilter>) {
        self.context = withContext
        self.filters = filters
        self.framePool = VideoProccessorFramePool(withContext: withContext)
    }
    
}
