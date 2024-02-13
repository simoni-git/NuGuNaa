//
//  RegisterHistoryVC.swift
//  NuGuNa
//
//  Created by 시모니 on 2/6/24.
//

import UIKit
import Alamofire

class RegisterHistoryVC: UIViewController {

    var registerHistoryVM: RegisterHistoryVM!
    var userEmail: String = ""
    var accessToken: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerHistoryVM = RegisterHistoryVM()
        tableView.dataSource = self
        tableView.delegate = self
        print(" 레지스터에 들어온 이메일이랑 토큰 -->\(userEmail) , \(accessToken)")
        getHistoryList()
       
    }
    
    func getHistoryList() {
        //api 받아오기
        print("RegisterHistoryVC - getHistoryList() called")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request(registerHistoryVM.getListURL + "\(self.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: RegisterHistoryVM.PetitionResponse.self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    self.registerHistoryVM.petitions = petitionResponse.results
                    self.tableView.reloadData()
                    
                    
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    
}

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0 , bottom: 5, right: 0))
        
    }
}



extension RegisterHistoryVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registerHistoryVM.petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell else {
            return UITableViewCell()
        }
        let petition = registerHistoryVM.petitions[indexPath.row]
        cell.titleLabel.text = petition.billName
        
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀의 정보를 가져옵니다.
        let petition = registerHistoryVM.petitions[indexPath.row]
        
        // 다음 뷰 컨트롤러의 인스턴스를 생성합니다.
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "RegisterHistoryDetailVC") as? RegisterHistoryDetailVC else {
            return
        }
        
        // position에 따라 결과를 설정합니다.
        var resultText = ""
        if petition.position == 0 {
            resultText = "찬성측에 신청해 주셨습니다."
            detailVC.petitionCode = "토론방코드: " + petition.debateCodeO
        } else if petition.position == 1 {
            resultText = "반대측에 신청해 주셨습니다"
            detailVC.petitionCode = "토론방코드: " + petition.debateCodeO
        }
        
        // raffleCheck에 따라 추가적인 정보를 설정합니다.
        if petition.raffleCheck == false {
            detailVC.petitionCode = "안타깝게 이번 토론에는 참여하실 수 없습니다"
        }
        
        // 다음 뷰 컨트롤러에 선택한 셀의 정보를 전달합니다.
        detailVC.petitionTitle = "제목: " + petition.billName
        detailVC.petitionResult = resultText
        
        // 다음 뷰로 이동합니다.
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
