//
//  AgreeChatVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit

class AgreeChatVC: UIViewController {
    
    var seconds = 3599 // 59분59초 를 초로 나타냄
    var timer: Timer?

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startTimer() 
    }
    
    func configure() {
        contentsView.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
    
    //MARK: - 타이머 구현
    func startTimer() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer() {
           if seconds > 0 {
               seconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
           }
       }
       
       func updateUI() {
           // 초를 분과 초로 변환
           let minutes = seconds / 60
           let remainingSeconds = seconds % 60
           
           // 남은 시간을 라벨에 표시
           DispatchQueue.main.async { [weak self] in
               self!.timerLabel.text = String(format: "남은시간: %02d분%02d초", minutes, remainingSeconds)
           }
          
       }
    

//    //MARK: - 키보드 위치 조절
    override func viewWillAppear(_ animated: Bool) {
        print("AgreeChatVC - viewWillAppear() called")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("AgreeChatVC - viewWillDisappear() called")
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("AgreeChatVC - touchesBegan() called")
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShowHandle(notification: Notification) {
        //키보드 사이즈 가져와서 그만큼 올리기
        if let keyboardsize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("현재기기의 키보드 사이즈는 --> \(keyboardsize)")
            print("등록하기 버튼의 Y위치 --> \(self.registerBtn.frame.origin.y)")
            
            if (keyboardsize.height < registerBtn.frame.origin.y) {
                let distance = keyboardsize.height - registerBtn.frame.origin.y
                self.view.frame.origin.y = distance
            }
        }
    }
    
    @objc func keyboardWillHideHandle(notification: Notification) {
        //올라간 키보드 내리기
        self.view.frame.origin.y = 0
    }
    
}


/*
 AgreeChatVC
 [ v ] textView 누르면 키보드 올라오는데, 키보드 높이만큼 뷰 올려주기, 바탕터치시 다시 내려오기
 [ v ] 타이머구현
 
 타이머를 언제 울릴지는 백앤드와 상의
 

 */
