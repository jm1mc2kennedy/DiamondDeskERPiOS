import Foundation
import CloudKit

enum TaskStatus: String, Codable, CaseIterable, Identifiable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { self.rawValue }
}

enum TaskCompletionMode: String, Codable, CaseIterable, Identifiable {
    case group = "group"
    case individual = "individual"
    
    var id: String { self.rawValue }
}

struct TaskModel: Identifiable, Hashable {
    let id: CKRecord.ID
    var title: String
    var description: String
    var status: TaskStatus
    var dueDate: Date?
    var isGroupTask: Bool
    var completionMode: TaskCompletionMode
    var assignedUserRefs: [CKRecord.Reference]
    var completedUserRefs: [CKRecord.Reference]
    var storeCodes: [String]
    var departments: [String]
    var createdByRef: CKRecord.Reference
    var requiresAck: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init?(record: CKRecord) {
        guard
            let title = record["title"] as? String,
            let description = record["description"] as? String,
            let statusRaw = record["status"] as? String,
            let status = TaskStatus(rawValue: statusRaw),
            let isGroupTask = record["isGroupTask"] as? Bool,
            let completionModeRaw = record["completionMode"] as? String,
            let completionMode = TaskCompletionMode(rawValue: completionModeRaw),
            let assignedUserRefs = record["assignedUserRefs"] as? [CKRecord.Reference],
            let completedUserRefs = record["completedUserRefs"] as? [CKRecord.Reference],
            let storeCodes = record["storeCodes"] as? [String],
            let departments = record["departments"] as? [String],
            let createdByRef = record["createdByRef"] as? CKRecord.Reference,
            let requiresAck = record["requiresAck"] as? Bool,
            let createdAt = record["createdAt"] as? Date,
            let updatedAt = record["updatedAt"] as? Date
        else {
            return nil
        }
        
        self.id = record.recordID
        self.title = title
        self.description = description
        self.status = status
        self.dueDate = record["dueDate"] as? Date
        self.isGroupTask = isGroupTask
        self.completionMode = completionMode
        self.assignedUserRefs = assignedUserRefs
        self.completedUserRefs = completedUserRefs
        self.storeCodes = storeCodes
        self.departments = departments
        self.createdByRef = createdByRef
        self.requiresAck = requiresAck
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Task", recordID: id)
        record["title"] = title as CKRecordValue
        record["description"] = description as CKRecordValue
        record["status"] = status.rawValue as CKRecordValue
        record["dueDate"] = dueDate as CKRecordValue?
        record["isGroupTask"] = isGroupTask as CKRecordValue
        record["completionMode"] = completionMode.rawValue as CKRecordValue
        record["assignedUserRefs"] = assignedUserRefs as CKRecordValue
        record["completedUserRefs"] = completedUserRefs as CKRecordValue
        record["storeCodes"] = storeCodes as CKRecordValue
        record["departments"] = departments as CKRecordValue
        record["createdByRef"] = createdByRef as CKRecordValue
        record["requiresAck"] = requiresAck as CKRecordValue
        record["createdAt"] = createdAt as CKRecordValue
        record["updatedAt"] = updatedAt as CKRecordValue
        return record
    }
    
    static func from(record: CKRecord) -> TaskModel? {
        return TaskModel(record: record)
    }
}
