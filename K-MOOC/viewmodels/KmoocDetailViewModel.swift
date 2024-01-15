import Foundation

class KmoocDetailViewModel: NSObject {
    @IBOutlet var repository: KmoocRepository!

    private var lecture = Lecture.EMPTY
    
    var lectureId: String = ""
    
    var loadingStarted: () -> Void = { }
    var loadingEnded: () -> Void = { }
    var lectureUpdated: (Lecture) -> Void = { _ in }

    func detail() {
        loadingStarted()
        repository.detail(courseId: lectureId) { lecture in
            self.lecture = lecture
            self.lectureUpdated(lecture)
            self.loadingEnded()
        }
    }
}
