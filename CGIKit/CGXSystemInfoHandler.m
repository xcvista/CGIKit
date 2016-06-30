//
//  CGXSystemInfoHandler.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/6/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXSystemInfoHandler.h"

@implementation CGXSystemInfoHandler

- (void)handleContext:(CGIContext *)context
{
    NSURL *localURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"sysinfo" withExtension:@"html"];
    NSMutableString *string = [NSMutableString stringWithContentsOfURL:localURL
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
    
    [string applyTemplate:@{
                            @"%%LISTENER%%": context.listener.listenerType,
                            @"%%LISTENERCLASS%%": NSStringFromClass(context.listener.class) ?: @"<tr><td colspan=\"2\"><i>empty</i></td></tr>",
                            @"%%ENVIRONMENT%%": [NSProcessInfo processInfo].environment.descriptionInInnerHTML,
                            @"%%HTTPENVP%%": context.request.environment.descriptionInInnerHTML ?: @"<tr><td colspan=\"2\"><i>empty</i></td></tr>",
                            @"%%HEADERS%%": context.request.headers.descriptionInInnerHTML ?: @"<tr><td colspan=\"2\"><i>empty</i></td></tr>",
                            @"%%QUERY%%": context.request.queryString.descriptionInInnerHTML ?: @"<tr><td colspan=\"2\"><i>empty</i></td></tr>",
                            @"%%FORM%%": context.request.form.descriptionInInnerHTML ?: @"<tr><td colspan=\"2\"><i>empty</i></td></tr>",
                            @"%%COOKIES%%": context.request.cookies.descriptionInInnerHTML ?: @"<tr><td colspan=\"2\"><i>empty</i></td></tr>"
                            }];
    
    if (string)
    {
        context.response[CGIHTTPHeaderContentType] = localURL.MIMEType;
        [context.response.outputStream writeString:string usingEncoding:NSUTF8StringEncoding withError:NULL];
    }
    
    [context.response send];
}

@end
