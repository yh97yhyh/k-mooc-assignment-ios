import UIKit

class KmoocListItemTableViewCell: UITableViewCell {
    static let CellIdentifier = "LectureItem"

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var orgName: UILabel!
    @IBOutlet var duration: UILabel!
    
    var lecture: Lecture?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLecture(_ lecture: Lecture) {
        if let lec = self.lecture,
           lec.id == lecture.id {
            return
        }
        
        self.lecture = lecture
        thumbnail.image = nil
        name.text = lecture.name
        orgName.text = lecture.orgName
        duration.text = DateUtil.dueString(start: lecture.start, end: lecture.end)
        
        ImageLoader.loadImage(url: lecture.courseImage) { [weak self] image in
            guard let self = self else { return }
            self.thumbnail.image = image
        }
    }
}
