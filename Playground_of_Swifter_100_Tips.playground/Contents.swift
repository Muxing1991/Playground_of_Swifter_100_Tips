//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//1.柯里化 currying  把多个参数的方法进行变形 使其更加灵活
func addition(left: Int, right: Int) -> Int{
  return left + right
}

func additionCurrying(first: Int) -> (Int) -> Int{
  return {
    num in
    first + num
    //返回一个捕获第一个参数的一个 （Int） -> Int 的函数
  }
}

let additionTwo = additionCurrying(2)
print(additionTwo(7))

func greaterThan(num: Int) -> Int -> Bool{
  return { $0 > num }
}
let greaterThan7 = greaterThan(7)
print(greaterThan7(9))
//一种量产相似方法的手段

/******************************************************************************/
/******************************************************************************/

//3.Sequence  for-in 遍历的协议
//for-in 循环会在开始前调用collection表达式的generate方法来获取一个生成器（实现了GeneratorType  该协议需要一个元素类型 和 next方法)，然后调用这个生成器的next方法


class MyReverseGenerator<T>: GeneratorType{
  typealias Element = T
  var array: [Element]
  var currentIndex: Int
  init(array: [Element]){
    self.array = array
    currentIndex = array.count - 1
  }
  func next() -> Element?{
    if currentIndex < 0{
      return nil
    }
    else{
      let element = array[currentIndex]
      currentIndex -= 1
      return element
    }
  }
}

struct MyReverseSequence<T>: SequenceType{
  var array: [T]
  init(array: [T]){
    self.array = array
  }
  
  typealias Generator = MyReverseGenerator<T>
  
  func generate() -> Generator {
    return Generator(array: self.array)
  }
}



let myArr = ["yellow", "black", "silver"]
for color in MyReverseSequence(array: myArr){
  print(color, terminator: " ")
}
print()

/******************************************************************************/
/******************************************************************************/
//多元组（Tuple）
func tupleSwap<T>(inout a a: T, inout b: T){
  (a, b) = (b,a)
}


var tupleBlackColor = "black", tupleWhiteColor = "white"
tupleSwap(a: &tupleBlackColor, b: &tupleWhiteColor)
print("tupleBlackColor = \(tupleBlackColor)")
print("tupleWhiteColor = \(tupleWhiteColor)")

var rect = CGRect(x: 0, y: 0, width: 100, height: 100)
var small: CGRect
var large: CGRect
//这个方法返回被分割的 和 剩余的多元组 .MinXEdge表示从横坐标的最小开始数
(small, large) = rect.divide(20, fromEdge: .MinXEdge)

print(small)
print(large)

/******************************************************************************/
/******************************************************************************/
//@autoclosure 和 ??
//将一句表达式自动封装成一个闭包
func argIsFunc(aFunc: () -> Bool){
  if aFunc(){
    print("true")
  }
  else{
    print("false")
  }
}
//完整的闭包表达式
argIsFunc({() -> Bool in return 2 > 1})
argIsFunc({return 2 > 1})
argIsFunc({2 > 1})
argIsFunc{2 < 1}

//如果使用@autoclosure 就可以用括号() 里面的表达式会自动封装成闭包
func argIsFunc2(@autoclosure aFunc: () -> Bool){
  if aFunc(){
    print("true")
  }
  else{
    print("false")
  }
}


//@autoclosure 的作用就是让你能够延迟求值 如果这个表达式是耗费计算的话 效果更好
//??
var level: Int?
var startLevel = 1
var currentLevel = level ?? startLevel
//func ??<T>(optional: T?, @autoclosure defaultValue: () throws -> T) -> T
//func ??<T>(optional: T?, @autoclosure defaultValue: () throws -> T?) -> T?
//defaultValue 是自动闭包 如果不需要执行就不需要准备与计算
//注意  @autoclosure 是只能用于 () -> SomeType
var isPrinted = false
var arr1 = ["a"]
var autoclosureResult = isPrinted && arr1.removeFirst() == "a"
print(arr1)
//&& 的实现 （我的猜测）函数的声明来自于Dash
func &&<T : BooleanType, U : BooleanType>(lhs: T, @autoclosure rhs: () throws -> U) -> Bool{
  if !lhs.boolValue{
    return false
  }
  else {
     return try! rhs().boolValue
  }
}
//不用为rhs传入一个() -> Bool 的自动闭包 而是@autoclosure自动把rhs表达式封装成闭包 延迟求值

/******************************************************************************/
/******************************************************************************/

//Optional Chaining 

//在 optional chaining 中 可空链对象的返回void的函数 返回的是Void?
class Toy{
  let name: String
  init(name: String){
    self.name = name
  }
}

class Pet{
  var toy: Toy?
}
class Child{
  var pet: Pet?
}

extension Toy{
  func play(){}
}

let playClosure = {(child: Child) -> Void? in child.pet?.toy?.play()}
//不写? 也不会报错
let xiaoming = Child()
if let result = playClosure(xiaoming){
  print("fun")
}
else {
  print("not fun")
}
if playClosure(xiaoming) != nil{
  print("调用成功")
}
else {
  print("调用失败")
}
//可以通过判断可空链的void方法是否为nil来判断是否能够调用成功


/******************************************************************************/
/******************************************************************************/
//操作符 
struct  Vector2D{
  var x = 0.0
  var y = 0.0
}

let v1 = Vector2D(x: 1.22, y: 2.33)
let v2 = Vector2D(x: 0.5, y: 0.7)

func +(lhs: Vector2D, rhs: Vector2D) -> Vector2D{
  return Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

//负号要加前缀 prefix
prefix func -(operand: Vector2D) -> Vector2D{
  return Vector2D(x: -operand.x, y: -operand.y)
}

func +* (lhs: Vector2D, rhs: Vector2D) -> Double{
  return lhs.x * rhs.x + lhs.y * rhs.y
}

infix operator +* {
  associativity none
  precedence 160
}
//这里的语法很奇怪 大概因为它既不是class struct 或者 func 吧 也没有智能提示
