//
//  LsyInputSouceProtocol.swift
//  LsySwiftGPUImage
//
//  Created by liushuoyang on 2020/5/29.
//  Copyright © 2020 liushuoyang. All rights reserved.
//

import MetalKit

protocol InputSouceProtocol {
    func input(texture : MTLTexture, souce : AnyObject)
}
