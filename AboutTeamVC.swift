//
//  AboutTeamVC.swift
//  NuGuNa
//
//  Created by 시모니 on 2/6/24.
//

import UIKit
import WebKit

class AboutTeamVC: UIViewController {
    
    let aboutTeamUrl = "https://regular-macrame-991.notion.site/127a88b725724418bbc80c2cb427baed?v=0863045029b5486bae07860379f68374&pvs=4"
    @IBOutlet weak var webView: WKWebView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpWebView()
        
    }
    
    func popUpWebView() {
        let url = URL(string: self.aboutTeamUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}
