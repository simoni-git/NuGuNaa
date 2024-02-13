//
//  AgreeChatVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit
import Alamofire

class AgreeChatVC: UIViewController {
    
    var fiveMinSeconds = 60 //300
    var oneMinSeconds = 30 // 60
    
    var timers: [Timer] = []
    let targetTimes = [15 * 60, 15 * 60 + 5, 15 * 60 + 6, 15 * 60 + 11, 15 * 60 + 16, 15 * 60 + 21, 15 * 60 + 22, 15 * 60 + 27, 15 * 60 + 28, 15 * 60 + 33, 15 * 60 + 34]
    
    var timer: Timer?
    
//    let methodMappings: [Int: () -> Void] = [
//            0: 겟 - 5-1
//            1: 포 - 1-1
//            2: 겟 - 5-2
//            3: 포 - 1-2
//            4: 겟 - 5-3
//            5: 포 - 1-3
//            6: 겟 - 5-4
//            7: 포 - 1-4
//            8: 겟 - 5-5
//            9: 포 - 1-5
//            10: 최종겟
//        ]
    
    var data: [String] = []
   
    
    var accessToken: String = ""
    var billNO: String = ""
    var position: Int = 0
    var billTitle: String = ""
    
    var agreeChatVM: AgreeChatVM!
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agreeChatVM = AgreeChatVM()
        configure()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // 테이블뷰셀의 대략적인 높이
        
        getContentAPI()
        five_Own()
        
        if self.data.isEmpty {
            data.append("안녕하세요! 이번 토론 사회자를 맡게된 AI사회자 입니다. 이번 제목인 \(self.billTitle) 에 대해서 토론을 진행하도록 하겠습니다. 등록버튼은 한번 누르시면 수정되지 않으며 모든 채팅은 150자 이내로 작성해 주세요. 입론을 먼저 서술해 주세요!")
            self.tableView.reloadData()
         }
        
        let currentTime = Calendar.current.dateComponents(in: .current, from: Date())
        let hour = currentTime.hour ?? 0
        let minute = currentTime.minute ?? 0
        let second = currentTime.second ?? 0
        let currentSeconds = hour * 3600 + minute * 60 + second
        
//        for (index, time) in targetTimes.enumerated() {
//            let interval = TimeInterval(time - currentSeconds)
//            if interval >= 0 {
//                let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
//                    self?.methodMappings[index]?()
//                }
//                timers.append(timer)
//            }
//        }
        
    }
    
    func configure() {
        contentsView.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
    
    //MARK: - 타이머 구현 5-1
    func five_Own() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer1), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer1() {
           if fiveMinSeconds > 0 {
               fiveMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               //MARK: 5-1 타이머가 종료되면 post 요청후 1-1 타이머 시작
               postGPTAPI()
               oneMinTimer1()
           }
       }
       
       func updateUI() {
           // 초를 분과 초로 변환
           let minutes = fiveMinSeconds / 60
           let remainingSeconds = fiveMinSeconds % 60
           
           // 남은 시간을 라벨에 표시
           DispatchQueue.main.async { [weak self] in
               self!.timerLabel.text = String(format: "남은시간: %02d분%02d초", minutes, remainingSeconds)
           }
          
       }
    
    //MARK: - 타이머 구현 5-2
    func five_Two() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer2), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer2() {
           if fiveMinSeconds > 0 {
               fiveMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               //MARK: 두번째 5분 카운트가 지나면 바로 1분 카운트 시작
               postGPTAPI()
               oneMinTimer2()
           }
       }
       
      
    
    //MARK: - 타이머 구현 5-3
    func five_Thr() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer3), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer3() {
           if fiveMinSeconds > 0 {
               fiveMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               postGPTAPI()
               oneMinTimer3()
           }
       }
       
      
    
    //MARK: - 타이머 구현 5-4
    func five_For() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer4), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer4() {
           if fiveMinSeconds > 0 {
               fiveMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               postGPTAPI()
               oneMinTimer4()
           }
       }
       
     
    
    //MARK: - 타이머 구현 5-5
    func five_Fiv() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer5), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer5() {
           if fiveMinSeconds > 0 {
               fiveMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               postGPTAPI()
               oneMinTimer5()
           }
       }
    
    //MARK: - 타이머 구현 1분 1-1
    func oneMinTimer1() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer6), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer6() {
           if oneMinSeconds > 0 {
               oneMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               //MARK: 1-1이 끝나면 get 으로 요청하고 바로 5-2 시작
               getContentAPI()
               five_Two()
               
           }
       }
    
    //MARK: - 타이머 구현 1분 1-2
    func oneMinTimer2() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer7), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer7() {
           if oneMinSeconds > 0 {
               oneMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               getContentAPI()
               five_Thr()
               
           }
       }
    
    //MARK: - 타이머 구현 1분 1-3
    func oneMinTimer3() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer8), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer8() {
           if oneMinSeconds > 0 {
               oneMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               getContentAPI()
               five_For()
               
           }
       }
    
    //MARK: - 타이머 구현 1분 1-4
    func oneMinTimer4() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer9), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer9() {
           if oneMinSeconds > 0 {
               oneMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               getContentAPI()
               five_Fiv()
               
           }
       }
    
    //MARK: - 타이머 구현 1분 1-5
    func oneMinTimer5() {
           // 이전 타이머가 있으면 무효화
           timer?.invalidate()
           
           // 1초마다 업데이트
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer10), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer10() {
           if oneMinSeconds > 0 {
               oneMinSeconds -= 1
               updateUI()
           } else {
               // 타이머 종료
               timer?.invalidate()
               timer = nil
               getContentAPI()
               
//               토론 종료됬다고 알럿 띄우고
//               채팅창 등록버튼 지우기
               self.registerBtn.isHidden
               let alert = UIAlertController(title: "토론이 종료되었습니다.", message: nil, preferredStyle: .alert)
               let okBtn = UIAlertAction(title: "확인", style: .default)
               alert.addAction(okBtn)
               present(alert, animated: true)

               
           }
       }
    
      
    //MARK: - 등록하기 버튼 클릭
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        guard let text = textView.text else {return}
        self.data.append(text)
        self.tableView.reloadData()
        //myTextPostAPI()
        self.textView.text = nil
    
        // 등록버튼 누르면 바로 최신데이터가 보일수있게 스크롤해줌
        let indexPath = IndexPath(row: self.data.count - 1, section: 0)
           self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        // 키보드 감추기
            self.view.endEditing(true)
            // 뷰 위치 원래대로 복구
            self.view.frame.origin.y = 0
    }
    
   
    //MARK: - postGPT
    func postGPTAPI() {
        print("찬성채팅자아앙~~~postGPTAPI calledddddddddd~~")
        //타이머가 지나면서 포스트가울리던 여튼 포스트가 울릴때마다 qType 의 변수가 1씩 올라가도록 구현해야함.
        //일단임시로 해보겠음
        
        agreeChatVM.qType += 1
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(  agreeChatVM.postGPTLeftURL + "\(self.billNO)" + agreeChatVM.postGPTLMidURL + agreeChatVM.postGPTRightURL + "\(agreeChatVM.qType)"
            , method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: AgreeChatVM.StatementGPTData.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    
                   
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    
    //MARK: - postAPI
    func myTextPostAPI() {
        
        //타이머가 지나면서 포스트가울리던 여튼 포스트가 울릴때마다 qType 의 변수가 1씩 올라가도록 구현해야함.
        //일단임시로 해보겠음
        
       
        
        guard let text = self.textView.text else {return}
        
         let parameters: [String: Any] = [
             "content": "\(text)"
         ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request( agreeChatVM.postLeftURL + "\(self.billNO)" + agreeChatVM.postMidURL + agreeChatVM.postRightURL + "\(agreeChatVM.qType)"
            , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: AgreeChatVM.StatementData.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                   
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
         
    }
    
    //MARK: - getAPI
    
        func getContentAPI() {
            print("AgreeChatVC - getContentAPI() called")
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(self.accessToken)"
            ]
            
            AF.request(agreeChatVM.getLeftURL + "\(self.billNO)" + agreeChatVM.getRightURL
                , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
                .responseDecodable(of: [AgreeChatVM.ContentData].self) { response in
                    switch response.result {
                    case .success(let petitionResponse):
                        // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                        print("요청 성공: \(petitionResponse)")
                       
                       
                    case .failure(let error):
                        print("요청 실패: \(error)")
                    }
                }
    }

    //MARK: - 키보드 위치 조절
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


extension AgreeChatVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgreeChatCell") as? AgreeChatCell else {
            return UITableViewCell()
        }
        let data = data[indexPath.row]
//        cell.mentLabel.text = data
        
        // 짝수 번째 셀인지 확인하여 레이아웃을 조정합니다.
        if indexPath.row % 2 == 0 {
            cell.mentLabel.text = "AI사회자: \(data)"
            // 짝수 번째 셀: 셀을 왼쪽에 붙이고 오른쪽 마진을 추가합니다.
            cell.mentLabel.textAlignment = .left
            cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
        } else {
            cell.mentLabel.text = "나: \(data)"
            // 홀수 번째 셀: 셀을 오른쪽에 붙이고 왼쪽 마진을 추가합니다.
            cell.mentLabel.textAlignment = .right
            cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16)
        }
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 10
        cell.layer.cornerRadius = 10
        
        cell.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




class AgreeChatCell: UITableViewCell {
    
    @IBOutlet weak var mentLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0 , bottom: 5, right: 0))
        
    }
}

