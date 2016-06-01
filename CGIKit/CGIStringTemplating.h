//
//  NSString+CGIStringTemplating.h
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CGIStringTemplating)

- (NSString *)stringByApplyingTemplate:(NSDictionary<NSString *, NSString *> *)template;

@end

@interface NSMutableString (CGIStringTemplating)

- (void)applyTemplate:(NSDictionary<NSString *, NSString *> *)template;

@end
