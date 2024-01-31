//
//  InputCodePopUpView.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit

class InputCodePopUpView: UIViewController {

    let exampleCode1 = "123" // 찬성측코드예시
    let exampleCode2 = "456" // 반대측코드예시
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var inputCodeTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

      
    }
    
    func configure() {
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
        let alertTitle: String
        let alertMessage: String?
        let agreeAction: UIAlertAction
        let disagreeAction: UIAlertAction
        
        guard let code = inputCodeTextField.text else { return }
        
        if code == exampleCode1 {
            alertTitle = "찬성측 코드입니다"
            alertMessage = nil
            agreeAction = UIAlertAction(title: "찬성측 채팅방으로 이동", style: .default) { [weak self] _ in
                self!.moveToAgreeChatVC()
                print("찬성±±")
            }
            disagreeAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        }
        
        else if code == exampleCode2 {
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
       
            guard let navController = navigationController else {
                print("네비게이션 컨트롤러가 nil입니다.")
                return
            }
            guard let agreeChatVC = storyboard?.instantiateViewController(withIdentifier: "AgreeChatVC") as? AgreeChatVC else {
                print("AgreeChatVC를 가져올 수 없습니다.")
                return
            }
            navController.pushViewController(agreeChatVC, animated: true)
        
    }

    func moveToDisAgreeChatVC() {
        guard let navController = navigationController else {
            print("네비게이션 컨트롤러가 nil입니다.")
            return
        }
        guard let disAgreeChatVC = storyboard?.instantiateViewController(withIdentifier: "DisagreeChatVC") as? DisagreeChatVC else {
            print("DisagreeChatVC를 가져올 수 없습니다.")
            return
        }
        navController.pushViewController(disAgreeChatVC, animated: true)
    }
    
}



/*
 구현해야할것
 1. 텍스트필드로 코드를 받은것을 DB 에있는 코드와 동일하면 확인버튼을 눌렀을때 채팅채널입장
 2. 취소버튼을 누르면 뷰 사라짐.
 */
