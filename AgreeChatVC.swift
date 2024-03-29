//
//  AgreeChatVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit
import Alamofire

class AgreeChatVC: UIViewController {
    

    var accessToken: String = ""
    var billNO: String = ""
    var billTitle: String = ""
    
    var agreeChatVM: AgreeChatVM!
    var timer: Timer?
//    var timer2: Timer?
//    var timer3: Timer?
    
//    var remaining479Seconds = 479 // 타이머 초 초기값 설정 7분59초
//    var remaining119Seconds = 119 // 타이머 초 초기값 설정 1분59초
    
    private var repeatsCount = 5
    private let runTime = 480 // 실제 앱 8분
    private let waitTime = 120 // 실제 앱 2분
    
    private let countdownTimer = CountDownTimer()
    
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
        tableView.estimatedRowHeight = 60 // 테이블뷰셀의 대략적인 높이
        
        timer?.fire()
        // 1초마다 checkTime 메서드를 호출하는 타이머 설정
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkTime), userInfo: nil, repeats: true)
      
    }
    
    func configure() {
        contentsView.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        registerBtn.isHidden = true
    }
    
    //MARK: - 타이머 구현 비동기처리버전
    
    
    func startTimer(duration: Int , text: String , completion: (() -> Void)? = nil) {
        countdownTimer.stop()
        countdownTimer.start(duration: TimeInterval(duration)) { [weak self] remainingTime in
            self?.newUpdateTimerLabel(text: "\(text) : \(remainingTime)초")
            if remainingTime == 0 {
                //만약 남은시간이 0이라면 이블록을해라
                completion?()
            }
        }
        newUpdateTimerLabel(text: "\(text): \(duration)초")
    }
    
    func newUpdateTimerLabel(text: String) {
       // timeLabel에 남은 시간을 표시합니다.
       DispatchQueue.main.async {
           self.timerLabel.text = text
       }
   }
    
    func startTalk() {
        guard repeatsCount > 0 else {
            endTalk()
            return
        }
        startTimer(duration: runTime, text: "제한시간") {
            self.serverGet()
            self.registerBtn.isHidden = false
            self.startTimer(duration: self.waitTime, text: "대기시간") {
                self.toGPTPost()
                self.registerBtn.isHidden = true
                self.startTalk()
            }
        }
        repeatsCount -= 1
    }
    
    func endTalk() {
       timerLabel.text = "토론종료"
        registerBtn.isHidden = true
   }
    
    //MARK: - 타이머구현
//    func start299SecondTimer() {
//        // 타이머가 이미 실행 중인지 확인하고, 실행 중이라면 종료합니다.
//        print("start299SecondTimer - called ")
//        if let timer2 = timer2, timer2.isValid {
//            timer2.invalidate()
//        }
//        
//        // 1초마다 updateTimerLabel 메서드를 호출하는 타이머 설정
//        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
//        
//        // 타이머가 시작될 때 timeLabel을 업데이트합니다.
//        updateTimerLabel()
//    }
    
//    @objc func updateTimerLabel() {
//           // timeLabel에 남은 시간을 표시합니다.
//        DispatchQueue.main.async { [weak self] in
//            self!.timerLabel.text = "제한시간: \(self!.remaining479Seconds)초"
//        }
//           
//           // 0초일 때에는 타이머를 정지하고 초기화
//           if remaining479Seconds == 0 {
//               timer2?.invalidate()
//               remaining479Seconds = 479
//               self.registerBtn.isHidden = true
//           } else {
//               // 남은 시간 감소
//               remaining479Seconds -= 1
//           }
//       }
    
//    func start119SecondTimer() {
//        // 타이머가 이미 실행 중인지 확인하고, 실행 중이라면 종료합니다.
//        print("start119SecondTimer - called ")
//        if let timer3 = timer3, timer3.isValid {
//            timer3.invalidate()
//        }
//        
//        // 1초마다 updateTimerLabel 메서드를 호출하는 타이머 설정
//        timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel2), userInfo: nil, repeats: true)
//        
//        // 타이머가 시작될 때 timeLabel을 업데이트합니다.
//        updateTimerLabel2()
//    }
//    
//    @objc func updateTimerLabel2() {
//           // timeLabel에 남은 시간을 표시합니다.
//        DispatchQueue.main.async { [weak self] in
//            self!.timerLabel.text = "대기하세요: \(self!.remaining119Seconds)초"
//        }
//           
//           // 0초일 때에는 타이머를 정지하고 초기화
//           if remaining119Seconds == 0 {
//               timer3?.invalidate()
//               remaining119Seconds = 119 
//               self.registerBtn.isHidden = false
//           } else {
//               // 남은 시간 감소
//               remaining119Seconds -= 1
//           }
//       }
    
    @objc func checkTime() {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate)
        
        guard let hour = components.hour, let minute = components.minute, let second = components.second else {
            return
        }
        
        // 15시 00분 00초 입장 get 호출 / 실험할때는 제거하고 뷰 입장하자마자 울리도록 구현해놓을것
        if (hour == 15) && minute == 00 && second == 0 {
            getContentAPI()
            //start299SecondTimer()
            startTalk()
            registerBtn.isHidden = false
            
        }
    }
    
        
//        // 15시 06분 00초 post 호출
//        if (hour == 15) && minute == 08 && second == 0 {
//            toGPTPost()
//            start119SecondTimer()
//        }
//        
//        // 15시 07분 00초 get 호출
//        if (hour == 15) && minute == 10 && second == 0 {
//            serverGet()
//            start299SecondTimer()
//        }
//        
//        // 15시 13분 00초 post 호출
//        if (hour == 15) && minute == 18 && second == 0 {
//            toGPTPost()
//            start119SecondTimer()
//        }
//        
//        // 15시 14분 00초 get 호출
//        if (hour == 15) && minute == 20 && second == 0 {
//            serverGet()
//            start299SecondTimer()
//        }
//        
//        // 15시 20분 00초 post 호출
//        if (hour == 15) && minute == 28 && second == 0  {
//             toGPTPost()
//            start119SecondTimer()
//        }
//        
//        // 15시 21분 00초 get 호출
//        if (hour == 15) && minute == 30 && second == 0  {
//             serverGet()
//            start299SecondTimer()
//        }
//        
//        // 15시 27분 00초 post 호출
//        if (hour == 15) && minute == 38 && second == 0  {
//             toGPTPost()
//            start119SecondTimer()
//        }
//        
//        // 15시 28분 00초 get 호출
//        if (hour == 15) && minute == 40 && second == 0  {
//             serverGet()
//            start299SecondTimer()
//        }
//        
//        // 15시 34분 00초 post 호출
//        if (hour == 15) && minute == 48 && second == 0  {
//             toGPTPost()
//            start119SecondTimer()
//        }
//        
//        // 15시 35분 00초 get 호출
//        if (hour == 15) && minute == 50 && second == 0  {
//            serverGet()
//            registerBtn.isHidden = true
//            timerLabel.text = "토론종료"
//            textView.text = "토론이 종료되었습니다. 채팅방에서 나가주셔도 됩니다."
//        }
//    }
    
    func toGPTPost() {
        print("AgreeChatVC - toGPTPost() called 호출됨")
        postGPTAPI()
        
    }
    
    func serverGet() {
        print("AgreeChatVC - serverGet() called 호출됨")
        getContentAPI()
      }
      
    //MARK: - 등록하기 버튼 클릭
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        guard let text = textView.text else {return}
        myTextPostAPI()
        self.agreeChatVM.data.append(text)
        self.tableView.reloadData()
        self.textView.text = nil
        self.registerBtn.isHidden = true
    
        // 등록버튼 누르면 바로 최신데이터가 보일수있게 스크롤해줌
        let indexPath = IndexPath(row: self.agreeChatVM.data.count - 1, section: 0)
           self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        // 키보드 감추기
            self.view.endEditing(true)
            // 뷰 위치 원래대로 복구
            self.view.frame.origin.y = 0
    }
    
   
    //MARK: - postGPT
    func postGPTAPI() {
        print("AgreeChatVC - postGPTAPI() called ")
        
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
       print("AgreeChatVC - myTextPostAPI() called  ")
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
            
            agreeChatVM.qType += 1
            
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
                        self.agreeChatVM.data.removeAll()
                        self.agreeChatVM.data.append("안녕하세요! 이번 토론 사회자를 맡게된 AI사회자 입니다. 이번 제목인 \(self.billTitle) 에 대해서 토론을 진행하도록 하겠습니다. 등록버튼은 한번 누르시면 수정되지 않습니다. 입론을 시작하겠습니다. 자신의 의견을 서술해 주세요!")
                        let content = petitionResponse.map { $0.content }
                        self.agreeChatVM.data.append(contentsOf: content)
                        //self.data = petitionResponse.map { $0.content }
                        self.tableView.reloadData()
                        //등록버튼 누르면 바로 최신데이터가 보일수있게 스크롤해줌
                        let indexPath = IndexPath(row: self.agreeChatVM.data.count - 1, section: 0)
                          self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        
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
        return self.agreeChatVM.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgreeChatCell") as? AgreeChatCell else {
            return UITableViewCell()
        }
        
        let data = self.agreeChatVM.data[indexPath.row]
        cell.mentLabel.text = data
        
        if indexPath.row % 2 == 0 {
            
            cell.leadingConstant.constant = 10
            cell.trailingConstant.constant = 70
            cell.subView.backgroundColor = UIColor(hex: "26A69A")
            cell.mentLabel.textColor = .white
        } else {
            
            cell.leadingConstant.constant = 70
            cell.trailingConstant.constant = 10
            cell.subView.backgroundColor = .white
            cell.mentLabel.textColor = .black
            
            }
        
        cell.subView.layer.cornerRadius = 10
 
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class AgreeChatCell: UITableViewCell {
    
    @IBOutlet weak var mentLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var trailingConstant: NSLayoutConstraint!
    @IBOutlet weak var leadingConstant: NSLayoutConstraint!
 
}

class CountDownTimer {
    private var timer: Timer?
    private var remainingTime: TimeInterval = 0
    
    func start(duration: TimeInterval , action: @escaping (Int) -> Void) {
        remainingTime = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            //1초마다 뭐할래?
            guard let self, self.remainingTime > 0 else {
                //self.remainingTime 이 0보다 크지않다면 여기블록을
                self?.stop()
                action(0)
                return
            }
            //self.remainingTime 이 0보다 크다면 여기블록을 타게됨
            self.remainingTime -= 1
            action(Int(remainingTime)) //(Int(remainingTime)) 로 표현한 이유는 TimeInterval 은 더블형의 타입엘리스임. 즉 Double 형의 별명이라는거임. 그래서 Int 로 감싸줘서 정수로 만들어줘야함.
            
        })
    }
    
    func stop() {
        remainingTime = 0
        timer?.invalidate()
        timer = nil
    }
    
}
