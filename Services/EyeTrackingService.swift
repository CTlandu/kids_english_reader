import ARKit
import SwiftUI
import Combine

@MainActor
class EyeTrackingService: NSObject, ObservableObject {
    private var session: ARSession?
    private var wordTimer: Timer?
    private var currentLookAtWord: String?
    private var lookStartTime: Date?
    private let dwellThreshold: TimeInterval = 3.0 // 3秒停留阈值
    
    @Published var highlightedWord: String?
    @Published var isTrackingAvailable: Bool = false
    @Published var showWordDefinition: Bool = false
    @Published var trackingStatus: String = "Initializing..."
    
    // 用于存储单词在屏幕上的位置信息
    private var wordFrames: [String: CGRect] = [:]
    private var currentFrame: ARFrame? = nil
    
    override init() {
        super.init()
        checkAvailability()
    }
    
    func updateWordFrames(_ frames: [String: CGRect]) {
        wordFrames = frames
    }
    
    private func checkAvailability() {
        isTrackingAvailable = ARFaceTrackingConfiguration.isSupported
        
        if !isTrackingAvailable {
            trackingStatus = "This device does not support eye tracking."
            return
        }
        
        trackingStatus = "Eye tracking is available"
    }
    
    func startTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            trackingStatus = "Face tracking is not supported on this device"
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 1
        
        session = ARSession()
        session?.delegate = self
        session?.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        trackingStatus = "Starting eye tracking..."
    }
    
    func stopTracking() {
        session?.pause()
        wordTimer?.invalidate()
        wordTimer = nil
        trackingStatus = "Tracking stopped"
    }
    
    private func handleLookAtPoint(_ point: CGPoint) {
        // 查找point所在的单词
        if let (word, _) = wordFrames.first(where: { $0.value.contains(point) }) {
            if word != currentLookAtWord {
                // 视线移动到新单词
                currentLookAtWord = word
                lookStartTime = Date()
                
                // 重置之前的高亮
                highlightedWord = nil
                showWordDefinition = false
                
                // 设置新的计时器
                wordTimer?.invalidate()
                wordTimer = Timer.scheduledTimer(withTimeInterval: dwellThreshold, repeats: false) { [weak self] _ in
                    Task { @MainActor in
                        self?.highlightedWord = word
                        self?.showWordDefinition = true
                        self?.trackingStatus = "Looking at word: \(word)"
                    }
                }
            }
        } else {
            // 视线离开单词区域
            currentLookAtWord = nil
            lookStartTime = nil
            wordTimer?.invalidate()
            wordTimer = nil
        }
    }
    
    // 用于在主actor上更新当前帧
    @MainActor private func updateCurrentFrame(_ frame: ARFrame) {
        currentFrame = frame
        trackingStatus = "Tracking active"
    }
}

extension EyeTrackingService: ARSessionDelegate {
    nonisolated func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        
        let leftEyeTransform = faceAnchor.leftEyeTransform
        let rightEyeTransform = faceAnchor.rightEyeTransform
        
        Task { @MainActor in
            // 更新当前帧
            if let frame = session.currentFrame {
                await updateCurrentFrame(frame)
            }
            
            // 计算注视点
            if let lookAtPoint = await calculateLookAtPoint(leftEye: leftEyeTransform, rightEye: rightEyeTransform) {
                await handleLookAtPoint(lookAtPoint)
            }
        }
    }
    
    @MainActor private func calculateLookAtPoint(leftEye: simd_float4x4, rightEye: simd_float4x4) -> CGPoint? {
        let leftEyePos = simd_float3(leftEye[3].x, leftEye[3].y, leftEye[3].z)
        let rightEyePos = simd_float3(rightEye[3].x, rightEye[3].y, rightEye[3].z)
        
        let eyeCenter = (leftEyePos + rightEyePos) * 0.5
        
        let leftDir = simd_float3(leftEye[2].x, leftEye[2].y, leftEye[2].z)
        let rightDir = simd_float3(rightEye[2].x, rightEye[2].y, rightEye[2].z)
        let lookAtDirection = simd_normalize(leftDir + rightDir)
        
        guard let frame = currentFrame else { return nil }
        
        let camera = frame.camera
        let viewMatrix = camera.viewMatrix(for: .portrait)
        let projectionMatrix = camera.projectionMatrix(for: .portrait, viewportSize: UIScreen.main.bounds.size, zNear: 0.001, zFar: 1000)
        
        return project(point: eyeCenter + lookAtDirection, viewMatrix: viewMatrix, projectionMatrix: projectionMatrix)
    }
    
    @MainActor private func project(point: SIMD3<Float>, viewMatrix: simd_float4x4, projectionMatrix: simd_float4x4) -> CGPoint {
        let pointVector = simd_float4(point.x, point.y, point.z, 1)
        let viewProjectionMatrix = projectionMatrix * viewMatrix
        let clipSpacePoint = viewProjectionMatrix * pointVector
        let normalizedPoint = clipSpacePoint / clipSpacePoint.w
        
        return CGPoint(
            x: CGFloat((normalizedPoint.x + 1) * 0.5) * UIScreen.main.bounds.width,
            y: CGFloat((1 - normalizedPoint.y) * 0.5) * UIScreen.main.bounds.height
        )
    }
    
    nonisolated func session(_ session: ARSession, didFailWithError error: Error) {
        Task { @MainActor in
            trackingStatus = "Session failed: \(error.localizedDescription)"
            isTrackingAvailable = false
        }
    }
    
    nonisolated func sessionWasInterrupted(_ session: ARSession) {
        Task { @MainActor in
            trackingStatus = "Session was interrupted"
        }
    }
    
    nonisolated func sessionInterruptionEnded(_ session: ARSession) {
        Task { @MainActor in
            trackingStatus = "Session interruption ended"
            session.run(session.configuration!, options: [.resetTracking, .removeExistingAnchors])
        }
    }
} 