//
//  CGICommon.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/22/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#ifndef CGICommon_h
#define CGICommon_h

#include <objc/runtime.h>
#include <objc/message.h>

#define OBJC_MSGSEND(ret, ...) ((ret (*)(__VA_ARGS))objc_msgSend)
#define OBJC_MSGSEND_FPRET(ret, ...) ((ret (*)(__VA_ARGS))objc_msgSend_fpret)
#define OBJC_MSGSEND_FPRET2(ret, ...) ((ret (*)(__VA_ARGS))objc_msgSend_fpret2)
#define OBJC_MSGSEND_STRET(ret, ...) ((ret (*)(__VA_ARGS))objc_msgSend_stret)

#define POINTER_ASSIGN(ptr, val) do { typeof(ptr) _ptr = (ptr); if (_ptr) *_ptr = (val); } while (0)

#if __OBJC__
#import <Foundation/Foundation.h>
#else
#include <CoreFoundation/CoreFoundation.h>
#endif

#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#endif

#endif /* CGICommon_h */
