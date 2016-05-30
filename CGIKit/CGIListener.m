//
//  CGIListener.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/23/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIListener.h"

NSString *const CGIFastCGIServerProtocol = @"CGIFastCGIServerProtocol";
NSString *const CGIHypertexrtServerProtocol = @"CGIHypertexrtServerProtocol";
NSString *const CGIApacheModuleServerProtocol = @"CGIApacheModuleServerProtocol";

NSString *const CGIDefaultListenerTypeKey = @"CGIDefaultListenerTypeKey";
NSString *const CGIDefaultListenerAddressKey = @"CGIDefaultListenerAddressKey";

NSString *const _CGXListenerThreadName = @"info.maxchan.CGIKit.listener";

static NSMutableDictionary<NSString *, NSBundle *> *_CGXLoadedPlugins;

@implementation CGIListener
{
@private
    NSLock *_syncLock;
    CGIContext *_syncContext;
    NSError *_syncError;
    
    NSThread *_asyncThread;
}

+ (void)scanForPluginsInDirectoryWithURL:(NSURL *)url
{
    if (!url)
        return;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray<NSURL *> *plugins = [fm contentsOfDirectoryAtURL:url.URLByResolvingSymlinksInPath
                                  includingPropertiesForKeys:nil
                                                     options:0
                                                       error:&error];
    if (!plugins)
    {
        NSLog(@"Error loading plugin list: %@", error);
        return;
    }
    
    if (!_CGXLoadedPlugins)
    {
        _CGXLoadedPlugins = [NSMutableDictionary dictionaryWithCapacity:plugins.count];
    }
    
    for (NSURL *url in plugins)
    {
        if (![url.pathExtension.lowercaseString isEqualToString:@"plugin"])
            continue;
        NSBundle *plugin = [NSBundle bundleWithURL:url];
        if ([plugin load])
        {
            Class rootClass = plugin.principalClass;
            NSString *listenerType = rootClass && [rootClass isSubclassOfClass:[CGIListener class]] && [rootClass respondsToSelector:@selector(listenerType)] ? [rootClass listenerType] : nil;
            if (listenerType)
            {
                NSLog(@"Successfully loaded plugin %@ at %@ with listener type %@", plugin.bundleIdentifier, plugin.bundlePath, listenerType);
                _CGXLoadedPlugins[listenerType] = plugin;
            }
            else
            {
                NSLog(@"Rejected unknown plugin %@ at %@.", plugin.bundleIdentifier, plugin.bundlePath);
            }
        }
        else
            NSLog(@"Failed to load plugin %@ at %@", plugin.bundleIdentifier, plugin.bundlePath);
    }
}

+ (NSString *)listenerType
{
    return nil;
}

+ (void)load
{
    // Load plugins packaged with the framework
    NSBundle *thisBundle = [NSBundle bundleForClass:[CGIListener class]];
    NSURL *pluginsURL = thisBundle.builtInPlugInsURL;
    [self scanForPluginsInDirectoryWithURL:pluginsURL];
    
    // Load plugins packaged with the application
    pluginsURL = [NSBundle mainBundle].builtInPlugInsURL;
    [self scanForPluginsInDirectoryWithURL:pluginsURL];
    
    // Load plugins installed in system plugin directory
    pluginsURL = [[[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                         inDomain:NSLocalDomainMask
                                                appropriateForURL:nil
                                                           create:NO
                                                            error:nil] URLByAppendingPathComponent:@"CGIKit/Plugins"];
    [self scanForPluginsInDirectoryWithURL:pluginsURL];
    
    // Load plugins installed in user plugin directory
    pluginsURL = [[[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                         inDomain:NSUserDomainMask
                                                appropriateForURL:nil
                                                           create:NO
                                                            error:nil] URLByAppendingPathComponent:@"CGIKit/Plugins"];
    [self scanForPluginsInDirectoryWithURL:pluginsURL];
}

+ (instancetype)listenerWithType:(NSString *)type listeningAddress:(NSString *)address
{
    return [[self alloc] initWithType:type listeningAddress:address];
}

+ (instancetype)listenerWithType:(NSString *)type
{
    return [self listenerWithType:type listeningAddress:[NSBundle mainBundle].infoDictionary[CGIDefaultListenerAddressKey]];
}

+ (instancetype)listenerWithAddress:(NSString *)address
{
    NSString *type = [NSBundle mainBundle].infoDictionary[CGIDefaultListenerTypeKey] ?: CGIFastCGIServerProtocol;
    return [self listenerWithType:type listeningAddress:address];
}

+ (instancetype)listener
{
    return [self listenerWithAddress:[NSBundle mainBundle].infoDictionary[CGIDefaultListenerAddressKey]];
}

- (instancetype)init
{
    return [self initWithAddress:[NSBundle mainBundle].infoDictionary[CGIDefaultListenerAddressKey]];
}

- (instancetype)initWithAddress:(NSString *)address
{
    if (_CGXLoadedPlugins[CGIApacheModuleServerProtocol])
    {
        NSBundle *typeBundle = _CGXLoadedPlugins[CGIApacheModuleServerProtocol];
        Class rootClass = typeBundle.principalClass;
        self = [[rootClass alloc] init];
    }
    else if ([self isMemberOfClass:[CGIListener class]])
    {
        return self = nil;
    }
    else if (self = [super init])
    {
        ;
    }
    return self;
}

- (instancetype)initWithType:(NSString *)type listeningAddress:(NSString *)address
{
    self = [self initWithAddress:address]; // Replaces self.
    
    if (self || !type)
        return self;
    NSBundle *typeBundle = _CGXLoadedPlugins[type];
    Class rootClass = typeBundle.principalClass;
    return self = [[rootClass alloc] initWithAddress:address];
}

- (instancetype)initWithType:(NSString *)type
{
    return [self initWithType:type listeningAddress:[NSBundle mainBundle].infoDictionary[CGIDefaultListenerAddressKey]];
}

#pragma mark - Asynchronous accepting of contexts

- (void)beginAcceptingContext
{
    _asyncThread = [[NSThread alloc] initWithTarget:self
                                           selector:@selector(_asyncAcceptContext)
                                             object:NULL];
    _asyncThread.name = _CGXListenerThreadName;
    [_asyncThread start];
}

- (void)endAcceptingContext
{
    [_asyncThread cancel];
}

- (void)_asyncAcceptContext
{
    @autoreleasepool
    {
        while (![NSThread currentThread].cancelled)
        {
            NSError *error = nil;
            CGIContext *ctx = [self acceptContextWithError:&error];
            if (ctx)
                [self didAcceptContext:ctx];
            else
                [self didEncounterError:error];
        }
    }
}

- (BOOL)isRunning
{
    return _asyncThread.executing;
}

#pragma mark - Synchronous accepting of contexts

- (CGIContext *)acceptContextWithError:(NSError * _Nullable __autoreleasing *)error
{
    if (!_syncLock)
    {
        @synchronized (self)
        {
            if (!_syncLock)
            {
                _syncLock = [[NSLock alloc] init];
            }
        }
    }
    [_syncLock lock];
    [self beginAcceptingContext];
    
    // Locking again: wait for it to finish.
    [_syncLock lock];
    if (error && _syncError)
        *error = _syncError;
    CGIContext *context = _syncContext;
    [self endAcceptingContext];
    [_syncLock unlock];
    
    return context;
}

- (void)didAcceptContext:(CGIContext *)context
{
    if (![[NSThread currentThread] isEqual:[NSThread mainThread]])
    {
        [self performSelectorOnMainThread:_cmd
                               withObject:context
                            waitUntilDone:NO];
        return;
    }
    
    if (_syncLock)
    {
        _syncError = nil;
        _syncContext = context;
        [_syncLock unlock];
    }
    
    if ([self.delegate respondsToSelector:@selector(listener:didAcceptContext:)])
        [self.delegate listener:self didAcceptContext:context];
}

- (void)didEncounterError:(NSError *)error
{
    if (![[NSThread currentThread] isEqual:[NSThread mainThread]])
    {
        [self performSelectorOnMainThread:_cmd
                               withObject:error
                            waitUntilDone:NO];
        return;
    }
    
    if (_syncLock)
    {
        _syncError = error;
        _syncContext = nil;
        [_syncLock unlock];
    }
    
    if ([self.delegate respondsToSelector:@selector(listener:didEncounterError:)])
        [self.delegate listener:self didEncounterError:error];
}

@end
