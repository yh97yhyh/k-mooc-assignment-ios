import Foundation

class KmoocRepository: NSObject {
    /**
     * 국가평생교육진흥원_K-MOOC_강좌정보API
     * https://www.data.go.kr/data/15042355/openapi.do
     */

    private let httpClient = HttpClient(baseUrl: "http://apis.data.go.kr/B552881/kmooc")
    private let serviceKey =
        "LwG%2BoHC0C5JRfLyvNtKkR94KYuT2QYNXOT5ONKk65iVxzMXLHF7SMWcuDqKMnT%2BfSMP61nqqh6Nj7cloXRQXLA%3D%3D"

    func list(completed: @escaping (LectureList) -> Void) {
        httpClient.getJson(path: "/courseList",
                           params: ["serviceKey": serviceKey, "Mobile": 1]
        ) { result in
            if let json = try? result.get() {
                let lectureList = self.parseLectureList(jsonObject: self.JSONObject(json))
                completed(lectureList)
            }
        
        }
    }

    func next(currentPage: LectureList, completed: @escaping (LectureList) -> Void) {
        let nextPageUrl = currentPage.next
        httpClient.getJson(path: nextPageUrl, params: [:]) { result in
            if let json = try? result.get() {
                let lectureList = self.parseLectureList(jsonObject: self.JSONObject(json))
                completed(lectureList)
            }
        }
    }

    func detail(courseId: String, completed: @escaping (Lecture) -> Void) {
        httpClient.getJson(path: "/courseDetail",
                           params: ["CourseId": courseId, "serviceKey": serviceKey]) { result in
            if let json = try? result.get() {
                let lecture = self.parseLecture(jsonObject: self.JSONObject(json))
                completed(lecture)
            }
        }
    }
    
    private func JSONObject(_ json: String) -> [String: Any] {
        let data = json.data(using: .utf8)!
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return jsonObject
    }
    
    private func parseLectureList(jsonObject: [String: Any]) -> LectureList {
        return LectureList(count: (jsonObject["pagination"] as! [String: Any])["count"] as! Int,
                           numPages: (jsonObject["pagination"] as! [String: Any])["num_pages"] as! Int,
                           previous: (jsonObject["pagination"] as! [String: Any])["previous"] as? String ?? "",
                           next: (jsonObject["pagination"] as! [String: Any])["next"] as? String ?? "",
                           lectures: (jsonObject["results"] as! [[String: Any]]).map(parseLecture))
    }

    private func parseLecture(jsonObject: [String: Any]) -> Lecture {
        return Lecture(id: jsonObject["id"] as! String,
                       number: jsonObject["number"] as! String,
                       name: jsonObject["name"] as! String,
                       classfyName: jsonObject["classfy_name"] as! String,
                       middleClassfyName: jsonObject["middle_classfy"] as! String,
                       courseImage: ((jsonObject["media"] as! [String: Any])["image"] as! [String: Any])["small"] as! String,
                       courseImageLarge: ((jsonObject["media"] as! [String: Any])["image"] as! [String: Any])["large"] as! String,
                       shortDescription: jsonObject["short_description"] as! String,
                       orgName: jsonObject["org_name"] as! String,
                       start: DateUtil.parseDate(jsonObject["start"] as! String),
                       end: DateUtil.parseDate(jsonObject["end"] as! String),
                       teachers: jsonObject["teachers"] as? String,
                       overview: jsonObject["overview"] as? String)
    }
}
