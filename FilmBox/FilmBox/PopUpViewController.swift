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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cansel(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func sendDateToDetailsVC(_ sender: UIButton) {
        print("In send date")
        if((self.delegate) != nil)
        {
            print("in if statement")
            delegate?.saveDate(date: datePicker.date);
            self.view.removeFromSuperview()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
