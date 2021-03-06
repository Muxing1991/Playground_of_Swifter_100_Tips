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
//4.多元组（Tuple）
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
//5.@autoclosure 和 ??
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

//6.Optional Chaining

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
//7.操作符
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


/******************************************************************************/
/******************************************************************************/
//8.func 的参数修饰
//swift语言 参数的修饰默认是let 所以不能在func 里对参数进行修改
func incrementor(inout input: Int) {
  //return ++input 报错
  // 必须在参数上用 inout修饰
   input += 1 //这种修饰方式 就不用返回了
}

var funcModifyInput = 7
incrementor(&funcModifyInput)
print(funcModifyInput)

//在层级间保证 参数的修饰是一致的
func makeIncrementor(addNumber: Int) -> (inout Int) -> (){
  func incrementor(inout input: Int) -> (){
    input += addNumber
  }
  return incrementor
}

let incrementorByMI = makeIncrementor(7)
incrementorByMI(&funcModifyInput)
print(funcModifyInput)


/******************************************************************************/
/******************************************************************************/

//9.字面量转换
//这一组接口用于将 例如 整型 字符串 布尔值 数组 数组字面量 字典字面量 nil字面量 这些字面量转换成对应的类型
//Int 为原始值的枚举
enum MyBool: Int{
  case MyTrue, MyFalse
}
extension MyBool: BooleanLiteralConvertible{
  init(booleanLiteral value: BooleanLiteralType) {
    //在这个接口中 BooleanLiteralType 就是 Bool  可以用true 和 false 来初始化这个MyBool类型
    self = value ? MyTrue : MyFalse
  }
}
//实现了接口后 就把bool值 直接赋值
var myTrue09: MyBool = true
var myFalse09: MyBool = false
print(myTrue09.rawValue)
print(myFalse09.rawValue)

//实现 StringLiteralConvertible 
class Person09: StringLiteralConvertible{
  let name: String
  init(name value: String){
    self.name = value
  }
  //需要是required 而且是 no－final 参数类型都是String 这样就对接口中的typealias进行了赋值
  //这里调用了指定构造器 所以要标注 convenience
  required convenience init(stringLiteral value: String) {
    self.init(name: value)
  }
  
 required convenience init(unicodeScalarLiteral value: String) {
    self.init( name: value)
  }
  
 required convenience init(extendedGraphemeClusterLiteral value: String) {
    self.init(name: value)
  }
  
}

var person09: Person09 = "liubei"
//这样的声明方式可能会给人造成迷惑 慎重使用
print(person09.name)

class MyTest09: IntegerLiteralConvertible{
  var age: Int
  init(age value: Int){
    self.age = value
  }
  convenience required init(integerLiteral value: IntegerLiteralType) {
    self.init(age: value)
  }
}

var mt09: MyTest09 = 20
print(mt09.age)

/******************************************************************************/
/******************************************************************************/

//10.接口和类方法中的Self
//有一种情况 接口中的方法使用的类型(参数、返回值)为实现该接口本身(也包括子类) 用Self指代

protocol Copyable10{
  func copy() -> Self
}

//使用self.dynamicType 获取在运行时的实际类型 这里调用了init方法 所以要求子类也要实现
class MyClass10: Copyable10{
  func copy() -> Self {
    let result = self.dynamicType.init()
    return result
  }
  
  required init(){
    
  }
}

/******************************************************************************/
/******************************************************************************/
//11.属性观察 property observers

class MyClass11{
  var date: NSDate{
    willSet{
      let d = date
      print("the \(d)  will trans to \(newValue)")
    }
    didSet{
      print("old date is \(oldValue), now is \(date)")
    }
  }
  
  init(){
    date = NSDate()
  }
}

let foo11 = MyClass11()

foo11.date = foo11.date.dateByAddingTimeInterval(1024)

//一个类的计算属性 无法同时添加property observers 只能通过子类的重写
class Father11{
  var age: Int {
    get{
      print("get age")
      return 11
    }
    set{
      print("set age")
    }
  }
}

//didSet观察器需要提前访问并保存数据 willSet也需要保存当前数据 所以先执行了两次get
class Child11: Father11{
 override var age: Int{
    willSet{
      print("will set \(age) in child to \(newValue)")
    }
    didSet{
      print("did set \(oldValue) in child to \(age)")
    }
  }
}

var sub11 = Child11()
print(sub11.age)


sub11.age  = 0








