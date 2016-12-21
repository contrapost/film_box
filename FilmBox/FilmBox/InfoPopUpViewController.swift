//
//  InfoPopUpViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 20/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit

class InfoPopUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func closePopUp(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
}
