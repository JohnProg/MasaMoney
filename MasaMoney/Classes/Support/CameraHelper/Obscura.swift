//
//  Obscura.swift
//  Obscura
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import AVKit
import AVFoundation
import MediaPlayer
import MobileCoreServices
import UIKit

public class Obscura: NSObject, UINavigationControllerDelegate {

    private var imagePicker: UIImagePickerController

    public var imagePickedBlock: ImagePickedBlock?
    public var videoPickedBlock: VideoPickedBlock?

    var cameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var photoLibraryAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }

    var rearCameraAvailable: [NSNumber]? {
        return UIImagePickerController.availableCaptureModes(for: .rear)
    }

    var frontCamerAvailable: [NSNumber]? {
        return UIImagePickerController.availableCaptureModes(for: .front)
    }

    override public init() {
        imagePicker = UIImagePickerController()
        super.init()
        imagePicker.delegate = self
    }

    public func chooseFromGallery(viewController: UIViewController) throws {
        guard photoLibraryAvailable else {
            throw ObscuraError.photoLibraryNotAvailable
        }

        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String, kUTTypeVideo as String]
        imagePicker.allowsEditing = false

        viewController.present(imagePicker, animated: true, completion: nil)
    }

    public func takeVideo(viewController: UIViewController) throws {

        guard cameraAvailable else {
            throw ObscuraError.cameraNotAvailable
        }

        guard (rearCameraAvailable != nil) else {
            throw ObscuraError.rearCameraNotAvailable
        }

        guard (frontCamerAvailable != nil) else {
            throw ObscuraError.frontCameraNotAvailable
        }

        self.imagePicker.sourceType = .camera
        self.imagePicker.mediaTypes = [kUTTypeMovie as String]
        self.imagePicker.allowsEditing = false

        viewController.present(imagePicker, animated: true, completion: nil)
    }

    public func takePhoto(viewController: UIViewController) throws {
        guard cameraAvailable else {
            throw ObscuraError.cameraNotAvailable
        }

        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.showsCameraControls = true
            imagePicker.allowsEditing = true

            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            throw ObscuraError.cameraNotAvailable
        }
    }
}
