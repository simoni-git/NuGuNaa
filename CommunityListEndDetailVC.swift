//
//  CommunityListEndDetailVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/25/24.
//

import UIKit

class CommunityListEndDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel! // 청원제목
    
    @IBOutlet weak var summaryLabel: UILabel! // 요약내용
    //MARK: - 상세정보 Label
    @IBOutlet weak var petitionerLabel: UILabel! // 청원인
    @IBOutlet weak var introductionMemberLabel: UILabel! // 소개의원
    @IBOutlet weak var receiptLabel: UILabel! // 접수일자
    @IBOutlet weak var CommitteeLabel: UILabel! // 소관위
    @IBOutlet weak var registrationDateLabel: UILabel! // 위원회회부일
    @IBOutlet weak var linkLabel: UILabel! // 상세링크
    @IBOutlet weak var documentBtn: UIButton! // 원문버튼(차후 이미지 바꾸면됨)
    //MARK: - 토론하기 Label
    @IBOutlet weak var announcementDateLabel: UILabel! // 추첨자 발표날짜
    @IBOutlet weak var discussionDateLabel: UILabel! // 토론 날짜
    //MARK: - 결과보기 Button
    
    @IBOutlet weak var resultBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultBtn.layer.cornerRadius = 10

    }
    


}
