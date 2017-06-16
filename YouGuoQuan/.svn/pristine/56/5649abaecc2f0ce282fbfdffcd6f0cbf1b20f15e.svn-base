//
//  UISearchBar+LeftPlaceholder.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/30.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UISearchBar+LeftPlaceholder.h"

@implementation UISearchBar (LeftPlaceholder)
- (void)changeLeftPlaceholder:(NSString *)placeholder {
    self.placeholder = placeholder;
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}
@end
