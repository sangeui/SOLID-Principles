import Foundation

// 용광로의 조절기를 제어하는 소프트웨어
// IO 채널에서 현재 온도를 읽고
// 다른 IO 채널에 명령어를 전송하여 용광로를 켜거나 끈다.

class Thermometer {
    var temperature: Double = 0.0
    func getTemperature() -> Double { return self.temperature }
}
class Furnace {
    func engage() {}
    func disengage() {}
}

let thermometer = Thermometer()
let furnace = Furnace()

func regulate(minTemp: Double, maxTemp: Double) {
    while true {
        while (thermometer.getTemperature() > minTemp) {}
        furnace.engage()
        while (thermometer.getTemperature() < maxTemp) {}
        furnace.disengage()
    }
}

/*
 핵심 정책은 온도 측정 객체로부터 전달 받은 온도가 최소 온도보다 낮다면 용광로를 `engage`, 최대 온도보다 높다면 용광로를 'disengage' 한다.
 하지만 코드에서 알 수 있듯이 이 로직은 추상화 되어 있지 않다. 대신 구체적인 하드웨어에 의존하고 있다.
 
 1. 온도를 받아오는 데 추상 인터페이스를 사용하는 대신 `Thermometer` 라는 구체 클래스를
 2. 온도를 조절하는 데 추상 인터페이스를 사용하는 대신 `Furnace` 라는 구체 클래스를 사용하고 있다.
 
 `regulate` 와 각각의 구체 클래스 사이에 인터페이스를 집어 넣어 추상화를 끌어내본다.
 */

protocol ThermometerInterface {
    func read() -> Double
}
protocol HeaterInterface {
    func heat()
    func cool()
}

// 프로토콜을 각각 작성했으니, 구체 클래스들이 이를 따르도록 한다.

extension Thermometer: ThermometerInterface {
    func read() -> Double {
        return self.temperature
    }
}
extension Furnace: HeaterInterface {
    func heat() {
        self.engage()
    }
    func cool() {
        self.disengage()
    }
}

// `regulate` 함수를 재작성
// 이전에는 `regulate` 함수가 각각의 클래스에 대해 의존성을 갖었던 반면, 중간에 인터페이스를 둠으로써 그 의존성의 방향을 역전시켰다.
// 이후 특정 하드웨어가 변경되더라도 이 함수는 영향을 받지 않을 수 있다.

func regulate(thermometer: ThermometerInterface, heater: HeaterInterface, minTemp: Double, maxTemp: Double) {
    while true {
        while (thermometer.read() > minTemp) {}
        heater.heat()
        while (thermometer.read() < maxTemp) {}
        heater.cool()
    }
}
