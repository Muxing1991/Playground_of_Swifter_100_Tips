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







