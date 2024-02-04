//
//  CommunityEndDetailVM.swift
//  NuGuNa
//
//  Created by 시모니 on 2/4/24.
//

import Foundation

class CommunityListEndDetailVM {
    
    struct PetitionResponse: Codable {
        let petition: Petition
        let debate: Debate
    }

    struct Petition: Codable {
        let billName: String
        let proposer: String
        let approver: String
        let proposerDt: String
        let committeeDt: String
        let currCommittee: String
        let linkUrl: String
        let content: String?
        let petitionFileUrl: String

        enum CodingKeys: String, CodingKey {
            case billName = "BILL_NAME"
            case proposer = "PROPOSER"
            case approver = "APPROVER"
            case proposerDt = "PROPOSER_DT"
            case committeeDt = "COMMITTEE_DT"
            case currCommittee = "CURR_COMMITTEE"
            case linkUrl = "LINK_URL"
            case content
            case petitionFileUrl = "petition_file_url"
        }
    }

    struct Debate: Codable {
        let memberAnnouncementDate: String
        let debateDate: String
        let estimatedTime: String
        let debateCodeO: String
        let debateCodeX: String

        enum CodingKeys: String, CodingKey {
            case memberAnnouncementDate = "member_announcement_date"
            case debateDate = "debate_date"
            case estimatedTime = "estimated_time"
            case debateCodeO = "debate_code_O"
            case debateCodeX = "debate_code_X"
        }
    }


   
    var getListEndDetailURL = "http://3.34.164.96:8000/petitions/detail?BILL_NO="
    
}
