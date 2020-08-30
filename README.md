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
프로그램의 일부를 수정했더니 의존 모듈에서 또한 연쇄적으로 수정해야만 할 때, 이 설계는 경직성의 악취를 풍긴다고 이야기한다. 
```
***
#### 리스코프 치환 원칙 (LSP)
***
#### 의존 관계 역전 원칙 (DIP)
***
#### 인터페이스 분리 원칙 (ISP)
***

