//
//  Obscura+ImagePicker.swift
//  Obscura
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import Foundation
import UIKit

extension Obscura: UIImagePickerControllerDelegate {

    // MARK: - UIImagePickerControllerDelegate -

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedVideo = info[UIImagePickerControllerMediaURL] as? URL {
            videoPickedBlock?(.success(image: VideoResponse(pickedVideo, info: info)))
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickedBlock?(.success(image: ImageResponse(pickedImage, info: info)))
        } else {
            let error = NSError.init(domain: "Obscura", code: 500, userInfo: nil)
            videoPickedBlock?(.failed(error: error))
            imagePickedBlock?(.failed(error: error))
        }

        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
