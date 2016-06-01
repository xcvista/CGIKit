//
//  NSURL+CGIMIMETools.h
//  CGIKit
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSString *CGIMIMETypeForFileExtension(NSString *extension);
NSString *_Nullable CGIFileExtensionForMIMEType(NSString *MIME);

@interface NSString (CGIMIMETools)

@property (readonly) NSString *MIMEType;

@end

@interface NSURL (CGIMIMETools)

@property (readonly) NSString *MIMEType;

@end

NS_ASSUME_NONNULL_END
