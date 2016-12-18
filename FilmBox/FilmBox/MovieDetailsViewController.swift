//
//  ViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 17/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateLastSeenDate(_ sender: Any) {
        let popOverDP = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dataPickerPopUp") as! PopUpViewController
        self.addChildViewController(popOverDP)
        popOverDP.view.frame = self.view.frame
        self.view.addSubview(popOverDP.view)
        popOverDP.didMove(toParentViewController: self)
    }
}

