import Foundation

import RealmSwift

protocol UserDiaryRealmRepositoryType { // 프로토콜로 메소드 미리 명시 (목차 느낌)
    
    func fetchRealmPath() -> URL
    func fetchRealm() -> Results<USerDiary>
    func fetchRealmDate(date: Date) -> Results<USerDiary>
    func fetchRealmSort(sort: String, ascending: Bool) -> Results<USerDiary>
    func fetchRealmFilter()
    func fetchAddRealmItem(item: USerDiary)
    func fetchDeleteRealmItem(item: USerDiary)
    
}

class UserDiaryRealmRepository: UserDiaryRealmRepositoryType {
    
    let localRealm = try! Realm()
    
    func fetchRealmPath() -> URL {
        return localRealm.configuration.fileURL!
    }
    
    func fetchRealm() -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).sorted(byKeyPath: "createDate", ascending: false)
    }
    
    func fetchRealmDate(date: Date) -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).filter("createdDate >= %@ AND createdDate < %@", date, Date(timeInterval: 24*60*60, since: date))
    }
    
    func fetchRealmSort(sort: String, ascending: Bool) -> Results<USerDiary> {
        return localRealm.objects(USerDiary.self).sorted(byKeyPath: sort, ascending: ascending)
    }
    
    func fetchRealmFilter() {
        
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
