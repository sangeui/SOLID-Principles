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

```
```

***
#### 리스코프 치환 원칙 (LSP)
***
#### 의존 관계 역전 원칙 (DIP)
***
#### 인터페이스 분리 원칙 (ISP)
***

