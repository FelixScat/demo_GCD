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
