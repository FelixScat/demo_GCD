import Foundation

let q = DispatchQueue(label: "top.felixplus.k", qos: .default)

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

//DispatchQueue.main.sync {
//    boiledWater()
//}
//
//DispatchQueue.main.sync {
//    brushTeeth()
//}

//q.sync {
//    boiledWater()
//    q.sync {
//        brushTeeth()
//    }
//}

DispatchQueue.global().async {
    boiledWater()
    brushTeeth()
}

//q.sync {
//    print("aaa")
//    q.async(execute: boiledWater)
//    q.async(execute: brushTeeth)
//    q.sync(execute: {
//        print("ccc")
//    })
//}

print("Enter (q) to quit\n")
while true {
    guard let res = readLine(strippingNewline: true) else {continue}
    if "q" == res { exit(0) }
}
