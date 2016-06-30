//
//  CGIResponder.h
//  CGIKit
//
//  Created by Maxthon Chan on 6/2/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGIResponder : NSObject

@property (weak, readonly) id firstResponder;
@property (weak) id nextResponder;
@property (assign, readonly) BOOL acceptFirstResponder;

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@end

NS_ASSUME_NONNULL_END
