import Foundation

/// 串行队列
let serialQueue = DispatchQueue(label: "top.felixplus.k.serial", qos: .default)
/// 并行队列
let concurrentQueue = DispatchQueue(label: "top.felixplus.k.concurrent", qos: .default, attributes: .concurrent)

/// 烧水
let boiledWater = DispatchWorkItem{
    print("开始烧水: \(Thread.current)")
    sleep(3)
    print("水烧好啦")
}

/// 刷牙
let brushTeeth = DispatchWorkItem{
    print("开始刷牙:\(Thread.current)")
    sleep(5)
    print("牙刷完啦")
}

// 同步任务
//DispatchQueue.global().sync {
//    boiledWater()
//    brushTeeth()
//}

// 异步任务
//DispatchQueue.global().async(execute: boiledWater)
//DispatchQueue.global().async(execute: brushTeeth)

//(1...1000).forEach { (i) in
//    DispatchQueue.global().async(execute: boiledWater)
//    DispatchQueue.global().async(execute: brushTeeth)
//}


// workItem
//DispatchQueue.global().async {
//    boiledWater.perform()
//    brushTeeth.perform()
//}
//boiledWater.cancel()

// 死锁
//DispatchQueue.main.sync {
//    boiledWater.perform()
//}

//serialQueue.sync {
//    boiledWater.perform()
//}

//let signal =  DispatchSemaphore(value: 2)
//
//signal.wait()
//DispatchQueue.global().async {
//    boiledWater.perform()
//    signal.signal()
//}
//
//signal.wait()
//DispatchQueue.global().async {
//    brushTeeth.perform()
//    signal.signal()
//}
//
//signal.wait()
//DispatchQueue.global().async {
//    boiledWater.perform()
//    signal.signal()
//}
//
//signal.wait()
//DispatchQueue.global().async {
//    brushTeeth.perform()
//    signal.signal()
//}

//let signal =  DispatchSemaphore(value: 0)
//concurrentQueue.async {
//    boiledWater.perform()
//    signal.signal()
//}
//
//signal.wait()
//
//concurrentQueue.async {
//    brushTeeth.perform()
//}


// Group
//let group = DispatchGroup()

//concurrentQueue.async(group: group, execute: boiledWater)
//concurrentQueue.async(group: group, execute: brushTeeth)

//group.enter()
//concurrentQueue.async {
//    boiledWater.perform()
//    group.leave()
//}
//
//group.enter()
//serialQueue.sync {
//    brushTeeth.perform()
//    group.leave()
//}
//
//group.notify(queue: concurrentQueue) {
//    print("All done")
//}
//
//group.wait()
//print("All done")

// barrier
///// 烧水
//let boiledWaterWithBarrier = DispatchWorkItem(qos: .default, flags: .barrier) {
//    print("开始烧水: \(Thread.current)")
//    sleep(3)
//    print("水烧好啦")
//}
//
///// 刷牙
//let brushTeethWithBarrier = DispatchWorkItem(qos: .default, flags: .barrier) {
//    print("开始刷牙:\(Thread.current)")
//    sleep(5)
//    print("牙刷完啦")
//}
//
//concurrentQueue.async(execute: boiledWaterWithBarrier)
//concurrentQueue.async(execute: brushTeethWithBarrier)

let list = Array(0...100000)
var result = [Int]()


concurrentQueue.async {
    
    
    DispatchQueue.concurrentPerform(iterations: list.count) { (i) in
        if (i % 17 == 0) {
            serialQueue.sync {
                result.append(list[i])
            }
        }
    }
    serialQueue.sync(execute: {
        print(result)
    })
}

print("Enter (q) to quit\n")
while true {
    guard let res = readLine(strippingNewline: true) else {continue}
    if "q" == res { exit(0) }
}
