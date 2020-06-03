//
//  VideoProccessorPipeline.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/6/1.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import Foundation

protocol VideoProccessorPipelineProtocol : AnyObject {
    func addOutput(output : InputSouceProtocol)
    func addOutputs(outputs : Array<InputSouceProtocol>)
    func removeOutput(output : InputSouceProtocol)
    func removeAllOutput()
    func waitUntilFinish()
}
