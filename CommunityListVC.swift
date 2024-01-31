//
//  CommunityListVC.swift
//  NuGuNa
//
//  Created by 시모니 on 1/24/24.
//

import UIKit


class CommunityListVC: UIViewController {
    
    let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7"]

    var communityListVM: CommunityListVM!
    var accessToken: String = ""
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communityListVM = CommunityListVM()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

//MARK: - TableView
extension CommunityListVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? myCell else {
            return UITableViewCell()
        }
        cell.proposalDateLabel.text = "제안날짜: 2024-01-01"
        cell.titleLabel.text = "제목: 요즘 날씨가 너무추워요"
        cell.contentSummaryLabel.text = "요약: 이부분은 어떤요약이 들어갈까요?? 여튼 요약이 들어간답니다"
        cell.DdayLabel.text = "D-14"
        cell.petitionerLabel.text = "청원인: 금쪽이"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
           
           // CommunityListDetailVC를 Storyboard에서 인스턴스화합니다.
           if let communityListDetailVC = storyboard?.instantiateViewController(withIdentifier: "CommunityListDetailVC") as? CommunityListDetailVC {
               // 선택된 셀의 인덱스를 CommunityListDetailVC에 전달합니다.
               communityListDetailVC.selectedIndex = selectedIndex
               
               // CommunityListDetailVC로 이동합니다.
               navigationController?.pushViewController(communityListDetailVC, animated: true)
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
}
