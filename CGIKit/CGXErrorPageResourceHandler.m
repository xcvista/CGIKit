//
//  CGXErrorPageResourceHandler.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXErrorPageResourceHandler.h"

@implementation CGXErrorPageResourceHandler

- (void)handleContext:(CGIContext *)context
{
    NSString *path = objc_getAssociatedObject(context, @selector(handleContext:));
    if (!path)
    {
        NSRange marker = [context.request.requestURI rangeOfString:CGISpecialPathMarker options:NSBackwardsSearch];
        path = [context.request.requestURI substringFromIndex:NSMaxRange(marker)];
    }
    NSRange questionMark = [path rangeOfString:@"?"];
    if (questionMark.location != NSNotFound)
    {
        path = [path substringToIndex:questionMark.location];
    }
    NSArray *pathComponents = path.pathComponents;
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(1, pathComponents.count - 1)];
    
    NSString *localPath = @"Web";
    for (NSString *component in pathComponents)
        localPath = [localPath stringByAppendingPathComponent:component];
    
    NSURL *localURL = [[NSBundle bundleForClass:[self class]] URLForResource:localPath withExtension:nil];
    
    if (!localURL)
    {
        [context.response error:[NSError errorWithDomain:NSPOSIXErrorDomain code:ENOENT userInfo:nil]];
        return;
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:localURL
                                         options:0
                                           error:&error];
    
    if (data)
    {
        context.response[CGIHTTPHeaderContentType] = localURL.MIMEType;
        [context.response.outputStream writeData:data withError:NULL];
    }
    else
    {
        [context.response error:error];
    }
    
    [context.response send];
}

@end
