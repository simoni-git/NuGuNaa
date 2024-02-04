//
//  CommunityListVM.swift
//  NuGuNa
//
//  Created by 시모니 on 2/1/24.
//

import Foundation
import Alamofire

class CommunityListVM {
    
    struct PetitionResponse: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Petition]?
    }
    
    struct Petition: Decodable {
        let billNo: String
        let billName: String
        let proposer: String
        let proposerDt: String
        let content: String?
        let dDay: Int?
        
        var isOngoing: Bool {
                guard let dDay = dDay else { return false }
                return dDay >= 0
            }
        
        enum CodingKeys: String, CodingKey {
            case billNo = "BILL_NO"
            case billName = "BILL_NAME"
            case proposer = "PROPOSER"
            case proposerDt = "PROPOSER_DT"
            case content = "content"
            case dDay = "d_day"
        }
    }
    
    func filterDataForOngoingPetitions() {
            ongoingPetitions = data.filter { $0.isOngoing }
        }
    
    func filterDataForOngoingPetitions2() {
            ongoingPetitions = data.filter { $0.isOngoing }
        }
    
    func filterDataForOngoingPetitions3() {
            ongoingPetitions = data.filter { $0.isOngoing }
        }
    
   
    
    var data: [Petition] = []
    var ongoingPetitions: [Petition] = []
    var finishedPetitions: [Petition] = []
    
    var data2: [Petition] = []
    var ongoingPetitions2: [Petition] = []
    var finishedPetitions2: [Petition] = []
    
    var data3: [Petition] = []
    var ongoingPetitions3: [Petition] = []
    var finishedPetitions3: [Petition] = []
    
    var cellCount: Int = 0
    var getListPage1URL = "http://3.34.164.96:8000/petitions/list?page=1"
    var getListPage2URL = "http://3.34.164.96:8000/petitions/list?page=2"
    var getListPage3URL = "http://3.34.164.96:8000/petitions/list?page=3"
   
 
}
