#### 단일 책임 원칙 (SRP)
##### 한 클래스는 단 한 가지의 변경 이유만을 가져야 한다. 

```
클래스가 가지는 각 책임은 변경의 축이 된다. 
요구사항이 변경될 때, 이 변경은 클래스 안에서의 책임 변경을 통해 명백해진다. 
한 클래스가 하나 이상의 책임을 맡는다면, 그 클래스를 변경할 하나 이상의 이유가 있을 것이다.
```

![the image for SRP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/SRP1.png)

위 구조를 보면, `Rectangle` 클래스는 두가지 동작을 할 수 있다. 

첫번째로 화면에 사각형을 그리는 동작 ( `draw()` ) 을 가지고 있으며, 두번째로 단순히 넓이를 계산하는 동작 ( `area()` ) 을 가지고 있다. 

그리고 이 밖에 두 애플리케이션이 존재하며 이는 모두 Rectangle 클래스를 사용하고 있다. 

하지만 `ComputationalGeometryApplication` 은 기하학 연산을 위한 것이고, `GraphicalApplication` 은 단순히 사각형을 화면에 그리기 위한 것이다. 

그러므로 `Rectangle` 는 각각의 애플리케이션이 필요로 하는 것을 제공하는 책임을 지며, 곧 SRP 원칙을 위반한다고 볼 수 있다. 

이 위반은, `Rectangle` 의 책임을 각각의 클래스로 나눔으로써 해결이 가능하다. 

![the image for SRP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/SRP2.png)

위 구조를 보면, 사각형을 그리는 책임은 오직 기존의 `Rectangle` 클래스에서 가지고 있고 넓이를 계산하는 책임은 새로운 `GeometricRectangle` 클래스에서 가지고 있음을 알 수 있다.

이는 SRP 원칙을 준수하며, 각 클래스의 변경이 다른 클래스에 영향을 미치지 않음을 알 수 있다. 

***
#### 개방 폐쇄 원칙 (OCP)
##### 소프트웨어를 이루는 각 부품들은, 이를 확장할 때에는 쉽게 가능하도록 해야 하고, 수정하려는 것에 대해서는 폐쇄적이어야 한다 .

```
프로그램의 일부를 수정했더니 의존 모듈에서 또한 연쇄적으로 수정해야만 할 때, 
이 설계는 경직성의 악취를 풍긴다고 이야기한다. 
```

개인 프로젝트를 진행할 때, 일부를 조금 바꿨더니 이와 관련된 다른 코드들도 변경해야 했던 경험이 많다. 그때는 몰랐으나 그게 바로 OCP 가 지켜지지 않았음을 증명하는 상황이었다. 

이 경우, `리팩토링` 을 통해 문제를 해결해야 한다. 

```
OCP 를 따르는 모듈의 속성
1. 확장에 대한 개방성
2. 수정에 대한 폐쇄성
```

하지만 `확장` 은 언제나 `수정` 을 일으키는데, 기존의 모듈을 수정하지 않고 확장하는 것은 무엇일까.

---

```
추상화:
	추상 기반 클래스이자, 모든 가능한 파생 클래스를 대표하는
	가능한 행위의 제한되지 않은 묶음이기도 하다.
```

아래는 OCP 를 지키지 않은 구조의 예를 보여준다. 

![the image for OCP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/OCP1.png)

언뜻 보면, 그렇게 잘못된 것이 없는 것처럼 보인다. `Human` 은 `Specific Tool` 이 필요하기 때문에 이를 사용한다.

위 구조를 코드로 옮기면 아래와 같다.

```swift
class Human {}
class SpecificTool {}
```

`Human` 은 `Specific Tool` 을 필요로 한다. 

```swift
class Human {
	var specificTool = SpecificTool()
}
```

`Specific Tool` 은 몇가지 행위를 제공하고 `Human` 은 이를 모두 사용한다. 

```swift
class SpecificTool {
	func grasp() {}
	func lift() {}
	func use() -> Bool {}
	func putDown() {}
}

class Human {
	var specificTool = SpecificTool()
	
	func ready() {
		specificTool.grasp()
		specificTool.lift()
	}
	func start() {
		if specificTool.use() {}
		else {}
	}
	func done() {
		specificTool.putDown()
	}
}
```

쉽게 코드 작성이 마무리될 수 있다. 그런 것 처럼 보인다. 

하지만 요구사항이라는 것은, 매번 바뀐다. 이번에는 `Human` 이 쓰던 도구가 싫증이 났다고 가정하자.

그래서 새로운 도구를 하나 새로 구매했다. 

```swift
class NewTool {}
```

새로운 도구를 보니 기쁨을 감추지 못한다. 하지만 이 도구는 최신식이어서, 기존의 도구와는 전혀 다른 인터페이스를 제공한다. 

```swift
class NewTool {
	battery: Battery
	init(battery: Battery) {
		self.battery = battery
	}

	func turnOn() -> Bool {}
	func turnOff() -> Bool {}
	func use() -> Bool {}
}
```

어쨌든 새로운 도구를 `Human` 클래스가 사용할 수 있도록 해본다. 

```swift
class Human {
	// SpecificTool 은 더 이상 사용하지 않는다.
	// var specificTool = SpecificTool()
	var tool = NewTool(battery: Battery())
	
	// SpecificTool 인터페이스를 모두 지운다.
	func ready() {
		// specificTool.grasp()
		// specificTool.lift()
		if tool.turnOn() {}
		else {}
	}
	func start() {
		// if specificTool.use() {}
		// else {}
		if tool.use() {}
		else {}
		
	}
	func done() {
		// specificTool.putDown()
		if tool.turnOff() {}
		else {}
	}
}
```

단순히 새로운 도구를 하나 가져왔을 뿐이지만, `Human` 클래스를 수정해야 했다. 이는 당연한 것으로 보이지만, 이는 분명 `확장` 이 기존 코드의 `수정` 을 불러 일으킨 예이다. 

이를 추상화를 통해 해결해본다. 

![the image for OCP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/OCP2.png)

```swift
protocol Tool {
	func ready()
	func use()
	func done()
}

class Human {
	var tool: Tool
}
```

`Tool` 프로토콜을 하나 만들어 해당 프로토콜을 가지는 클래스가 가져야 할 메소드를 정의했다. 

그리고 `Human` 클래스에는 특정 도구가 아닌, `Tool` 프로토콜을 따르는 객체를 가질 수 있도록 멤버 변수를 만들었다. 

```swift
class OneTool: Tool {
	func ready() {
		print("ready to use OneTool")
	}
	func use() {
		print("using OneTool")
	}
	func done() {
		print("complete using OneTool")
	}
	...
}
class AnotherTool: Tool {
	func ready() {
		print("ready to use AnotherTool")
	}
	func use() {
		print("using AnotherTool")
	}
	func done() {
		print("complete using AnotherTool")
	}
}

class Human {
	var tool: Tool
	init(tool: Tool) { self.tool = tool }
	...
}

Human(tool: OneTool)
Human(tool: AnotherTool)
```



***
#### 리스코프 치환 원칙 (LSP)
##### 서브타입은 그것의 기반 타입으로 치환 가능해야 한다. 

```
타입 S의 각 객체 o_1과 타입 T의 각 객체 o_2가 있을 때, 
T로 프로그램 P를 정의했음에도 불구하고, o_1이 o_2로 치환될 때
P의 행위가 변하지 않으면, S는 P의 서브타입이다. 

- 바버라 리스코프(Barbara Liskov)
```

LSP의 위반은 대개 심각하게 OCP를 위반하는 런타임 타입 정보 (RTTI: Run-Time Type Information) 사용으로 이어진다. 

* ~~위 문장이 의미하는 바는 정확이 무엇이며~~
* ~~RTTI 는 무엇인가?~~

```swift
// OCP 위반을 유발하는 LSP 위반
class Shape {}
class Square: Shape { func drawSquare() {} }
class Circle: Shape { func drawCircle() {} }

func drawShape(_ shape: Shape) {
	if let circle = shape as? Circle {}
	else if let square = shape as? Square {}
}
```

객체를 치환했을 때에 프로그램의 행위가 변한다면 이는 `LSP` 를 위반하는 것이라고 했다.

위의 코드를 살펴보면, `Circle` 또는 `Square` 로 인자를 치환했을 때 그 타입에 맞는 행위를 `if-else if` 를 통해 바꿔주고 있음을 알 수 있다. 

이 말은 곧, 새로운 도형이 추가될 때마다 `if branch` 또한 더해야 함을 추측할 수 있다.  그러므로 `LSP` 를 위반했지만 이는 `OCP` 를 위반하기도 한다. 

```swift
func drawShape(_ shape: Shape) {
	if let circle = shape as? Circle {}
	else if let square = shape as? Square {}
	// 새로운 도형 추가
	// OCP 의 위반
	else if let triangle = shape as? Triangle {}
}
```

다음으로 비슷한 예를 살펴본다.

![the image for Rectangle](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/Rectangle.png)

위 다이어그램에서 알 수 있듯이 	`Square` 는 `Rectangle` 을 상속한다. 대략적인 구현은 아래와 같다. 

```swift
class Rectangle {}
class Square: Rectangle {}
```

`Rectangle` 은 자신이 가지는 `height` 와 `width` 을 각각 다루는 인터페이스를 제공한다. 또한 `Square` 도 자신의 특성에 알맞게 이 인터페이스들을 오버라이딩한다. 

```swift
class Ractangle {
	func setHeight(_ height: Double) {}
	func setWidth(_ width: Double) {}
	func getHeight() -> Double {}
	func getWidth() -> Double {}
	...
}
class Square: Rectangle {
	override func setHeight(_ height: Double) {}
	override func setWidth(_ width: Double) {}
	override getHeight() -> Double {}
	override getWidth() -> Double {}
	...
}
```
여기에서 `Square` 가 인터페이스들을 오버라이딩 해야 했던 이유는 분명하다. `Rectangle` 의 경우 높이와 넓이가 서로 다르기 때문에 각각의 인터페이스를 필요로 하지만 `Square` 의 경우, 넓이와 높이가 같아 인터페이스의 행동을 달리 해줘야 한다. 

결과적으로 다음 함수는 정상적으로 작동할 것이다.
```swift
func setArea(rectangle: Rectangle) {
	rectangle.setWidth(10)
	rectangle.setHeight(8)
}

setArea(Square())
setArea(Rectangle())
```

`Square` 은 `Rectangle` 을 상속하며, 같은 인터페이스를 가지지만 행동은 달리한다. 따라서 위의 코드는, `Square` 의 경우 사이즈를 두번 설정하기 때문에 어색하지만, 원하는 결과를 얻을 수 있다. 

하지만 다음의 함수를 살펴보자.

```swift
func setArea(rectangle: Rectangle) {
	rectangle.setWidth(5)
	rectangle.setHeight(4)

	assert(rectangle.area() == 20)
}
```

주어진 함수에서 이 작성자는 무엇을 원하고 있을까?
해당 함수로 `Rectangle` 을 전달했을 때, 이 인자의 `setWidth` 와 `setHeight` 가 각각 넓이와 높이를 설정할 것이라고 작성자는 가정했다. 

따라서 이 함수에 `Square` 객체를 전달하면 실패하게 된다. 함수 `setArea` 는 `Square/Rectangle` 계층 구조에 대해 `취약`하다. 

`Square` 와 `Rectangle` 이 치환 가능하지 않기 때문에, 이들 사이의 관계는 `LSP` 를 위반한다. 

> OCP 는 OOD 를 위해 논의된 수많은 의견 중에서도 핵심이다. 이 원칙이 효력을 가질 때, 애플리케이션은 좀 더 유지보수 가능하고, 재사용 가능하고, 견고해진다. LSP 는 OCP 를 가능하게 하는 주요 요인 중 하나다.

***
#### 의존 관계 역전 원칙 (DIP)

1. 상위 수준의 모듈은 하위 수준의 모듈에 의존해서는 안 된다. 둘 모두 추상화에 의존해야 한다. 
2. 추상화는 구체적인 사항에 의존해서는 안 된다. 구체적인 사항은 추상화에 의존해야 한다.

> 잘 설계된 객체 지향 프로그램의 의존성 구조는 전통적인 절차적 방법에 의해 일반적으로 만들어진 의존성 구조가 `역전`된 것이다.

![the image for DIP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/DIP1.png)
 
 위 다이어그램에서 보면 구조가 나름의 규칙에 의해서 잘 나뉜 것처럼 보인다. 

하지만 이것은 각각의 하위 레이어에 의존하게 함으로써, 어떤 상위의 레이어가 그 아래 존재하는 모든 레이어에 민감하도록 만든다는 데에 그 결점이 있다.

`A` 레이어는 `B` 레이어에 의존적인 것과 동시에, `C` 레이어에 의존적이게 된다. 직접 의존하지도 않는데 불구하고 말이다. 

이러한 의존성을 `transitive` 하다고 말한다.

![the image for DIP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/DIP2.png)

각각의 레이어들은 추상 인터페이스를 만들고, 각 하위 레이어들은 이를 구현한다. 따라서 상위 레이어는 하위 레이어에 의존하지 않으며, 오히려 하위 레이어가 상위 레이어의 인터페이스에 의존한다. 

`역전`은 각 레이어의 의존성의 방향 뿐만 아니라 소유권 또한 바꾸었다. 필요한 서비스에 대한 `인터페이스` 를 `클라이언트` 가 가지고 있다는 것이다. 

> Don't call us, we'll call you.

##### 추상화에 의존해라.

프로그램의 모든 관계는 `Concrete class` 가 아니라 `Abstract class` 또는 `Interface` 를 통해야 한다. 

##### Button-Lamp Problem

`Button` 와 `Lamp` 클래스가 각각 있다. 

```swift
class Button {}
class Lamp {}
```

`Button` 은 `on` 과 `off` 상태를 가질 수 있다.

```swift
class Button {
	var state: Bool = false // true: on; false: off
}
```

`Lamp` 는 이를 켜고 끄는 방법을 가진다.

```swift
class Lamp {
	func turnon() {}
	func turnoff() {}
}
```

`Button` 은 상태 (on off) 에 따라 `Lamp` 를 조작하려고 한다. 그래서 `Button` 은 조작하려는 `Lamp` 객체를 하나 가진다.

```swift
class Button {
	...
	var lamp: Lamp
	init(_ lamp: Lamp) {
		self.lamp = lamp
	}
}
```

상태를 확인하고 `Lamp` 를 조작하기 위해 `checkAndOrder` 메소드를 가진다. 

```swift
class Button {
	...
	func checkAndOrder() {
		if somestate { lamp.turnOn() }
	}
}
```

확실히 `Button` 이 `Lamp` 에 의존하고 있음을 알 수 있다. `Button` 이 `Lamp` 를 참조함으로써 사용하고 있고, 이후 `Lamp` 의 변경이 있을 때 `Button` 의 수정 또한 불가피하다. 

![the image for DIP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/DIP3.png)

위 다이어그램은 위에서 설명했던 구조를 보여주는데, `외부 요인` 에 의해 `Button` 객체가 상태를 변경하면 이는 다시 `Lamp` 객체를 조작하여 그 결과, `외부 환경` 이 변경됨을 묘사하고 있다. 

이 문제는 `상위 수준 정책` 이 `하위 수준 구현` 에서 분리되어 있지 않다고 이야기한다. `추상화` 는 `구체적인 것` 에서 분리되어 있지 않으며 이런 상황에서 상위 수준 정책은 하위 수준 모듈에 의존하게 된다고 한다. 

* 정책의 수준은 어떻게 정해지는 것인가?
	* 어떤 모듈이 더 상위 수준인지, 어떤 모듈이 더 하위 모듈인지 그 기준은 무엇인가?

정책의 수준 문제를 떼어 두고, 추상화의 관점에서 위 다이어그램을 살펴보면 확실히 추상화는 분리되지 않았음을 알 수 있다 .

> 상위 수준의 정책: 애플리케이션에 내재하는 추상화이자, 구체적인 것이 변경되더라도 바뀌지 않는 진실. 시스템 안의 시스템, 메타포. 

다시 `Button-Lamp` 를 살펴본다. 

`Button` 은 켜짐·꺼짐과 같은 상태를 갖는 도구이다. 이것에 영향을 미치는 외부 요인은 무엇이 될 수 있나? `Button` 은 특정 상황에 한정되지 않는다. 

1. 손으로 눌러 상태를 변경할 수 있다. 
2. 마우스로 클릭해 상태를 변경할 수 있다. 
3. ...

`Lamp` 는 켜고 끄는 동작을 통해 불을 켜거나 끈다. 즉, 외부 환경에 영향을 미친다. 

`Button` 은 이미 외부 요인에 대해서 통일된 인터페이스를 제공하는 클래스라고 생각해보면, `Lamp` 는 아직 그렇지 않아 보인다. 오히려 이 클래스는 변화가 생기는 외부 환경 중 하나라고 볼 수 있을 것 같다. 

기존의 다이어그램은 아래와 같이 수정할 수 있다. 

![the image for DIP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/DIP4.png)

위 다이어그램을 보면, `Button` 클래스는 구체적인 외부 환경, `Lamp` 에 의존하고 있음을 알 수 있다. 

바로 이 부분에서, 우리는 추상화를 꺼내어 따로 `Button` 과 `Lamp` 사이에 배치할 수 있다. 

![the image for DIP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/DIP5.png)

다시 수정된 다이어그램을 보면 위에서 살펴본 바와 같이, 의존성이 `역전`된 것을 확인할 수 있다. `Buton` 클래스는 이제 `ButtonServiceInterface` 를 소유하고 있으며, `Lamp` 는 이 인터페이스를 구체화 한다. 

```swift
protocol ButtonServiceInterface {...}
class Button {
	var btnSvsInterface: ButtonServiceInterface
	...
	func checkAndOrder() {
		if somestate { 
			btnSvsInterface.turnon()
		}
	}
}

extension Lamp: ButtonServiceInterface {...}
```

확실히 이제 `Button` 은 영향을 미치고자 하는 타겟이 무엇이든 간에, `ButtonServiceInterface` 타입이라면 다른 코드를 수정하지 않고도 정상적으로 작동할 수 있다. 
 

***
#### 인터페이스 분리 원칙 (ISP)

책에 언급된 `ISP` 의 개념이 이해되지 않아서 먼저 예제 코드를 살펴보았다. 

어떤 보안 시스템이 있으며 여기에는 잠기거나 열릴 수 있는 `Door` 객체들이 있다. 또 이 객체들은 그 상태를 알 수 있다. 

```swift
class Door {
	func lock() {}
	func unlock() {}
	func isDoorOpen() -> Bool {}
}
```

이 `Door` 를 상속하는 `TimedDoor` 가 있다. 이 문은 열린 채로 특정 시간이 지나면 알람을 울린다. 마치 냉장고처럼!

그래서 `TimedDoor` 는 시간을 체크하기 위해 `Timer` 라는 별도의 객체와 메시지를 주고 받는다. 

```swift
class Timer {
	func register(timeout: Int, client: TimerClient) {}
}
protocol TimerClient {
	func timeout()
}
```

타이머를 등록하고자 하는 객체는 `Timer` 의 `register` 를 호출한다. 이 함수는 특정 시간이 지났을 때 `TimerClient` 의 `timeout` 을 호출한다. 

![the image for ISP](https://github.com/sangeui/SOLID-Principles/blob/master/Resources/Images/ISP1.png)

일반적으로는 미숙한 개발자라 할지라도 `Timed Door` 에서 `Timer Client` 인터페이스를 구현하도록 했겠지만 아마 `ISP` 를 설명하기 위해 위 구조를 예시로 가져온 것 같다.

아무튼 위에 보여진 구조대로라면 `Door` 와 `Timed Door` 의 최상위에 `Timer Client` 인터페이스가 존재한다. 즉, `Timed Door` 뿐만 아니라 `Door` 도 해당 인터페이스를 구현하고 있음을 의미한다. 필요하다면 `Timer` 에 `Door` 도 전달할 수 있을 것이다. 하지만 우리는 이미 그 용도로 `Timed Door` 를 가지고 있다!

이러한 구조는 이상해 보이지는 않지만, `Door` 는 이제 이 인터페이스에 의존하게 되었고, 이를 상속하는 모든 클래스가 이 인터페이스를 가지게 된다. 더군다나 하위 클래스가 타이머 기능을 전혀 사용하지 않는다면 `timeout` 메소드의 구현을 퇴화시켜야 한다. 이는 잠재적인 `LSP` 위반이다. 

결과적으로 위 구조는 `불필요한 복잡성`과 `중복성`의 악취를 풍기게 된다.

>**클라이언트의 분리는 인터페이스의 분리를 의미한다.** 

`Door` 는 잠기거나 열릴 수 있고 그 상태를 알고 있는 클래스이며 `Timer` 는 타이머를 제공하는 클래스라고 했다. 

어떤 클라이언트가 이 각각의 클래스를 사용할 수 있을까?

`Door` 를 사용하고자 하는 클라이언트는 이를 통해 문을 조작하고 싶을 것이다. 반면에 `Timer` 를 원하는 클라이언트는 타이머를 사용하고 싶을 것이다. 

이렇게  각 클래스를 원하는 클라이언트가 분리될 수 있다. 그러므로 인터페이스도 분리되어야 한다고 이야기한다. 클라이언트에서 자신이 사용하는 인터페이스에 영향을 끼치기 때문이다. 

**인터페이스 분리 원칙(ISP)**

>클라이언트가 자신이 사용하지 않는 메소드에 의존하도록 강제되어서는 안 된다.

`Door` 가 사용하지 않는 `TimerClient` 를 구현함으로써, 사용하지도 않는 인터페이스 갖게 되는데, 이제부터 `Door` 는 `TimerClient` 의 변경에 영향을 받게 된다. 

이러한 결합을 피하기 위해서는 인터페이스를 분리해야 한다.

- 위임
- 다중 상속

먼저 위임을 통해서 인터페이스를 분리하는 방법이 있다. 이 방법은 `TimedDoor` 와 `TimerClient` 사이에 어댑터를 하나 두는 것이다. 이때 어댑터는 `TimerClient` 를 구현한다.

```swift
class DoorTimerAdapter: TimerClient {
	private var door: TimedDoor
	init(door: TimedDoor) {
		self.door = door
	}
	
	func timeout(tiemoutID: Int) {
		door.doorTimeout(timeoutID)
	}
}
```

기존에는 `Timer` 에 `TimerClient` 를 따르는 `Door` 클래스를 직접 전달했다면, 이번에는 대신 `Adapter` 를 전달한다. 

```swift
Timer().register(client: Door) // 이전 버전
Timer().register(client: Adapter) // 새 버전
```

때문에 타이머를 등록하기 위해서는 매번 새로운 Adapter 를 생성하게 되는데, 이는 아주 작지만 문제가 아예 되지 않는 것은 아니다. 

다음은 다중 상속을 통한 분리인데, 이 방법이 이해가 더 쉬우며 간단해 보인다. 단순히 `TimedDoor` 가 `Door` 와 `TimerClient` 를 상속하도록 한다. 

```swift
class TimedDoor: Door {}
extension TimedDoor: TimerClient {}
```

확실히 단순하고 깔끔해 보인다. 

***

