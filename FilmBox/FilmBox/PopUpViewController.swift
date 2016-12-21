//
//  PopUpViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 17/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit

protocol SavingViewControllerDelegate
{
    func saveDate(date : Date)
}

class PopUpViewController: UIViewController {
    
    var delegate : SavingViewControllerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func cansel(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func sendDateToDetailsVC(_ sender: UIButton) {
        if((self.delegate) != nil)
        {
            delegate?.saveDate(date: datePicker.date);
            self.view.removeFromSuperview()
        }
    }
}
