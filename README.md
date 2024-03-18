# 👨‍💻NuGuNaa - 국회 공공데이터 활용 경진 대회(AI를 이용한 토론)

## 🔨사용기술
- Swift
- Storyboard
- MVVM
- Alamofire

## 🔨사용기술 예시코드
    func getList1() {
         print("getList1() called")
    
         let headers: HTTPHeaders = [
             "Authorization": "Bearer \(self.accessToken)"
         ]
    
         AF.request(communityListVM.getListPage1URL, method: .get, parameters: nil, encoding: JSONEncoding.default,      headers: headers)
             .validate()
             .responseDecodable(of: CommunityListVM.PetitionResponse.self) { response in
                 switch response.result {
                 case .success(let petitionResponse):
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
                     DispatchQueue.main.async {
                         self.tableView.reloadData()
                     }
                
                 case .failure(let error):
                     print("요청 실패: \(error)")
                 }
             }
     }
⬆️ Alamofire 을 통한 네트워킹

     class CountDownTimer {
         private var timer: Timer?
         private var remainingTime: TimeInterval = 0

         func start(duration: TimeInterval , action: @escaping (Int) -> Void) {
             remainingTime = duration
             timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                 guard let self, self.remainingTime > 0 else {
                     self?.stop()
                     action(0)
                     return
                 }
                 self.remainingTime -= 1
                 action(Int(remainingTime))
             })
         }

         func stop() {
             remainingTime = 0
             timer?.invalidate()
             timer = nil
         }

      }
⬆️ 타이머의 비동기처리

## 🔍앱의 주요기능
- 네트워킹을 통한 현재 국회 국민청원리스트 확인
- 국민청원에 대한 의견제시를 위한 토론참가
- 토론결과확인

## 👨‍💻 프로젝트를 계획한 이유
- 국회 공공데이터 사용 + AI 의 사용, 이렇게 두가지를 함께 사용해야하는 상황에서  
토론을 주제로 한다면 국민들은 의견제시와 현재청원에 관한 정보를 얻을 수 있고  
국회는 국민들의 소리를 들을 수 있기에 선택하게 되었습니다.

## 🤓협업과정에서 느낀점
- 백엔드와의 기획팀과의 협업을 통해 자신이 해야할 일에 대한 책임감을 더욱 느끼게 되었습니다.
- IOS 개발자인 만큼 IOS 에 대하여 누구보다 잘 알아야 된다는 것을 느꼈습니다.


