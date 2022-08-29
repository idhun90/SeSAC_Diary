import Foundation

import RealmSwift

protocol UserDiaryRealmRepositoryType { // 프로토콜로 메소드 미리 명시 (목차 느낌)
    
    func fetchRealmPath() -> URL
    func fetchRealm() -> Results<USerDiary>
    func fetchRealmDate(date: Date) -> Results<USerDiary>
    func fetchRealmSort(sort: String, ascending: Bool) -> Results<USerDiary>
    func fetchRealmFilterTextContainTitleOrContent(text: String) -> Results<USerDiary>
    func fetchAddRealmItem(item: USerDiary)
    func fetchDeleteRealmItem(item: USerDiary)
    
}

class UserDiaryRealmRepository: UserDiaryRealmRepositoryType {

    let localRealm = try! Realm()
    
    func fetchRealmPath() -> URL {
        return localRealm.configuration.fileURL!
    }
    
    func fetchRealm() -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func fetchRealmDate(date: Date) -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).filter("createdDate >= %@ AND createdDate < %@", date, Date(timeInterval: 24*60*60, since: date)).sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func fetchRealmTodayDate() -> Results<USerDiary> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let date = Date()
        print("현재 시간: \(date)")
        let stringDate = dateFormatter.string(from: date)
        print("stringDate: \(stringDate)")
        let newDate = dateFormatter.date(from: stringDate)!
        print("newDate: \(newDate)")
        
        let calendar = Calendar.current
        let yesterday = calendar.startOfDay(for: Date()) // 해당 일의 시작 시간 12:00 am
        print("어제 날짜: \(dateFormatter.string(from: yesterday))")
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        print("내일 날짜: \(dateFormatter.string(from: tomorrow))")
        
        //let yesterday = calendar.date(bySetting: <#T##Calendar.Component#>, value: <#T##Int#>, of: <#T##Date#>) // 특정 일,시간, 분, 초 값 변경
        
//        let component = calendar.dateComponents([.year, .month, .day], from: Date())
//        let tomorrowDate = calendar.date(from: component)!
//        let tomorrow = calendar.date(byAdding: .day, value: 1, to: tomorrowDate)!
        
        let created = localRealm.objects(USerDiary.self).filter("createdDate > %@ AND createdDate < %@", yesterday, tomorrow).sorted(byKeyPath: "createdDate", ascending: false)
        
        print(created)
        
        return created
    }
    
    func fetchRealmSort(sort: String, ascending: Bool) -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).sorted(byKeyPath: sort, ascending: ascending)
    }
    
    func fetchRealmFilterTextContainTitleOrContent(text: String) -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).filter("title CONTAINS[c] '\(text)' OR content CONTAINS[c] '\(text)'").sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func fetchAddRealmItem(item: USerDiary) {
        do {
            try localRealm.write {
                localRealm.add(item)
                print("Realm에 데이터를 성공적으로 추가했습니다.")
            }
        } catch let error {
            print("Realm에 데이터 추가를 실패했습니다.", error)
        }
        
    }
    
    func fetchDeleteRealmItem(item: USerDiary) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print("선택한 Realm 데이터 삭제를 실패했습니다.", error)
        }
    }
    
}
