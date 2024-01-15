import Foundation

class KmoocListViewModel: NSObject {
    @IBOutlet var repository: KmoocRepository!
    
    private var lectureList: LectureList = LectureList.EMPTY
    private var loading = false
    
    var loadingStarted: () -> Void = {}
    var loadingEnded: () -> Void = { }
    var lectureListUpdated: () -> Void = { }
    
    func lecturesCount() -> Int {
        return lectureList.lectures.count
    }

    func lecture(at index: Int) -> Lecture {
        return lectureList.lectures[index]
    }

    func list() {
        loading = true
        loadingStarted()
        repository.list {
            self.lectureList = $0
            self.lectureListUpdated()
            self.loadingEnded()
            self.loading = false
        }
    }

    func next() {
        if loading { return }
        loading = true
        loadingStarted()
        repository.next(currentPage: lectureList) {
            var lectureList = $0
            lectureList.lectures.insert(contentsOf: self.lectureList.lectures, at: 0)
            self.lectureList = lectureList
            self.lectureListUpdated()
            self.loadingEnded()
            self.loading = false
        }
    }
}
