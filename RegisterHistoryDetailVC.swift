//
//  RegisterHistoryDetailVC.swift
//  NuGuNa
//
//  Created by 시모니 on 2/6/24.
//

import UIKit

class RegisterHistoryDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    var petitionTitle: String = ""
    var petitionResult: String = ""
    var petitionCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = petitionTitle
        self.resultLabel.text = petitionResult
        self.codeLabel.text = petitionCode

       
    }
    

}
