import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        
        // 加载 GIF 文件
        print("尝试加载GIF文件: \(gifName)")
        
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            print("找到GIF文件路径: \(path)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                print("成功读取GIF数据，大小: \(data.count) bytes")
                
                if let source = CGImageSourceCreateWithData(data as CFData, nil) {
                    let frameCount = CGImageSourceGetCount(source)
                    print("GIF帧数: \(frameCount)")
                    var images: [UIImage] = []
                    var totalDuration: TimeInterval = 0
                    
                    // 提取所有帧
                    for i in 0..<frameCount {
                        if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                            let image = UIImage(cgImage: cgImage)
                            images.append(image)
                            
                            // 获取每一帧的持续时间
                            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                               let duration = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                                totalDuration += duration
                            }
                        }
                    }
                    
                    // 设置动画
                    imageView.animationImages = images
                    imageView.animationDuration = totalDuration
                    imageView.startAnimating()
                } else {
                    print("无法创建CGImageSource")
                }
            } catch {
                print("读取GIF数据失败: \(error)")
            }
        } else {
            print("未找到GIF文件: \(gifName).gif")
        }
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // 更新视图（如果需要）
    }
} 