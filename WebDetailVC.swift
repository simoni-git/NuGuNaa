//
//  WebVC.swift
//  NuGuNa
//
//  Created by 시모니 on 2/2/24.
//

import UIKit
import WebKit

class WebDetailVC: UIViewController {
    
    var myURL: String = "" {
        didSet {
            print("WebDetailVC - 값 들어와버림 --> \(myURL)")
        }
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpWebView(myURL)
        
    }
    
    func popUpWebView(_ myURL: String) {
        let url = URL(string: myURL)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
   
}
