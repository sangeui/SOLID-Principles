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



***
#### 인터페이스 분리 원칙 (ISP)
***

