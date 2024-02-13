//
//  CommunityListVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/24/24.
//

import UIKit
import Alamofire

class CommunityListVC: UIViewController {
    
    var communityListVM: CommunityListVM!
    var accessToken: String = ""
    var selectedPage: Int = 1 // 기본값은 1번 페이지
    var userEmail: String = ""
    var billTitle: String = ""
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var page1Btn: UIButton!
    @IBOutlet weak var page2Btn: UIButton!
    @IBOutlet weak var page3Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communityListVM = CommunityListVM()
        tableView.delegate = self
        tableView.dataSource = self
        getList1()
        page1Btn.isSelected = true // 초기값으로 1번 버튼이 선택되도록 설정
        
        
    }
    
    
    
    //MARK: - 1페이지 불러오기
    func getList1() {
        print("getList1() called")
        //토큰을 꼽아줘야지만 데이터를 받을수있음/보안상의 이유임
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(communityListVM.getListPage1URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: CommunityListVM.PetitionResponse.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    if let results = petitionResponse.results {
                        for petition in results {
                            if self.isPetitionOngoing(petition) {
                                self.communityListVM.ongoingPetitions.append(petition)
                            } else {
                                self.communityListVM.finishedPetitions.append(petition)
                            }
                        }
                        self.communityListVM.cellCount = self.communityListVM.ongoingPetitions.count
                    }
                    // 테이블 뷰 리로드
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    //MARK: - 2페이지 불러오기
    func getList2() {
        print("getList1() called")
        //토큰을 꼽아줘야지만 데이터를 받을수있음/보안상의 이유임
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(communityListVM.getListPage2URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: CommunityListVM.PetitionResponse.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    if let results = petitionResponse.results {
                        for petition in results {
                            if self.isPetitionOngoing(petition) {
                                self.communityListVM.ongoingPetitions2.append(petition)
                            } else {
                                self.communityListVM.finishedPetitions2.append(petition)
                            }
                        }
                        self.communityListVM.cellCount = self.communityListVM.ongoingPetitions2.count
                    }
                    // 테이블 뷰 리로드
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    
    //MARK: - 3페이지 불러오기
    func getList3() {
        print("getList1() called")
        //토큰을 꼽아줘야지만 데이터를 받을수있음/보안상의 이유임
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(communityListVM.getListPage3URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: CommunityListVM.PetitionResponse.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    if let results = petitionResponse.results {
                        for petition in results {
                            if self.isPetitionOngoing(petition) {
                                self.communityListVM.ongoingPetitions3.append(petition)
                            } else {
                                self.communityListVM.finishedPetitions3.append(petition)
                            }
                        }
                        self.communityListVM.cellCount = self.communityListVM.ongoingPetitions3.count
                    }
                    // 테이블 뷰 리로드
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    //MARK: - - - - - - - - - - - - - -
    
    func calculateDday(from targetDate: Date, to today: Date) -> Int? {
        let calendar = Calendar.current
        
        // 날짜 차이 계산
        let components = calendar.dateComponents([.day], from: today, to: targetDate)
        
        // D-day 반환
        return components.day
    }
    
    func isPetitionOngoing(_ petition: CommunityListVM.Petition) -> Bool {
        // dDay 값을 확인하여 진행 중인지 여부를 판단
        guard let dDay = petition.dDay else {
            return false // dDay가 nil이면 종료된 것으로 간주
        }
        return dDay >= 0 // dDay가 0 이상이면 진행 중인 것으로 판단
    }
    
    @IBAction func tapSegmentBtn(_ sender: UISegmentedControl) {
        
        var numOfCell: Int = 0
        
        // 선택된 페이지에 따라 데이터 필터링
        switch selectedPage {
        case 1:
            switch segmentController.selectedSegmentIndex {
            case 0:
                numOfCell = communityListVM.ongoingPetitions.count
            case 1:
                numOfCell = communityListVM.finishedPetitions.count
            default:
                print("")
            }
        case 2:
            switch segmentController.selectedSegmentIndex {
            case 0:
                numOfCell = communityListVM.ongoingPetitions2.count
            case 1:
                numOfCell = communityListVM.finishedPetitions2.count
            default:
                print("")
            }
        case 3:
            switch segmentController.selectedSegmentIndex {
            case 0:
                numOfCell = communityListVM.ongoingPetitions3.count
            case 1:
                numOfCell = communityListVM.finishedPetitions3.count
            default:
                print("")
            }
        default:
            break
        }
        
        // TableView 갱신
        communityListVM.cellCount = numOfCell
        self.tableView.reloadData()
        
        
        
    }
    
    
    
    
    //MARK: - 페이지 버튼
    
    @IBAction func tapPageBtn(_ sender: UIButton) {
        page1Btn.isSelected = false
        page2Btn.isSelected = false
        page3Btn.isSelected = false
        
        
        
        // 눌린 버튼만 선택되도록 설정
        sender.isSelected = true
        
        // 선택된 페이지에 따라 getList 메서드 호출
        switch sender {
        case page1Btn:
            selectedPage = 1
            communityListVM.ongoingPetitions.removeAll()
            communityListVM.finishedPetitions.removeAll()
            segmentController.selectedSegmentIndex = 0 // 진행 중 세그먼트 선택
            getList1()
            
        case page2Btn:
            selectedPage = 2
            communityListVM.ongoingPetitions2.removeAll()
            communityListVM.finishedPetitions2.removeAll()
            segmentController.selectedSegmentIndex = 0 // 진행 중 세그먼트 선택
            getList2()
        case page3Btn:
            selectedPage = 3
            communityListVM.ongoingPetitions3.removeAll()
            communityListVM.finishedPetitions3.removeAll()
            segmentController.selectedSegmentIndex = 0 // 진행 중 세그먼트 선택
            getList3()
        default:
            break
        }
    }
    
}

//MARK: - TableView
extension CommunityListVC: UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  communityListVM.cellCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? myCell else {
            return UITableViewCell()
        }
        
        var petition: CommunityListVM.Petition?
        switch selectedPage {
        case 1:
            switch segmentController.selectedSegmentIndex {
            case 0:
                // "진행중" 세그먼트가 선택된 경우
                petition = communityListVM.ongoingPetitions[indexPath.row]
                
            case 1:
                // "종료" 세그먼트가 선택된 경우
                petition = communityListVM.finishedPetitions[indexPath.row]
                
            default:
                break
            }
        case 2:
            switch segmentController.selectedSegmentIndex {
            case 0:
                // "진행중" 세그먼트가 선택된 경우
                petition = communityListVM.ongoingPetitions2[indexPath.row]
                
            case 1:
                // "종료" 세그먼트가 선택된 경우
                petition = communityListVM.finishedPetitions2[indexPath.row]
                
            default:
                break
            }
        case 3:
            switch segmentController.selectedSegmentIndex {
            case 0:
                // "진행중" 세그먼트가 선택된 경우
                petition = communityListVM.ongoingPetitions3[indexPath.row]
                
            case 1:
                // "종료" 세그먼트가 선택된 경우
                petition = communityListVM.finishedPetitions3[indexPath.row]
                
            default:
                break
            }
        default:
            break
        }
        
        
        if let dDay = petition?.dDay {
            if dDay >= 0 {
                // D-day가 0 이상인 경우
                cell.DdayLabel.text = "D - \(dDay)"
            } else {
                // D-day가 음수인 경우
                cell.DdayLabel.text = "종료"
            }
        } else {
            // D-day가 nil인 경우
            cell.DdayLabel.text = ""
        }
        
        let summary = petition!.content!
        
        cell.proposalDateLabel.text = "제안날짜: \(petition!.proposerDt)"
        cell.titleLabel.text = "제목: \(petition!.billName)"
        cell.contentSummaryLabel.text = "요약: \(summary)"
        cell.petitionerLabel.text = "청원인: \(petition!.proposer)"
        
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
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedIndex = indexPath.row
        let token = self.accessToken
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            // 1번째 버튼이 선택된 경우
            
            if let communityListDetailVC = storyboard?.instantiateViewController(withIdentifier: "CommunityListDetailVC") as? CommunityListDetailVC {
                // 선택된 셀의 인덱스에 해당하는 데이터 가져오기
                let ongoingData: CommunityListVM.Petition
                switch selectedPage {
                case 1:
                    ongoingData = communityListVM.ongoingPetitions[selectedIndex]
                case 2:
                    ongoingData = communityListVM.ongoingPetitions2[selectedIndex]
                case 3:
                    ongoingData = communityListVM.ongoingPetitions3[selectedIndex]
                default:
                    return
                }
                
                // 데이터를 CommunityListDetailVC에 전달합니다.
                communityListDetailVC.selectedIndex = selectedIndex
                communityListDetailVC.accessToken = token
                communityListDetailVC.billNO = ongoingData.billNo
                communityListDetailVC.userEmail = self.userEmail
                communityListDetailVC.billTitle = ongoingData.billName
                navigationController?.pushViewController(communityListDetailVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case 1:
            // 2번째 버튼이 선택된 경우
            
            if let communityListEndDetailVC = storyboard?.instantiateViewController(withIdentifier: "CommunityListEndDetailVC") as? CommunityListEndDetailVC {
                // 선택된 셀의 인덱스에 해당하는 데이터 가져오기
                let finishedData: CommunityListVM.Petition
                switch selectedPage {
                case 1:
                    finishedData = communityListVM.finishedPetitions[selectedIndex]
                case 2:
                    finishedData = communityListVM.finishedPetitions2[selectedIndex]
                case 3:
                    finishedData = communityListVM.finishedPetitions3[selectedIndex]
                default:
                    return
                }
                
                // 데이터를 CommunityListEndDetailVC에 전달합니다.
                communityListEndDetailVC.selectedIndex = selectedIndex
                communityListEndDetailVC.accessToken = token
                communityListEndDetailVC.billNO = finishedData.billNo
                communityListEndDetailVC.userEmail = self.userEmail
                navigationController?.pushViewController(communityListEndDetailVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
}



//MARK: - Cell
class myCell: UITableViewCell {
    @IBOutlet weak var proposalDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentSummaryLabel: UILabel!
    @IBOutlet weak var DdayLabel: UILabel!
    @IBOutlet weak var petitionerLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0 , bottom: 5, right: 0))
        
    }
    
}
