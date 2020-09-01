import Foundation

class Rectangle {
    private var itsTopLeft: Double = 0
    private var itsWidth: Double = 0
    private var itsHeight: Double = 0
    func setWidth(_ w: Double) {
        self.itsWidth = w
    }
    func setHeight(_ h: Double) {
        self.itsHeight = h
    }
    func getWidth() -> Double {
        return itsWidth
    }
    func getHeight() -> Double {
        return itsHeight
    }
}

class Square: Rectangle {
    func setWidth2(_ w: Double) {
        super.setWidth(w)
        super.setHeight(w)
    }
    func setHeight2(_ h: Double) {
        super.setHeight(h)
        super.setWidth(h)
    }
}

let s = Square()

func f(_ r: Rectangle) {
    r.setWidth(32)
}

f(s)

s.getHeight()
s.getWidth()
