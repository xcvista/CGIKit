//
//  CGXExceptionHandler.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXExceptionHandler.h"

@implementation CGXExceptionHandler

- (void)handleContext:(CGIContext *)context
{
    NSURL *localURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"exception" withExtension:@"html"];
    NSError *error = nil;
    NSMutableString *string = [NSMutableString stringWithContentsOfURL:localURL
                                                              encoding:NSUTF8StringEncoding
                                                                 error:&error];
    
    NSException *exception = objc_getAssociatedObject(context, (__bridge const void *)([NSException class]));
    [string applyTemplate:@{
                            @"%%EXCEPTION%%": exception.name.stringByAddingHTMLEscaping,
                            @"%%DESCRIPTION%%": exception.reason.stringByAddingHTMLEscaping
                            }];
    
    if (string)
    {
        context.response[CGIHTTPHeaderContentType] = localURL.MIMEType;
        context.response.statusCode = CGIHTTPStatusCodeInternalServerError;
        [context.response.outputStream writeString:string usingEncoding:NSUTF8StringEncoding withError:NULL];
    }
    else
    {
        [context.response error:error];
    }
    
    [context.response send];
}

@end
