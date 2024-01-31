//
//  CommunityListDetailVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/24/24.
//

import UIKit

class CommunityListDetailVC: UIViewController {
    
    var selectedIndex: Int? // 이 부분을 추가하세요.
    
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
    //MARK: - Button
    
    @IBOutlet weak var proposeBtn: UIButton! // 신청하기버튼
    @IBOutlet weak var debateBtn: UIButton! // 토론하기버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
     
    }
    
   private func configure() {
       debateBtn.layer.cornerRadius = 10
       proposeBtn.layer.cornerRadius = 10
       proposeBtn.layer.borderColor = UIColor(red: 25/255.0, green: 100/255.0, blue: 80/255.0, alpha: 1.0).cgColor
       proposeBtn.layer.borderWidth = 1.0
    }
    
   
    
    @IBAction func tapProposeBtn(_ sender: UIButton) {
       
    }
    
   
}




/*
 구현해야할것
 
 [ ] 처음에는 신청하기버튼만 누를수있고 토론하기버튼은 누를수 없음
 [ ] 신청하기 눌렀을때 간단한 뷰를 띄워서 버튼들 만들기
 [ ] 토론하기 눌렀을때 간단한 뷰 띄워서 코드입력텍스트필드와 버튼들 만들기
 
 */
