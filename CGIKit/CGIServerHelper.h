//
//  CGIServerHelper.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/24/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGICommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CGIHTTPStringManipulator)

@property (readonly) NSString *stringByAddingHTMLEscaping;
@property (readonly) NSString *stringByRemovingHTMLEncoding;

@end

@class CGIContext;

@interface CGIServerHelper : NSObject
{
@protected
    __weak CGIContext *_context;
    NSURL *_documentRoot;
    NSOutputStream *_errorStream;
}

@property (weak) CGIContext *context;
@property (readonly) NSURL *documentRoot;
@property (readonly) NSOutputStream *errorStream;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContext:(CGIContext *)context documentRoot:(NSURL *)documentRoot errorStream:(NSOutputStream *)stream NS_DESIGNATED_INITIALIZER;

- (nullable NSURL *)mapPath:(NSString *)virtualPath;

- (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)log:(NSString *)format withArguemnts:(va_list)args NS_FORMAT_FUNCTION(1, 0);

@end

NS_ASSUME_NONNULL_END
