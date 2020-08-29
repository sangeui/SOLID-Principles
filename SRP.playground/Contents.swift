import UIKit

class ComputationalApplication {
    var rectangle = Rectangle(width: 10, height: 10)
    func compute() -> Double {
        return rectangle.area()
    }
}
class GraphicalApplication {
    var rectangle = Rectangle(width: 20, height: 20)
    var rectangleView: RectangleView?
    
    func draw() {
        rectangleView = rectangle.draw()
    }
}

class Rectangle {
    var width: Double
    var height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    func draw() -> RectangleView {
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        return RectangleView(frame: frame)
    }
    func area() -> Double {
        return width * height
    }
}

class RectangleView: UIView {}
