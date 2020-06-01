//
//  VideoProccessorMetalContext.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/6/1.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation
import MetalKit

class VideoProccessorMetalContext : NSObject {
    open var device : MTLDevice! = nil
    
    override init() {
        super.init()
        
        device = MTLCreateSystemDefaultDevice()
    }
}
