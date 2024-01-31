//
//  LoginInputUserInfoVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/24/24.
//

import UIKit
import Alamofire

class LoginInputUserInfoVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var loginInputUserInfoVM: LoginInputUserInfoVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginInputUserInfoVM = LoginInputUserInfoVM()
        loginBtn.layer.cornerRadius = 10
        pwTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - textField Add Target
    @objc func textFieldDidChange(_ sender: Any?) {
        loginBtn.isHidden =  !(pwTextField.text?.isEmpty == false)
    }
    
    //MARK: - @IBAction
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let pw = pwTextField.text else { return }
        
        let parameters: [String: Any] = [
            "email": "\(email)",
            "password": "\(pw)"
        ]
        
        AF.request(loginInputUserInfoVM.loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let value):
                    print("요청 성공: \(value)")
                    
                    // JSON 데이터를 파싱하여 TokenResponse 모델에 매핑
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let tokenResponse = try decoder.decode(LoginInputUserInfoVM.TokenResponse.self, from: data)
                            
                            // 토큰 값을 변수에 저장
                            let token = tokenResponse.token
                            // 변수에 저장된 토큰값을 뷰모델에도 저장
                            self!.loginInputUserInfoVM.accessToken = tokenResponse.token.access
                            print("받은 토큰: \(token)")
                            
                        } catch {
                            print("토큰 파싱 실패: \(error)")
                        }
                    }
                    // 요청에 성공하여 회원인게 인증됬으니 뷰를 이동시킴
                    guard let tabBarController = self!.storyboard?.instantiateViewController(withIdentifier: "YourTabBarControllerIdentifier") as? UITabBarController else {
                        return
                    }
                    let communityListVC = self!.storyboard?.instantiateViewController(withIdentifier: "CommunityListVC") as! CommunityListVC
                    let myPageVC = self!.storyboard?.instantiateViewController(withIdentifier: "MyPageVC") as! MyPageVC
                    
                    communityListVC.accessToken = self!.loginInputUserInfoVM.accessToken
                    myPageVC.accessToken = self!.loginInputUserInfoVM.accessToken
                    
                    
                    tabBarController.setViewControllers([communityListVC, myPageVC], animated: false)
                    // 탭 바 컨트롤러를 루트 뷰 컨트롤러로 설정하여 이동
                    self!.navigationController?.setViewControllers([tabBarController], animated: true)
//                    self!.navigationController?.pushViewController(tabBarController, animated: true)
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                    //요청에 실패하여 회원이 아닌것 같으니 알럿 띄움
                    let failAlert = UIAlertController(title: "정보가 올바르지 않습니다.", message: nil, preferredStyle: .alert)
                    let retry = UIAlertAction(title: "다시작성하기", style: .default, handler: nil)
                    failAlert.addAction(retry)
                    self!.present(failAlert, animated: true)
                }
            }
        
    }
    
    /*
     해야할일
     1. 버튼을 눌렀을때 api 통신을 통해 해당아이디가 유효한 아이디인지 확인한다.
     2. 유효한 아이디라면 뷰를 이동시킨다.
     3. 유효하지 않다면 fail 알럿을 띄운다. + 네비게이션스텍을 삭제할수 있으면 더 좋다.
     
     let failAlert = UIAlertController(title: "정보가 올바르지 않습니다.", message: nil, preferredStyle: .alert)
     let retry = UIAlertAction(title: "다시작성하기", style: .default, handler: nil)
     failAlert.addAction(retry)
     present(failAlert, animated: true)
     */
    
}



/*
 해야할것
 [ v ] 텍스트필드 두개에 비밀번호가 작성되기 전에는 버튼 히든
 [ ] 아이디와 비밀번호가 일치하지 않으면 알럿창 띄우기
 [ ] 일치하면 다음화면 이동인데, 네비게이션 스텍지우기
 */
