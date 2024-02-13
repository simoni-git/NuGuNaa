//
//  ApplyPopUpVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit
import Alamofire

class ApplyPopUpVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var userEmail: String = ""
    var billNO: String = ""
    var position: Int = 0
    var accessToken: String = ""
    
    var applyPopUpVM: ApplyPopUpVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyPopUpVM = ApplyPopUpVM()
        configure()
        
    }
    
    private func configure() {
        popUpView.layer.cornerRadius = 10
        okBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor(red: 25/255.0, green: 100/255.0, blue: 80/255.0, alpha: 1.0).cgColor
        cancelBtn.layer.borderWidth = 1.0
    }
    
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapOkBtn(_ sender: UIButton) {
        //세그먼트에 따라서 프린팅시키고 뷰 사라지게하기
        
        /* post로  넘겨야할 정보 3가지
         1.사용자 이메일(자기 아이디)
         2.해당 데이터의 billNM
         3.찬성 반대여부 = 찬성은 0 으로 보내고 반대는 1 로 보내기.
         
         
         */
        
        
        let selectedIndex = segment.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            print("찬성측 신청") // 찬성측으로 유저정보 보내면됨
            let alert = UIAlertController(title: "찬성측으로 신청되었습니다.", message: nil, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "확인", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            
            self.position = 0
            applyPostAPI()
            
            alert.addAction(okBtn)
            present(alert, animated: true)
        case 1:
            print("반대측 신청") // 반대측으로 유저정보 보내면됨
            let alert = UIAlertController(title: "반대측으로 신청되었습니다.", message: nil, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "확인", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            self.position = 1
            applyPostAPI()
            
            alert.addAction(okBtn)
            present(alert, animated: true)
        default:
            break
        }
    }
    
    func applyPostAPI() {
        print("ApplyPopUpVC - ostAPI() called")
        let email = self.userEmail
        let bill_no = self.billNO
        let ox = self.position
        
        let parameters: [String: Any] = [
            "email": "\(email)",
            "position": ox
        ]
        
        //토큰을 꼽아줘야지만 데이터를 받을수있음/보안상의 이유임
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(applyPopUpVM.applyURL + "\(bill_no)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("요청 성공: \(value)")
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
        
    }
    
}





