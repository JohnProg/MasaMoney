//
//  ObscuraErrors.swift
//  Obscura
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import Foundation
import UIKit

public enum ObscuraError: Error {
    case photoLibraryNotAvailable
    case cameraNotAvailable
    case rearCameraNotAvailable
    case frontCameraNotAvailable
}
