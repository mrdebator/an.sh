import AdSupport
import Foundation

// Attempt to access the Manager
let manager = ASIdentifierManager.shared()
let id = manager.advertisingIdentifier.uuidString

print("Advertising Identifier (IDFA): \(id)")
print("Note: On macOS, this often returns all zeros by design.")
