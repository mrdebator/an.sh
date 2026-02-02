import SwiftUI
import AppTrackingTransparency
import AdSupport

struct ContentView: View {
    @State private var idfa: String = "Not Requested"
    @State private var statusMessage: String = "Press the button below"

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.shield")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("My iPad IDFA")
                .font(.title)
                .fontWeight(.bold)

            // Display the ID
            Text(idfa)
                .font(.system(.body, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = idfa
                    }) {
                        Text("Copy to Clipboard")
                        Image(systemName: "doc.on.doc")
                    }
                }

            Text(statusMessage)
                .font(.footnote)
                .foregroundColor(.secondary)

            Button(action: requestID) {
                Text("Request Permission & Get ID")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    func requestID() {
        // 1. Wait a moment to ensure app is active
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 2. Request Permission
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        // 3. Retrieve ID if authorized
                        self.idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        self.statusMessage = "Access Granted"
                    case .denied:
                        self.idfa = "Permission Denied"
                        self.statusMessage = "Please enable Tracking in Settings > Privacy"
                    case .notDetermined:
                        self.statusMessage = "Permission Not Determined"
                    case .restricted:
                        self.statusMessage = "Tracking Restricted (e.g. Child Account)"
                    @unknown default:
                        self.statusMessage = "Unknown Status"
                    }
                }
            }
        }
    }
}
