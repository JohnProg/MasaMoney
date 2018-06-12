//
//  ObscuraResponse.swift
//  Obscura
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import Foundation
import UIKit

public enum ObscuraImageResponse {
    case success(image: ImageResponse)
    case failed(error: Error?)
}

public struct ImageResponse {
    public var image: UIImage
    public var info: [String : Any]

    init(_ image: UIImage, info: [String : Any]) {
        self.image = image
        self.info = info
    }
}

public enum ObscuraVideoResponse {
    case success(image: VideoResponse)
    case failed(error: Error?)
}

public struct VideoResponse {
    public var url: URL
    public var info: [String : Any]

    init(_ url: URL, info: [String : Any]) {
        self.url = url
        self.info = info
    }
}

public typealias ImagePickedBlock = (ObscuraImageResponse) -> Void
public typealias VideoPickedBlock = (ObscuraVideoResponse) -> Void
