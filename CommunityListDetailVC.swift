//
//  CommunityListDetailVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/24/24.
//

import UIKit
import Alamofire

class CommunityListDetailVC: UIViewController {
    
    var communityListDetailVM: CommunityListDetailVM!
    var selectedIndex: Int = 0
    var accessToken: String = ""
    var billNO: String = ""
    var debate_code_O: String = ""
    var linkURL: String = ""
    var folderURL: String = ""
    
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
    //MARK: - Button
    
    @IBOutlet weak var proposeBtn: UIButton! // 신청하기버튼
    @IBOutlet weak var debateBtn: UIButton! // 토론하기버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communityListDetailVM = CommunityListDetailVM()
        configure()
        getListDetail()
    }
    
    private func configure() {
        debateBtn.layer.cornerRadius = 10
        proposeBtn.layer.cornerRadius = 10
        proposeBtn.layer.borderColor = UIColor(red: 25/255.0, green: 100/255.0, blue: 80/255.0, alpha: 1.0).cgColor
        proposeBtn.layer.borderWidth = 1.0
    }
    
    func getListDetail() {
        
        print("CommunityListDetailVC - getListDetail() called")
        
        //토큰을 꼽아줘야지만 데이터를 받을수있음/보안상의 이유임
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(communityListDetailVM.getListDetailURL + self.billNO, method: .get, parameters: nil    , encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: CommunityListDetailVM.PetitionResponse.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    self.debate_code_O = petitionResponse.debate.debateCodeO
                    self.linkURL = petitionResponse.petition.linkUrl
                    self.folderURL = petitionResponse.petition.petitionFileUrl
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = "제목: " + petitionResponse.petition.billName
                        self.summaryLabel.text = petitionResponse.petition.content ?? ""
                        self.petitionerLabel.text = petitionResponse.petition.proposer
                        self.introductionMemberLabel.text = petitionResponse.petition.approver
                        self.receiptLabel.text = petitionResponse.petition.proposerDt
                        self.CommitteeLabel.text = petitionResponse.petition.currCommittee
                        self.registrationDateLabel.text = petitionResponse.petition.committeeDt
                        
                        //MARK: EndDetailVC 의 토론하기부분 라벨들
                        self.announcementDateLabel.text = petitionResponse.debate.memberAnnouncementDate
                        self.discussionDateLabel.text = petitionResponse.debate.debateDate
                    }
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    @IBAction func tapFolderBtn(_ sender: UIButton) {
        print("원문 가봐?")
        let webView = storyboard!.instantiateViewController(identifier: "WebDetailVC") as WebDetailVC
        webView.myURL = self.folderURL
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
    
    @IBAction func tapLinkBtn(_ sender: UIButton) {
        print("링크 가봐??")
        let linkView = storyboard!.instantiateViewController(identifier: "LinkDetailVC") as LinkDetailVC
        linkView.myURL = self.linkURL
        self.navigationController?.pushViewController(linkView, animated: true)
    }
    
    
}





/*
 구현해야할것
 
 [ ] 처음에는 신청하기버튼만 누를수있고 토론하기버튼은 누를수 없음
 [ ] 신청하기 눌렀을때 간단한 뷰를 띄워서 버튼들 만들기
 [ ] 토론하기 눌렀을때 간단한 뷰 띄워서 코드입력텍스트필드와 버튼들 만들기
 
 */
