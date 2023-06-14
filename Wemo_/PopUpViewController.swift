//
//  PopUpViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/06/07.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet var view_popUp: UIView!
    
    @IBOutlet var btn_popUP: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_popUp.layer.cornerRadius = 10
        view_popUp.layer.borderWidth = 0.5
        
    }//end of viewDidLoad
    

    @IBAction func closePopUp(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)  // 사라지게 하기
    }//end of closePopUp
    
}//end of class
