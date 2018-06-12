//
//  PictureVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 11/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class PictureVC: UIViewController {

    @IBOutlet weak var pictureView: UIImageView!{
        didSet{
            pictureView.contentMode = .scaleAspectFit
        }
    }
    
    var picture : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: picture!)
        if let data = try? Data(contentsOf: url!)
        {
            self.pictureView.image  = UIImage(data: data)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
