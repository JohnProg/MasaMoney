//
//  PictureVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 11/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Kingfisher

class PictureVC: UIViewController {
    
    // MARK: - Outlet

    @IBOutlet weak var pictureView: UIImageView!{
        didSet{
            pictureView.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - Properties
    
    var picture : String?
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: picture!)
        self.pictureView.kf.setImage(with: url)
//        if let data = try? Data(contentsOf: url!){
//            self.pictureView.image  = UIImage(data: data)
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
