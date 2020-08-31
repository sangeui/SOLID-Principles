import Foundation

// 표준 GUI 에서 원과 사각형을 그릴 수 있는 애플리케이션
// 특정 순서에 따라 도형들이 그려지며, 이에 대한 목록이 주어진다.
// 이 목록의 순서에 따라 도형들을 각각의 구현에 따라 그린다.

// MARK: - OCP 를 위반하는 애플리케이션

enum ShapeType {
    // 새 도형이 추가될 때마다 해당 타입을 같이 추가해줘야 함.
    // 이는 이에 의존적인 다른 모듈들도 재컴파일을 하도록 함.
    case circle, square
}
struct Shape { var type: ShapeType }

struct Circle { var type: ShapeType = .circle }
struct Square { var type: ShapeType = .square }

func drawCircle(_: Circle) { print("created a circle") }
func drawSquare(_: Square) { print("created a square") }

func drawAllShapes(_ list: [Shape]) {
    for index in 0..<list.count {
        let shapetype = list[index]
        // 새 도형이 추가될 때마다 `switch` 의 `case` 도 함께 추가되어야 함.
        switch shapetype.type {
        case .circle:
            drawCircle(Circle())
        case .square:
            drawSquare(Square())
        }
    }
}

drawAllShapes(
    [
        Shape(type: .circle),
        Shape(type: .square),
        Shape(type: .square)
    ]
)

// MARK: - OCP 를 따르는 애플리케이션

func drawAllShapes_OCP(_ list: [Shape_OCP]) {
    for index in 0..<list.count {
        list[index].draw()
    }
}

class Shape_OCP { func draw() {} }
class Square_OCP: Shape_OCP { override func draw() { print("created a square") } }
class Circle_OCP: Shape_OCP { override func draw() { print("created a circle") } }

drawAllShapes_OCP([Square_OCP(), Circle_OCP()])

// 도형을 추가할 때는 Shape_OCP 만 상속하도록 하면 된다.
class Triangle_OCP: Shape_OCP { override func draw() { print("created a triangle") } }

drawAllShapes_OCP([Square_OCP(), Circle_OCP(), Triangle_OCP()])
