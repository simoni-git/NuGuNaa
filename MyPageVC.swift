//
//  MyPageVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit
import Alamofire

class MyPageVC: UIViewController {
        
    var myPageVM: MyPageVM!
    var accessToken: String = ""
    var userName: String = ""
    var userEmail: String = ""
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        myPageVM = MyPageVM()
        contentView.layer.cornerRadius = 10
        welcomeLabel.text = "\(userName) 님 환영합니다!"
    }
    
    @IBAction func tapLogOutBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "로그아웃", style: .default) { [weak self] action in
            if let navigationController = self!.navigationController {
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(self!.accessToken)"
                ]
                
                AF.request(self!.myPageVM.logOutURL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                                    .validate()
                                    .responseJSON { response in
                                        switch response.result {
                                        case .success(let value):
                                            print("로그아웃 요청 성공: \(value)")
                                        case .failure(let error):
                                            print("로그아웃 요청 실패: \(error)")
                                        }
                                }
                
                if let firstVC = navigationController.viewControllers.first(where: { $0 is FirstVC }) {
                    // 네비게이션 뷰 컨트롤러 스택을 재구성하여 메인 뷰 컨트롤러를 루트로 설정
                    navigationController.setViewControllers([firstVC], animated: true)
                } else {
                    // 메인 뷰 컨트롤러를 찾을 수 없을 경우, 새로 생성하여 루트로 설정
                    
                    let newFirstVC = self!.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
                    navigationController.setViewControllers([newFirstVC], animated: true)
                }
                let successAlert = UIAlertController(title: "로그아웃 되었습니다", message: nil, preferredStyle: .alert)
                let rogerBtn = UIAlertAction(title: "확인", style: .default)
                successAlert.addAction(rogerBtn)
                self!.present(successAlert, animated: true, completion: nil)
                
            }
        }
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
        
    }
    
    
    @IBAction func tapMyHistoryBtn(_ sender: Any) {
       // 테이블뷰 하나 있는곳으로 이동
        let historyVC = storyboard!.instantiateViewController(identifier: "RegisterHistoryVC") as RegisterHistoryVC
        historyVC.accessToken = self.accessToken
        historyVC.userEmail = self.userEmail
        self.navigationController?.pushViewController(historyVC, animated: true)
        
    }
    
    
    
    @IBAction func tapAboutTeamBtn(_ sender: UIButton) {
        let webView = storyboard!.instantiateViewController(identifier: "AboutTeamVC") as AboutTeamVC
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
}
