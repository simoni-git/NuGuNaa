//
//  DisagreeVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit
import Alamofire

class DisagreeChatVC: UIViewController {
    
    var fiveMinSeconds = 60 // 300
    var oneMinSeconds = 30 // 60
    var timers: [Timer] = []
    let targetTimes = [15 * 60, 15 * 60 + 5, 15 * 60 + 6, 15 * 60 + 11, 15 * 60 + 16, 15 * 60 + 21, 15 * 60 + 22, 15 * 60 + 27, 15 * 60 + 28, 15 * 60 + 33, 15 * 60 + 34]
    var timer: Timer?
    
       
        
        var data: [String] = []
    
   // var timerManager = TimerManager
    
//    
//    //MARK: 실험
//    
//    var currentTimerIndex = 0
//        let timerCountPerGroup = 5
//        let timerInterval: TimeInterval = 60 // 각 타이머 간격 (초)
//
//        func startTimers() {
//            startNextTimer()
//        }
//
//        func startNextTimer() {
//            if currentTimerIndex < timerCountPerGroup * 2 {
//                let currentGroup = currentTimerIndex / timerCountPerGroup + 1
//                let currentTimerInGroup = currentTimerIndex % timerCountPerGroup + 1
//                
//                print("Starting timer \(currentGroup)-\(currentTimerInGroup)")
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + timerInterval) {
//                    print("Timer \(currentGroup)-\(currentTimerInGroup) finished")
//                    self.currentTimerIndex += 1
//                    self.startNextTimer()
//                }
//            } else {
//                print("All timers finished")
//            }
//        }
//    
//
//   
//    
//    //
    var accessToken: String = ""
    var billNO: String = ""
    var position: Int = 1
    var billTitle: String = ""
    
    var disagreeChatVM: DisagreeChatVM!
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disagreeChatVM = DisagreeChatVM()
        tableView.dataSource = self
        tableView.delegate = self
        configure()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // 테이블뷰셀의 대략적인 높이
        //MARK: 채팅방 들어오자마자 get 호출
        getContentAPI()
        //MARK:  get 호출 후 바로 5분 타이머 시작
        //five_Own()
        
//        timerManager.delegate = self
//        timerManager.startTimers()
        
//        if self.data.isEmpty {
//            data.append("안녕하세요! 이번 토론 사회자를 맡게된 AI사회자 입니다. 이번 제목인 \(self.billTitle) 에 대해서 토론을 진행하도록 하겠습니다. 등록버튼은 한번 누르시면 수정되지 않으며 모든 채팅은 150자 이내로 작성해 주세요. 입론을 먼저 서술해 주세요!")
//            self.tableView.reloadData()
//         }
        
        let currentTime = Calendar.current.dateComponents(in: .current, from: Date())
        let hour = currentTime.hour ?? 0
        let minute = currentTime.minute ?? 0
        let second = currentTime.second ?? 0
        let currentSeconds = hour * 3600 + minute * 60 + second
        
       
    }
    
    private func configure() {
        contentsView.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
    

    
    //MARK: - postGPT
    func postGPTAPI() {
        print(" 반대 채팅창~~. postGPTAPI calledddddddddd~~")
        //타이머가 지나면서 포스트가울리던 여튼 포스트가 울릴때마다 qType 의 변수가 1씩 올라가도록 구현해야함.
        //일단임시로 해보겠음
        
       
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request( disagreeChatVM.postGPTLeftURL + "\(self.billNO)" + disagreeChatVM.postGPTLMidURL + disagreeChatVM.postGPTRightURL + "\(disagreeChatVM.qType)"
            , method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: DisagreeChatVM.StatementGPTData.self) { response in
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
        
        AF.request( disagreeChatVM.postLeftURL + "\(self.billNO)" + disagreeChatVM.postMidURL + disagreeChatVM.postRightURL + "\(disagreeChatVM.qType)"
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
            
            disagreeChatVM.qType += 1
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(self.accessToken)"
            ]
            
            AF.request(disagreeChatVM.getLeftURL + "\(self.billNO)" + disagreeChatVM.getRightURL
                , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
                .responseDecodable(of: [DisagreeChatVM.ContentData].self) { response in
                    switch response.result {
                    case .success(let petitionResponse):
                        // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                        print("요청 성공: \(petitionResponse)")
                        self.disagreeChatVM.data.removeAll()
                        
                        let filteredData = petitionResponse.filter { $0.isChatGPT }
                        self.disagreeChatVM.data.append(contentsOf: filteredData)
                        print(" 몇개냐???  \(self.disagreeChatVM.data.count)")
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        
                    case .failure(let error):
                        print("요청 실패: \(error)")
                    }
                }
    }
    
   
    //MARK: - 키보드 위치 조절
    override func viewWillAppear(_ animated: Bool) {
        print("DisagreeChatVC - viewWillAppear() called")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DisagreeChatVC - viewWillDisappear() called")
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DisagreeChatVC - touchesBegan() called")
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
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        guard let text = textView.text else {return}
       // self.data.append(text)
        //self.tableView.reloadData()
        //MARK: 버튼이 눌렸을 경우 텍스트를 토대로 Post
        myTextPostAPI()
        self.textView.text = nil
    
         //등록버튼 누르면 바로 최신데이터가 보일수있게 스크롤해줌
//        let indexPath = IndexPath(row: self.data.count, section: 0)
//           self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        // 키보드 감추기
//            self.view.endEditing(true)
//            // 뷰 위치 원래대로 복구
//            self.view.frame.origin.y = 0
    }
    
    
    //⬇️
    
   
    @IBAction func b(_ sender: UIButton) {
        self.postGPTAPI()
    }
    
    
    @IBAction func c(_ sender: UIButton) {
        self.getContentAPI()
    }
    
    
    @IBAction func d(_ sender: UIButton) {
        self.postGPTAPI()
    }
    
    
    @IBAction func e(_ sender: UIButton) {
        self.getContentAPI()
    }
    
    
    
    @IBAction func f(_ sender: UIButton) {
        self.postGPTAPI()
    }
    
    
    @IBAction func g(_ sender: UIButton) {
        self.getContentAPI()
    }
    
    
    @IBAction func h(_ sender: UIButton) {
        self.postGPTAPI()
    }
    
    
    
    
    
    @IBAction func i(_ sender: UIButton) {
        self.getContentAPI()
    }
    
    
    @IBAction func j(_ sender: UIButton) {
        self.postGPTAPI()
    }
    
    
    @IBAction func k(_ sender: UIButton) {
        self.getContentAPI()
    }
    
    
    
    
}

extension DisagreeChatVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disagreeChatVM.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DisagreeChatCell") as? DisagreeChatCell else {
            return UITableViewCell()
        }
//        let myData = self.data[indexPath.row]
//        cell.mentLabel.text = myData
        
        let item = disagreeChatVM.data[indexPath.row]
        let text = item.content
        cell.mentLabel.text = text
        
        // 짝수 번째 셀인지 확인하여 레이아웃을 조정합니다.
        if indexPath.row % 2 == 0 {
            cell.mentLabel.text = "AI사회자: \(text)"
            // 짝수 번째 셀: 셀을 왼쪽에 붙이고 오른쪽 마진을 추가합니다.
            cell.mentLabel.textAlignment = .left
            cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
        } else {
            cell.mentLabel.text = "나: \(text)"
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

class DisagreeChatCell: UITableViewCell {
    
    @IBOutlet weak var mentLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0 , bottom: 5, right: 0))
        
    }
    
}

//extension DisagreeChatVC: TimerManagerDelegate {
//    func updateTimerLabel(timeString: String) {
//        DispatchQueue.main.async {
//            self.timerLabel.text = timeString
//        }
//    }
//}

//class TimerManager {
//    
//    init(delegate: TimerManagerDelegate? = nil, fiveMinuteTimer: Timer? = nil, oneMinuteTimer: Timer? = nil, currentCycle: Int = 0, disagreeVC: DisagreeChatVC) {
//        self.delegate = delegate
//        self.fiveMinuteTimer = fiveMinuteTimer
//        self.oneMinuteTimer = oneMinuteTimer
//        self.currentCycle = currentCycle
//        self.disagreeVC = disagreeVC
//    }
//    weak var delegate: TimerManagerDelegate?
//    var fiveMinuteTimer: Timer?
//    var oneMinuteTimer: Timer?
//    var currentCycle = 0
//    var disagreeVC: DisagreeChatVC
//    
//    func startTimers() {
//        startFiveMinuteTimer()
//    }
//    
//    func startFiveMinuteTimer() {
//        print("Starting 5-minute timer for cycle \(currentCycle + 1)")
//        fiveMinuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { _ in
//            self.fiveMinuteTimer?.invalidate()
//            self.startOneMinuteTimer()
//            self.handleAPICall()
//            self.currentCycle += 1
//            if self.currentCycle == 5 {
//                print("All cycles finished")
//            }
//            DispatchQueue.main.async {
//                self.delegate?.updateTimerLabel(timeString: "5:00")
//            }
//        }
//    }
//    
//    func startOneMinuteTimer() {
//        print("Starting 1-minute timer for cycle \(currentCycle + 1)")
//        oneMinuteTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { _ in
//            self.oneMinuteTimer?.invalidate()
//            self.startFiveMinuteTimer()
//        }
//    }
//    
//    func handleAPICall() {
//        switch currentCycle {
//        case 0:
//            getContentAPI()
//        case 1:
//            getContentAPI()
//        case 2:
//            getContentAPI()
//        case 3:
//            getContentAPI()
//        case 4:
//            getContentAPI()
//        default:
//            break
//        }
//    }
//    
//    func getContentAPI() {
//        // Implement your API call logic here
//        print("API call )")
//        disagreeVC.postGPTAPI()
//        
//    }
//}
//
//protocol TimerManagerDelegate: AnyObject {
//    func updateTimerLabel(timeString: String)
//}
