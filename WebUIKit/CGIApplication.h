//
//  CGIApplication.h
//  CGIKit
//
//  Created by Maxthon Chan on 6/2/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <WebUIKit/CGIResponder.h>

NS_ASSUME_NONNULL_BEGIN

@class CGIApplication;

@protocol CGIApplicationDelegate <NSObject>

- (void)application:(CGIApplication *)application didFinishLaunchingWithListener:(CGIListener *)listener;

@end

@interface CGIApplication : CGIResponder <CGIListenerDelegate>

+ (instancetype)sharedApplication;

@property CGIListener *listener;

@end

NS_ASSUME_NONNULL_END
