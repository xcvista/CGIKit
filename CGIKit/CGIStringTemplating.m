//
//  NSString+CGIStringTemplating.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIStringTemplating.h"

@implementation NSString (CGIStringTemplating)

- (NSString *)stringByApplyingTemplate:(NSDictionary<NSString *,NSString *> *)template
{
    NSMutableString *mutable = self.mutableCopy;
    [mutable applyTemplate:template];
    return mutable;
}

@end

@implementation NSMutableString (CGIStringTemplating)

- (void)applyTemplate:(NSDictionary<NSString *,NSString *> *)template
{
    for (NSString *key in template)
    {
        NSString *value = template[key];
        [self replaceOccurrencesOfString:key withString:value options:0 range:NSMakeRange(0, self.length)];
    }
}

@end
