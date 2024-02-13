//
//  CommunityListEndDetailVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit
import Alamofire

class CommunityListEndDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel! // 청원제목
    @IBOutlet weak var summaryLabel: UILabel! // 요약내용
    //MARK: - 상세정보 Label
    @IBOutlet weak var petitionerLabel: UILabel! // 청원인
    @IBOutlet weak var introductionMemberLabel: UILabel! // 소개의원
    @IBOutlet weak var receiptLabel: UILabel! // 접수일자
    @IBOutlet weak var CommitteeLabel: UILabel! // 소관위
    @IBOutlet weak var registrationDateLabel: UILabel! // 위원회회부일
    @IBOutlet weak var documentBtn: UIButton! // 원문버튼(차후 이미지 바꾸면됨)
    //MARK: - 토론하기 Label
    @IBOutlet weak var announcementDateLabel: UILabel! // 추첨자 발표날짜
    @IBOutlet weak var discussionDateLabel: UILabel! // 토론 날짜
    //MARK: - 결과보기 Button
    
    @IBOutlet weak var resultBtn: UIButton!
    
    var communityListEndDetailVM: CommunityListEndDetailVM!
    var selectedIndex: Int = 0
    var accessToken: String = ""
    var billNO: String = ""
    var debate_code_x: String = ""
    var linkURL: String = ""
    var folderURL: String = ""
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultBtn.layer.cornerRadius = 10
        communityListEndDetailVM = CommunityListEndDetailVM()
        getListEndDetail()
        print(" 디테일 END VC 에서 이메일 받았다 --> \(userEmail)")
    }
    
    func getListEndDetail() {
        print("CommunityListEndDetailVC - getListEndDetail() called")
        
        //토큰을 꼽아줘야지만 데이터를 받을수있음/보안상의 이유임
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(communityListEndDetailVM.getListEndDetailURL + self.billNO, method: .get, parameters: nil    , encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: CommunityListEndDetailVM.PetitionResponse.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    self.debate_code_x = petitionResponse.debate.debateCodeX
                    self.linkURL = petitionResponse.petition.linkUrl
                    self.folderURL = petitionResponse.petition.petitionFileUrl
                    
                    guard let summary = petitionResponse.petition.content else {
                        return }
                    let dateTime = petitionResponse.debate.debateDate
                    let date = String(dateTime.prefix(10))
                    let time1 = String(dateTime.dropFirst(11).prefix(2))
                    let time2 = String(dateTime.dropFirst(14).prefix(2))
                    
                    let resultDateTime = petitionResponse.debate.memberAnnouncementDate
                    let resultdate = String(dateTime.prefix(10))
                    let resultTime1 = String(dateTime.dropFirst(11).prefix(2))
                    let resultTime2 = String(dateTime.dropFirst(14).prefix(2))
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = "제목: " + petitionResponse.petition.billName
                        self.summaryLabel.text = summary
                        self.petitionerLabel.text = petitionResponse.petition.proposer
                        self.introductionMemberLabel.text = petitionResponse.petition.approver
                        self.receiptLabel.text = petitionResponse.petition.proposerDt
                        self.CommitteeLabel.text = petitionResponse.petition.currCommittee
                        self.registrationDateLabel.text = petitionResponse.petition.committeeDt
                        
                        //MARK: EndDetailVC 의 토론하기부분 라벨들
                        self.announcementDateLabel.text = "\(resultdate) " + "\(resultTime1)시" + "\(resultTime2)분"
                        self.discussionDateLabel.text = "\(date) " + "\(time1)시" + "\(time2)분"
                        
                        
                    }
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    @IBAction func tapLinkBtn(_ sender: UIButton) {
        print("링크 가봐??")
        let linkView = storyboard!.instantiateViewController(identifier: "LinkEndDetailVC") as LinkEndDetailVC
        linkView.myURL = self.linkURL
        self.navigationController?.pushViewController(linkView, animated: true)
    }
    
    
    
    @IBAction func tapFolderBtn(_ sender: UIButton) {
        print("원문 가봐?")
        let webView = storyboard!.instantiateViewController(identifier: "WebEndDetailVC") as WebEndDetailVC
        webView.myURL = self.folderURL
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
    @IBAction func tapGoResult(_ sender: UIButton) {
        let resultVC = storyboard!.instantiateViewController(identifier: "ResultDetailVC") as! ResultDetailVC
        resultVC.accessToken = self.accessToken
        resultVC.billNO = self.billNO
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    

}
