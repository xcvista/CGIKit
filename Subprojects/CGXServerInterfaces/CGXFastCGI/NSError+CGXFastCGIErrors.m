//
//  NSError+CGXFastCGIErrors.m
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/28/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "NSError+CGXFastCGIErrors.h"
#import "CGXFastCGIContext.h"

NSString *const CGXFastCGIErrorDomain = @"CGXFastCGIErrorDomain";

NSError *CGXFastCGIError(int code)
{
    if (code > 0)
    {
        return [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:nil];
    }
    else
    {
        NSBundle *thisBundle = [NSBundle bundleForClass:[CGXFastCGIContext class]];
        NSString *name = nil;
        NSString *value = nil;
        switch (code)
        {
            case FCGX_PARAMS_ERROR:
                name = @"FCGX_PARAMS_ERROR";
                break;
            case FCGX_CALL_SEQ_ERROR:
                name = @"FCGX_CALL_SEQ_ERROR";
                break;
            case FCGX_PROTOCOL_ERROR:
                name = @"FCGX_PROTOCOL_ERROR";
                break;
            case FCGX_UNSUPPORTED_VERSION:
                name = @"FCGX_UNSUPPORTED_VERSION";
                break;
            default:
                name = [NSString stringWithFormat:@"FCGX_ERROR_%d", -code];
                value = [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"FCGX_UNKNOWN_ERROR", nil, thisBundle, @"Unknown FastCGI Error %d", nil), -code];
        }
        return [NSError errorWithDomain:CGXFastCGIErrorDomain
                                   code:code
                               userInfo:@{NSLocalizedDescriptionKey: [thisBundle localizedStringForKey:name
                                                                                                 value:value
                                                                                                 table:nil]}];
    }
    
}
