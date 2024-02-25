//
//  ResultDetailVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/26/24.
//

import UIKit
import Alamofire

class ResultDetailVC: UIViewController {
    

    var data: [String] = [""]
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var accessToken: String = ""
    var billNO: String = ""
    var billName: String = ""
    
    var resultDetailVM: ResultDetailVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultDetailVM = ResultDetailVM()
        tableView.dataSource = self
        tableView.delegate = self
        
        getGPTEndAPI()
        titleLabel.text = billName

       
    }
    
    //MARK: - getGPT
    func getGPTEndAPI() {
        print("ResultDetailVC - getGPTEndAPI() called 마지막겟 가즈아아아아아 빌넘버는 \(self.billNO)")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        AF.request( resultDetailVM.getGPTEndURL + "\(self.billNO)"
            , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate() // 선택 사항: 응답을 유효성 검사할 수 있음
            .responseDecodable(of: [ResultDetailVM.StatementGPTEndData].self) { response in
                switch response.result {
                case .success(let petitionResponse):
                    // 요청 성공시, petitionResponse 변수에 파싱된 결과가 들어갑니다.
                    print("요청 성공: \(petitionResponse)")
                    self.data = petitionResponse.map { $0.content }
                       // 테이블 뷰를 리로드하여 데이터를 표시
                       self.tableView.reloadData()
                   
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    


}

extension ResultDetailVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as? ResultCell else {
            return UITableViewCell()
        }
        let data = data[indexPath.row]
        cell.resultLabel.text = data
        
        if indexPath.row % 2 == 0 {
            
            cell.leadingConstant.constant = 10
            cell.trailingConstant.constant = 70
        } else {
            
            cell.leadingConstant.constant = 70
            cell.trailingConstant.constant = 10
            }
        
        cell.subView.layer.cornerRadius = 10
        
//        // 데이터 설정
//            let content = self.data[indexPath.row]
//            cell.resultLabel.text = content
//            
//            // 짝수 인덱스는 왼쪽, 홀수 인덱스는 오른쪽으로 밀착
//        
//               if indexPath.row % 2 == 0 {
//                   cell.resultLabel.text = "찬성측: \(content)"
//                   // 짝수 번째 셀: 셀을 왼쪽에 붙이고 오른쪽 마진을 추가합니다.
//                   cell.resultLabel.textAlignment = .left
//                   cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
//               } else {
//                   cell.resultLabel.text = "반대측: \(content)"
//                   // 홀수 번째 셀: 셀을 오른쪽에 붙이고 왼쪽 마진을 추가합니다.
//                   cell.resultLabel.textAlignment = .right
//                   cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16)
//               }
//          
//        
//        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.layer.shadowRadius = 10
//        cell.layer.cornerRadius = 10
//        cell.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
//        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var trailingConstant: NSLayoutConstraint!
    @IBOutlet weak var leadingConstant: NSLayoutConstraint!
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0 , bottom: 5, right: 0))
//        
//    }
    
    
}
