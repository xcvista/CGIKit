//
//  CGXFastCGIResponse.h
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGIKit.h>

#import "fastcgi/fcgiapp.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGXFastCGIResponse : CGIResponse

- (instancetype)initWithContext:(CGIContext *)context outputStream:(NSOutputStream *)outputStream NS_UNAVAILABLE;
- (instancetype)initWithContext:(CGIContext *)context FCGXStream:(FCGX_Stream *)stream NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
