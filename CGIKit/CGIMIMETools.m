//
//  NSURL+CGIMIMETools.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIMIMETools.h"

#import "CGIListener.h"

#import <pthread.h>

NSDictionary<NSString *, NSString *> *_CGXMIMEDictionaryData;
pthread_once_t _CGXMIMEDictionaryToken = PTHREAD_ONCE_INIT;

void _CGXMIMEDictionaryInit(void)
{
    NSURL *databaseURL = [[NSBundle bundleForClass:[CGIListener class]] URLForResource:@"mime" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:databaseURL];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:NULL];
    NSArray<NSString *> *keys = dict.allKeys;
    for (NSString *key in keys)
    {
        NSString *value = dict[key];
        if (!dict[value])
            dict[value] = key;
    }
    
    _CGXMIMEDictionaryData = dict;
}

NSDictionary<NSString *, NSString *> *_CGXMIMEDictionary(void)
{
    pthread_once(&_CGXMIMEDictionaryToken, _CGXMIMEDictionaryInit);
    return _CGXMIMEDictionaryData;
}

NSString *CGIMIMETypeForFileExtension(NSString *extension)
{
    if (![extension hasPrefix:@"."])
        extension = [@"." stringByAppendingString:extension];
    
    return _CGXMIMEDictionary()[extension] ?: @"application/octet-stream";
}

NSString *_Nullable CGIFileExtensionForMIMEType(NSString *MIME)
{
    if ([MIME hasPrefix:@"."])
        return nil;
    
    return _CGXMIMEDictionary()[MIME];
}

@implementation NSURL (CGIMIMETools)

- (NSString *)MIMEType
{
    return CGIMIMETypeForFileExtension(self.pathExtension);
}

@end

@implementation NSString (CGIMIMETools)

- (NSString *)MIMEType
{
    return CGIMIMETypeForFileExtension(self.pathExtension);
}

@end
