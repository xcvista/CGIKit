//
//  CGXErrorHandler.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXErrorHandler.h"

@implementation CGXErrorHandler

- (void)handleContext:(CGIContext *)context
{
    NSURL *localURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"error" withExtension:@"html"];
    NSMutableString *string = [NSMutableString stringWithContentsOfURL:localURL
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
    
    NSError *error = objc_getAssociatedObject(context, (__bridge const void *)([NSError class]));
    context.response.statusCode = CGIHTTPStatusCodeInternalServerError;
    if ([error.domain isEqualToString:NSPOSIXErrorDomain])
    {
        switch (error.code)
        {
            case EACCES:
            case EPERM:
                context.response.statusCode = CGIHTTPStatusCodeForbidden;
                break;
                
            case ENODEV:
            case ENOENT:
                context.response.statusCode = CGIHTTPStatusCodeNotFound;
        }
    }
    
    NSMutableString *userInfo = [NSMutableString string];
    for (NSString *key in error.userInfo)
    {
        id value = error.userInfo[key];
        [userInfo appendFormat:@"<tr><th>%@</th><td><pre>%@</pre></td></tr>", key.description.stringByAddingHTMLEscaping, [value description].stringByAddingHTMLEscaping];
    }
    
    [string applyTemplate:@{
                            @"%%DOMAIN%%": error.domain.stringByAddingHTMLEscaping,
                            @"%%CODE%%": [NSString stringWithFormat:@"%lu", error.code],
                            @"%%STATUS%%": [NSString stringWithFormat:@"%lu · %@", context.response.statusCode, context.response.statusLine.stringByAddingHTMLEscaping],
                            @"%%DESCRIPTION%%": error.localizedDescription.stringByAddingHTMLEscaping,
                            @"%%USERINFO%%": userInfo.length ? [NSString stringWithFormat:@"<h2>Additional Information</h2>\n<table>%@</table>", userInfo] : @""
                            }];
    
    if (string)
    {
        context.response[CGIHTTPHeaderContentType] = localURL.MIMEType;
        [context.response.outputStream writeString:string usingEncoding:NSUTF8StringEncoding withError:NULL];
    }
    
    [context.response send];
}

@end
