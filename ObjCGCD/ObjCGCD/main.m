//
//  main.m
//  ObjCGCD
//
//  Created by Felix on 2019/8/26.
//  Copyright © 2019 Felix. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        dispatch_queue_attr_t serial_attr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT,-1);
        dispatch_queue_attr_t concurrent_attr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_DEFAULT,-1);
        
        // 串行队列
        dispatch_queue_t serialQueue = dispatch_queue_create("top.felixplus.k.serial", serial_attr);
        // 并行队列
        dispatch_queue_t concurrentQueue = dispatch_queue_create("top.felixplus.k.concurrent", concurrent_attr);
        
        // 烧水
        void (^boiledWater)(void) = ^(void){
            NSLog(@"开始烧水：%@", [NSThread currentThread]);
            sleep(3);
            NSLog(@"水烧好啦");
        };
        
        // 刷牙
        void (^brushTeeth)(void) = ^(void){
            NSLog(@"开始刷牙：%@", [NSThread currentThread]);
            sleep(5);
            NSLog(@"牙刷完啦");
        };
//
//        dispatch_sync(serialQueue, ^{
//            boiledWater();
//            brushTeeth();
//        });
        
//        dispatch_async(dispatch_get_global_queue(0, 0), boiledWater);
//        dispatch_async(dispatch_get_global_queue(0, 0), brushTeeth);
        
//        for (int i = 0; i < 1000; i++) {
//            dispatch_async(dispatch_get_global_queue(0, 0), boiledWater);
//        }
        
//        dispatch_sync(serialQueue, boiledWater);
        
//        dispatch_semaphore_t signal = dispatch_semaphore_create(2);
//
//        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            boiledWater();
//            dispatch_semaphore_signal(signal);
//        });
//
//        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            brushTeeth();
//            dispatch_semaphore_signal(signal);
//        });
//
//        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            boiledWater();
//            dispatch_semaphore_signal(signal);
//        });
//
//        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            brushTeeth();
//            dispatch_semaphore_signal(signal);
//        });
        
//        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
//
//        dispatch_async(concurrentQueue, ^{
//            boiledWater();
//            dispatch_semaphore_signal(signal);
//        });
//
//        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//
//        dispatch_async(concurrentQueue, ^{
//            brushTeeth();
//        });
        
//        dispatch_group_t group = dispatch_group_create();
//
//        dispatch_group_enter(group);
//        dispatch_async(concurrentQueue, ^{
//            boiledWater();
//            dispatch_group_leave(group);
//        });
//
//        dispatch_group_enter(group);
//        dispatch_sync(serialQueue, ^{
//            brushTeeth();
//            dispatch_group_leave(group);
//        });
        
//        dispatch_group_notify(group, concurrentQueue, ^{
//            NSLog(@"All done");
//        });
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//        NSLog(@"All done");
        
//        dispatch_barrier_async(concurrentQueue, boiledWater);
//        dispatch_barrier_async(concurrentQueue, brushTeeth);
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:100001];
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:500];
        for (int i = 0; i < 100000; i++) {
            [list addObject:@(i)];
        }
        
        dispatch_async(concurrentQueue, ^{
            
            dispatch_apply(list.count, concurrentQueue, ^(size_t i) {
                if (i % 17 == 0) {
                    dispatch_sync(serialQueue, ^{
                        [result addObject:list[i]];
                    });
                }
            });
            
            dispatch_sync(serialQueue, ^{
                NSLog(@"%@", result);
            });
        });
        
        
        NSLog(@"Enter (q) to quit\n");
        char input[100];
        while (scanf("%[^\n]%*c", input)) {
            NSString *str = [NSString stringWithCString:input encoding:NSUTF8StringEncoding];
            if ([str isEqualToString:@"q"]) {
                exit(0);
            }
        }
    }
    return 0;
}
