//
//  NSError+CGXFastCGIErrors.h
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/28/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fastcgi/fcgiapp.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const CGXFastCGIErrorDomain;

FOUNDATION_EXPORT NSError *CGXFastCGIError(int code);

NS_ASSUME_NONNULL_END