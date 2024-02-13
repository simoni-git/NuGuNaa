//
//  InputCodePopUpView.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit

class InputCodePopUpView: UIViewController {

    var debate_code_O: String = "" // 찬성코드
    var debate_code_x: String = "" // 반대코드
    var billNo: String = ""
    var accessToken: String = ""
    var billTitle: String = ""
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var inputCodeTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        print("찬성코드는 \(debate_code_O) 이거고, 반대코드는 \(debate_code_x) 이건데 알아서 사용해")

    }
    
    func configure() {
        popUpView.layer.cornerRadius = 10
        okBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor(red: 25/255.0, green: 100/255.0, blue: 80/255.0, alpha: 1.0).cgColor
        cancelBtn.layer.borderWidth = 1.0
        
    }
    
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOkBtn(_ sender: UIButton) {
        let alertTitle: String
        let alertMessage: String?
        let agreeAction: UIAlertAction
        let disagreeAction: UIAlertAction
        
        guard let code = inputCodeTextField.text else { return }
        
        if code == debate_code_O {
            alertTitle = "찬성측 코드입니다"
            alertMessage = nil
            agreeAction = UIAlertAction(title: "찬성측 채팅방으로 이동", style: .default) { [weak self] _ in
                self!.moveToAgreeChatVC()
                print("찬성±±")
            }
            disagreeAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        }
        
        else if code == debate_code_x {
            alertTitle = "반대측 코드입니다"
            alertMessage = nil
            agreeAction = UIAlertAction(title: "반대측 채팅방으로 이동", style: .default) { [weak self] _ in
                self!.moveToDisAgreeChatVC()
                print("반대±±")
            }
            disagreeAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        }
        
        else {
            alertTitle = "코드가 일치하지 않습니다"
            alertMessage = nil
            agreeAction = UIAlertAction(title: "다시작성하기", style: .default, handler: nil)
            disagreeAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(agreeAction)
        alert.addAction(disagreeAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func moveToAgreeChatVC() {
       
            guard let naviController = navigationController else {
                print("네비게이션 컨트롤러가 nil입니다.")
                return
            }
            guard let agreeChatVC = storyboard?.instantiateViewController(withIdentifier: "AgreeChatVC") as? AgreeChatVC else {
                print("AgreeChatVC를 가져올 수 없습니다.")
                return
            }
        
        agreeChatVC.accessToken = self.accessToken
        agreeChatVC.billNO = self.billNo
        agreeChatVC.billTitle = self.billTitle
        naviController.popViewController(animated: true)// << 이 뷰는 네비게이션 스텍에서 지우고 다음줄에서 push뷰컨을 통해 다음뷰만 스텍에 추가, popview 를 다음줄에 써버리면 뷰가 이동후에 스텍에서 지워지는 사태가 발생함
        naviController.pushViewController(agreeChatVC, animated: true)
        
        
    }

    func moveToDisAgreeChatVC() {
        guard let naviController = navigationController else {
            print("네비게이션 컨트롤러가 nil입니다.")
            return
        }
        guard let disAgreeChatVC = storyboard?.instantiateViewController(withIdentifier: "DisagreeChatVC") as? DisagreeChatVC else {
            print("DisagreeChatVC를 가져올 수 없습니다.")
            return
        }
        
        disAgreeChatVC.accessToken = self.accessToken
        disAgreeChatVC.billNO = self.billNo
        disAgreeChatVC.billTitle = self.billTitle
        naviController.popViewController(animated: true)// << 이 뷰는 네비게이션 스텍에서 지우고 다음줄에서 push뷰컨을 통해 다음뷰만 스텍에 추가, popview 를 다음줄에 써버리면 뷰가 이동후에 스텍에서 지워지는 사태가 발생함
        naviController.pushViewController(disAgreeChatVC, animated: true)
        
    }
    
}



/*
 구현해야할것
 1. 텍스트필드로 코드를 받은것을 DB 에있는 코드와 동일하면 확인버튼을 눌렀을때 채팅채널입장
 2. 취소버튼을 누르면 뷰 사라짐.
 */
