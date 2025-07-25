import Foundation
import CloudKit

enum TaskStatus: String, Codable, CaseIterable, Identifiable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { self.rawValue }
}

struct TaskModel: Identifiable, Hashable {
    let id: CKRecord.ID
    var title: String
    var description: String
    var status: TaskStatus
    var dueDate: Date?
    var isGroupTask: Bool
    var assignedUserRefs: [CKRecord.Reference]
    var completedUserRefs: [CKRecord.Reference]
    var storeCodes: [String]
    var departments: [String]
    var createdByRef: CKRecord.Reference
    var requiresAck: Bool
    
    init?(record: CKRecord) {
        guard
            let title = record["title"] as? String,
            let description = record["description"] as? String,
            let statusRaw = record["status"] as? String,
            let status = TaskStatus(rawValue: statusRaw),
            let isGroupTask = record["isGroupTask"] as? Bool,
            let assignedUserRefs = record["assignedUserRefs"] as? [CKRecord.Reference],
            let completedUserRefs = record["completedUserRefs"] as? [CKRecord.Reference],
            let storeCodes = record["storeCodes"] as? [String],
            let departments = record["departments"] as? [String],
            let createdByRef = record["createdByRef"] as? CKRecord.Reference,
            let requiresAck = record["requiresAck"] as? Bool
        else {
            return nil
        }
        
        self.id = record.recordID
        self.title = title
        self.description = description
        self.status = status
        self.dueDate = record["dueDate"] as? Date
        self.isGroupTask = isGroupTask
        self.assignedUserRefs = assignedUserRefs
        self.completedUserRefs = completedUserRefs
        self.storeCodes = storeCodes
        self.departments = departments
        self.createdByRef = createdByRef
        self.requiresAck = requiresAck
    }
    
    static func from(record: CKRecord) -> TaskModel? {
        return TaskModel(record: record)
    }
}
