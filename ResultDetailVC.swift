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
        
        tableView.estimatedRowHeight = 60 // 테이블뷰셀의 대략적인 높이

       
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
            cell.subView.backgroundColor = UIColor(hex: "26A69A")
            cell.resultLabel.textColor = .white
        } else {
            
            cell.leadingConstant.constant = 70
            cell.trailingConstant.constant = 10
            cell.subView.backgroundColor = .white
            }
        
        cell.subView.layer.cornerRadius = 10
        

        
        
        return cell
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

    
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
