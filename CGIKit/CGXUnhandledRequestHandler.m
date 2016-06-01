//
//  CGXUnhandledRequestHandler.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXUnhandledRequestHandler.h"

@implementation CGXUnhandledRequestHandler

- (void)handleContext:(CGIContext *)context
{
    NSURL *localURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"unhandled" withExtension:@"html"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:localURL
                                         options:0
                                           error:&error];
    
    if (data)
    {
        context.response[CGIHTTPHeaderContentType] = localURL.MIMEType;
        context.response.statusCode = CGIHTTPStatusCodeNotImplemented;
        [context.response.outputStream writeData:data withError:NULL];
    }
    else
    {
        [context.response error:error];
    }
    
    [context.response send];
}

@end
