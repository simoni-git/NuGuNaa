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
    
    var resultDetailVM: ResultDetailVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultDetailVM = ResultDetailVM()
        tableView.dataSource = self
        tableView.delegate = self
        
        getGPTEndAPI()

       
    }
    
    //MARK: - getGPT
    func getGPTEndAPI() {
        print("ResultDetailVC - getGPTEndAPI() called 마지막겟 가즈아아아아아")
        
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0 , bottom: 5, right: 0))
        
    }
    
    
}
