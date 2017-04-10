import UIKit

public protocol DrawViewDelegate: class {
    func drawViewDidFinishDrawing(view: DrawView)
    func drawViewMoved(view: DrawView)
}


public class DrawView: UIView {
    
    weak var delegate: DrawViewDelegate?
    private var bufferImage: UIImage?
    private var strokeImage = UIImage(named: "stroke")
    private var lastPoint: CGPoint?
    
    func clear() {
        bufferImage = nil
        lastPoint = nil
        paint(touches: [])
    }
    
    func getImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        paint(touches: touches)
        
        delegate?.drawViewMoved(view: self)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        paint(touches: touches)
        lastPoint = nil
        
        delegate?.drawViewDidFinishDrawing(view: self)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    
    private func paint(touches: Set<UITouch>) {
        autoreleasepool {
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
            defer {
                UIGraphicsEndImageContext()
            }
            
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            context.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
            context.fill(bounds)
            
            if let image = bufferImage {
                image.draw(in: bounds)
            }
            
            for touch in touches {
                let point = touch.location(in: self)
                paint(from: lastPoint, to: point)
                lastPoint = point
            }
            
            bufferImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        layer.contents = bufferImage?.cgImage
    }
    
    private func paint(from: CGPoint?, to: CGPoint) {
        
        guard let from = from else {
            stamp(at: to)
            return
        }
        
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dist = sqrt(dx * dx + dy * dy)
        var stepx: CGFloat = 0
        var stepy: CGFloat = 0
        if dist > 0 {
            stepx = dx / dist
            stepy = dy / dist
        }
        
        var offset = CGPoint.zero
        
        var path = dist
        while path >= 1 {
            stamp(at: CGPoint(x: from.x + offset.x, y: from.y + offset.y))
            offset.x += stepx
            offset.y += stepy
            path -= 1
        }
    }
    
    private func stamp(at point: CGPoint) {
        
        guard let strokeImage = strokeImage else {
            return
        }
        
        let size = strokeImage.size
        let rect = CGRect(origin: point, size: CGSize.zero).insetBy(dx: -size.width / 2, dy: -size.height / 2)
        strokeImage.draw(in: rect)
    }
}

