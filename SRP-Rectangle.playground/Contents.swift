import UIKit

// MARK: - GUI
class RectangleView: UIView {}

// MARK: - Version 1 which violates SRP.

class ComputationalApplication_v1 {
    var rectangle = Rectangle_v1(width: 10, height: 10)
    func compute() -> Double {
        return rectangle.area()
    }
}
class GraphicalApplication_v1 {
    var rectangle = Rectangle_v1(width: 20, height: 20)
    var rectangleView: RectangleView?
    
    func draw() {
        rectangleView = rectangle.draw()
    }
}

class Rectangle_v1 {
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

// MARK: - Version 2 which has solved SRP.

class ComputationalApplication_v2 {
    var rectangle = GeometricRectangle(width: 10, height: 10)
    func compute() -> Double {
        return rectangle.area()
    }
}
class GraphicalApplication_v2 {
    var rectangle = Rectangle_v2(width: 20, height: 20)
    var rectangleView: RectangleView?
    
    func draw() {
        rectangleView = rectangle.draw()
    }
}

class Rectangle_v2 {
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
}

class GeometricRectangle {
    var width: Double
    var height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    func area() -> Double {
        return width * height
    }
}
