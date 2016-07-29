//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//1. ++ -- 已经被deprecate 要用 -=1 +=1


//2. C风格的for循环已经成为历史 
//alert: C style statement will be deprecate in swift3
var i: Int
for(i = 1; i <= 10; i += 1){
  print(i)
}

for j in 1...10{
  print(j)
}

(1...10).forEach{
  print("num is \($0)")
}


//3.函数不在能够在参数列表内标记var 来指示可变
// 只能 创建临时变量 来 拷贝参数 进行 存储 计算


//4.函数参数不再是 第一个参数默认不需要标签了 而是 全部必须标签 除非显式标注 _


//5.Selector 不再允许使用String

import XCPlayground
//因为UIButton的 addTarget 需要的是NSObject 所以要实现这个protocol
class Responder: NSObject{
  
  func tap(){
    print("Button pressed")
  }
}

let responder = Responder()

let button = UIButton(type: .System)

button.setTitle("Button", forState: .Normal)
//Associates a target object and action method with the control.
//把这个button和一个NSObject及其方法联系起来 所以这里又一个Select
// 字符串就是这个方法的identifier 所以一旦输错 运行时会崩溃
//swift3 改成了#select 可以在编译前 检查
button.addTarget(responder, action: #selector(responder.tap), forControlEvents: .TouchUpInside)
button.sizeToFit()
button.center = CGPoint(x: 50, y: 25)

let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
let view = UIView(frame: frame)
view.addSubview(button)
XCPlaygroundPage.currentPage.liveView = view



//6.不再是String的 key-path 写法

class Person: NSObject{
  var name: String = ""
  
  init(name: String){
    self.name = name
  }
}

let me = Person(name: "kobe")
//valueForkeyPath: Returns the value for the derived property identified by a given key path.
me.valueForKeyPath("name")


//同#selector  swift3 修正为 #keyPath



//7.Foundation 去掉 NS前缀

//获取NSBundle的路径
let file = NSBundle.mainBundle().pathForResource("tutorials", ofType: "json")
//NSURL
let url = NSURL(fileURLWithPath: file!)
//Data
let data = NSData(contentsOfURL: url)
//用于将json解析为对象
let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
print(json)

// 在Swift中 这些NS 代表 NextStep 公司的标志 都会被删除



//8. M_PI -> 三种.pi

//Float.pi
//Double.pi
//CGFloat.pi

//9.GCD  grand central dispatch  大中枢派发
//现在还是C语言的风格
let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
dispatch_async(queue){
  print("it's swift 2.2 style")
}


// Swift 3 更面向对象
// let queue = DispatchQueue(label: "Swift 3")
//queue.async{
// print("it's Swift 3 style")
//}



//9. 更Swift范的Core Graphics

let frame9 = CGRect(x: 0, y: 0, width: 100, height: 50)

class View: UIView{
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    //UIColor 转变为 CGColor
    let blue = UIColor.blueColor().CGColor
    CGContextSetFillColorWithColor(context, blue)
    let red = UIColor.redColor().CGColor
    CGContextSetStrokeColorWithColor(context, red)
    CGContextSetLineWidth(context, 10)
    CGContextAddRect(context, frame)
    CGContextDrawPath(context, .FillStroke)
  }
}

let aView = View(frame: frame)


// swift 3 这些复杂的长方法都会变成context对象的方法



//10. 动词 和 名词的 命名约定
// 一些 英语语法已经改动了
// 返回一个确切的值的方法  就用 名词
// 处理一些事件的方法 就用 动词

(1...10).reverse().forEach{
  print("num is \($0)")
}

// 在 Swift3中 reverse() 变成了 reversed() 这其实是一个形容词 这里用名词来给func 命名 体现了 这是返回一个确切值的方法


var array = ["ni", "ma", "bi"]

for(index, value) in  array.enumerate(){
  print("index is \(index) value is \(value)")
}

//在swift3 中 enumerate 变成了 enumerated // 表示 枚举了的

array.sort()
//在 Swift3 中 变成了 sorted() 



//数组的排序 在 swift2.2 中
array.sortInPlace() // 输出 bi ma ni

//但是 在Swift3中 这被认为是做了一件事 处理了数组 没有返回值的  重命名为 sort()


//11. 更规范的API

// 如果某些词是能够推出来的 都会被移除 不必要


//12. Swift3 把枚举成员 当作属性来看 所以不再使用大写字母开头的枚举成员 而是 小写


//13. 在Swift3 中 方法的返回值没有接收会触发警告 用 @discardableResult 标记


//14. 愿你学好这门优雅的语言
