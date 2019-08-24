# Grand Central Dispatch

这篇文主要想总结下 `GCD` 在swift中的使用，[文中示例代码](https://github.com/FelixScat/demo_GCD)

## 基本概念

### 进程

进程指在系统中能独立运行并作为资源分配的基本单位，它是由一组机器指令、数据和堆栈等组成的，是一个能独立运行的活动实体

### 线程

线程是进程的基本执行单元，一个进程（程序）的所有任务都在线程中执行。

### 队列

队列，又称为伫列（queue），是先进先出（FIFO, First-In-First-Out）的线性表。在具体应用中通常用链表或者数组来实现。队列只允许在后端（称为rear）进行插入操作，在前端（称为front）进行删除操作。队列的操作方式和堆栈类似，唯一的区别在于队列只允许新数据在后端进行添加。

### 同步/异步

可以这么理解：

假如你要做两件事 ， 烧水 、 刷牙

- 同步 ：你烧水 ， 等水烧开了你再去刷牙
- 异步 ：你烧水 ，不等水烧开就去刷牙了 ， 水烧开了会发出声音告诉你（callback） ， 然后你再处理水烧开之后的事情

**只要你是个正常人 ， 都会选择第二种 ，当然也有特殊情况 ，你喜欢用热水刷牙**

### 并发

指两个或多个事件在同一时间间隔内发生。可以在某条线程和其他线程之间反复多次进行上下文切换，看上去就好像一个CPU能够并且执行多个线程一样。其实是伪异步。

### 线程队列中并行/串行

串行队列：串行队列的特点是队列内的线程是一个一个执行，直到结束。并行队列：并行队列的特点是队列中所有线程的执行结束时必须是一块的，队列中其他线程执行完毕后，会阻塞当前线程等待队列中其他线程执行，然后一块执行完毕。

***

## 开始

下面我们就用刷牙与烧水来举例，首先创建一个命令行工程，[本文工程Demo](https://github.com/FelixScat/demo_GCD)

```sh
mkdir swiftGCD && cd swiftGCD
swift package init --type executable
swift package generate-xcodeproj
xed ./
```

打开`main.swift`先声明两个事件

```
/// 烧水
let boiledWater = {
    print("开始烧水: \(Thread.current)")
    sleep(3)
    print("水烧好啦")
}

/// 刷牙
let brushTeeth = {
    print("开始刷牙:\(Thread.current)")
    sleep(5)
    print("牙刷完啦")
}
```

### 串行





## 参考

[https://stackoverflow.com/questions/23856230/what-is-the-difference-between-gcd-main-queue-and-the-main-thread](https://stackoverflow.com/questions/23856230/what-is-the-difference-between-gcd-main-queue-and-the-main-thread)



























### 如何使用

```swift
DispatchQueue.global().async {

    print("do something in global \(Thread.current)")

    DispatchQueue.main.async {

        print("do something in main \(Thread.current)")
    }
}
```

这里使用了全局的队列执行一些任务 ， 然后切回主队列 , 这里要注意主队列是运行在主线程上的任务堆栈 。

### 自定义队列

除了使用全局队列外我们还可以使用自定义的队列

```swift
let q = DispatchQueue(label: "com.felix.felix")
```

初始化一个队列最简单的方式就是声明它的标签 。

### async

打开Xcode,新建一个commandLineTool工程、
打开main.swift

```swift
let q = DispatchQueue(label: "com.felix.felix")

q.sync {
    (1...5).forEach({ i in
        print("🍎 \(Thread.current) + \(i)")
    })
}
q.async {
    (6...10).forEach({ i in
        print("🍇 \(Thread.current) + \(i)")
    })
}
(11...15).forEach({ i in
    print("🍌 \(Thread.current) + \(i)")
})
```

先声明一个队列,使用sync添加一个同步的任务输出1到5,使用async异步输出6到10,同时在主线程打印11到15 。

按下command+R运行project,

```swift
🍎 <NSThread: 0x103103480>{number = 1, name = main} + 1
🍎 <NSThread: 0x103103480>{number = 1, name = main} + 2
🍎 <NSThread: 0x103103480>{number = 1, name = main} + 3
🍎 <NSThread: 0x103103480>{number = 1, name = main} + 4
🍎 <NSThread: 0x103103480>{number = 1, name = main} + 5
🍌 <NSThread: 0x103103480>{number = 1, name = main} + 11
🍇 <NSThread: 0x103007940>{number = 2, name = (null)} + 6
🍌 <NSThread: 0x103103480>{number = 1, name = main} + 12
🍇 <NSThread: 0x103007940>{number = 2, name = (null)} + 7
🍌 <NSThread: 0x103103480>{number = 1, name = main} + 13
🍇 <NSThread: 0x103007940>{number = 2, name = (null)} + 8
🍌 <NSThread: 0x103103480>{number = 1, name = main} + 14
🍇 <NSThread: 0x103007940>{number = 2, name = (null)} + 9
🍌 <NSThread: 0x103103480>{number = 1, name = main} + 15
🍇 <NSThread: 0x103007940>{number = 2, name = (null)} + 10
Program ended with exit code: 0
```

我们可以看到,🍎代表的任务全部是优先执行的,这说明sync添加的任务会阻塞当前线程,在看到🍌和🍇是均匀分部的,这是由于async添加的任务会默认加入由系统管理的线程池,异步执行 。

### 优先级 QoS

当多个队列同时执行的时候,系统需要知道哪个队列优先级更高,才能优先安排计算资源给他,我们可以这样定义优先级：

```swift
let q = DispatchQueue(label: "com.felix.felix", qos: DispatchQoS.background)
```

初始化的时候加上qos参数 ， qos（quality of service）从字面上理解就是「服务质量」，在swift中是这样定义的：

```swift
public enum QoSClass {

        @available(OSX 10.10, iOS 8.0, *)
        case background

        @available(OSX 10.10, iOS 8.0, *)
        case utility

        @available(OSX 10.10, iOS 8.0, *)
        case `default`

        @available(OSX 10.10, iOS 8.0, *)
        case userInitiated

        @available(OSX 10.10, iOS 8.0, *)
        case userInteractive

        case unspecified

        @available(OSX 10.10, iOS 8.0, *)
        public init?(rawValue: qos_class_t)

        @available(OSX 10.10, iOS 8.0, *)
        public var rawValue: qos_class_t { get }
    }
```

- User Interactive： 和用户交互相关，比如动画等等优先级最高。比如用户连续拖拽的计算
- User Initiated： 需要立刻的结果，比如push一个ViewController之前的数据计算
- Utility： 可以执行很长时间，再通知用户结果。比如下载一个文件，给用户下载进度。
- Background： 用户不可见，比如在后台存储大量数据

在选择优先级时可以参考如下判断 。

- 这个任务是用户可见的吗？
- 这个任务和用户交互有关吗？
- 这个任务的执行时间有多少？
- 这个任务的最终结果和UI有关系吗？

## 并发队列

默认情况下添加进Queue的任务会串行执行 ， 先执行完一个再执行下一个：

```swift
import Foundation

let q = DispatchQueue(label: "com.felix.felix")

q.async {
    (1...5).forEach({ i in
        print("🍎 \(Thread.current) + \(i)")
    })
}
q.async {
    (6...10).forEach({ i in
        print("🍇 \(Thread.current) + \(i)")
    })
}
(11...15).forEach({ i in
    print("🍌 \(Thread.current) + \(i)")
})
```

运行看下日志输出

```swift
🍎 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 1
🍌 <NSThread: 0x100f046f0>{number = 1, name = main} + 11
🍎 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 2
🍌 <NSThread: 0x100f046f0>{number = 1, name = main} + 12
🍎 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 3
🍌 <NSThread: 0x100f046f0>{number = 1, name = main} + 13
🍎 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 4
🍌 <NSThread: 0x100f046f0>{number = 1, name = main} + 14
🍎 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 5
🍌 <NSThread: 0x100f046f0>{number = 1, name = main} + 15
🍇 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 6
🍇 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 7
🍇 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 8
🍇 <NSThread: 0x102a081a0>{number = 2, name = (null)} + 9
Program ended with exit code: 0
```

我们可以看到直到🍎都输出完毕才会输出🍇,有时候我们想把任务并行执行,怎么办呢。
可以设置queue的Attributes。

```swift
let q = DispatchQueue(label: "com.felix.felix", attributes: DispatchQueue.Attributes.concurrent)
```

再运行下看看会怎样。

### DispatchWorkItem

有的时候,对于同一个操作我们有可能会放在不同的线程中去执行,这样我们就可以把这个操作用DispatchWorkItem的形式包裹起来,在不同的线程中执行 。

```swift
import Foundation

let group = DispatchGroup()

let q = DispatchQueue(label: "com.felix.felix", attributes: DispatchQueue.Attributes.concurrent)

let item1 = DispatchWorkItem {
    (1...5).forEach({ i in
        print("🍎 \(Thread.current) + \(i)")
    })
}

let item2 = DispatchWorkItem {
    (6...10).forEach({ i in
        print("🍇 \(Thread.current) + \(i)")
    })
}


q.async(execute: item1)

q.async(execute: item2)

(11...15).forEach({ i in
    print("🍌 \(Thread.current) + \(i)")
})
```

### Group 队列组

DispatchGroup 可以用来管理一组队列,监听所有队列的所有任务都完成的通知,比较常用的就是在一个页面请求多个接口的时候,全部请求完再刷新UI 。

pass

### 延时执行

pass

### 线程安全

pass

### 总结

总之,使用GCD一方面会提升我们应用的性能,给用户带来更好的体验,不过一定要注意线程安全问题。