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

    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        myPageVM = MyPageVM()
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
        // 토론내역 뷰  --> 테이블뷰로 즐겨찾기마냥 보여주는걸로 상의 완료
    }
    
    
    @IBAction func tapAboutTeamBtn(_ sender: UIButton) {
        // 팀소개뷰를 만들던 해서 띄우면 될듯(모달형식으로 ㄱ)
    }
    
}
