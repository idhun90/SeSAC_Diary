import Foundation
import RealmSwift

class USerDiary: Object {
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var date = Date()
    @Persisted var createdDate = Date()
    @Persisted var favorite: Bool
    @Persisted var photo: String?
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content:String?, date: Date, createdDate: Date, photo: String?) {
        self.init()
        self.title = title
        self.content = content
        self.date = date
        self.createdDate = createdDate
        self.favorite = false
        self.photo = photo
    }
}
