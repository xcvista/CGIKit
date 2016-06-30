//
//  CGIListener.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/23/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIListener.h"

#import "CGXErrorPageResourceHandler.h"
#import "CGXUnhandledRequestHandler.h"
#import "CGXExceptionHandler.h"

NSString *const CGIFastCGIServerProtocol = @"CGIFastCGIServerProtocol";
NSString *const CGIHypertexrtServerProtocol = @"CGIHypertexrtServerProtocol";
NSString *const CGIApacheModuleServerProtocol = @"CGIApacheModuleServerProtocol";

NSString *const CGIDefaultListenerTypeKey = @"CGIDefaultListenerTypeKey";
NSString *const CGIDefaultListenerAddressKey = @"CGIDefaultListenerAddressKey";

NSString *const _CGXListenerThreadName = @"info.maxchan.CGIKit.listener";

NSString *const CGISpecialPathMarker = @"/.CGIKit/";

static NSMutableDictionary<NSString *, NSBundle *> *_CGXLoadedPlugins;

@implementation CGIContext (CGIListenerSetter)

- (void)setListener:(CGIListener *)listener
{
    _listener = listener;
}

@end

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

- (NSString *)listenerType
{
    return [[self class] listenerType];
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

NSMutableDictionary<NSString *, id<CGIContextHandler>> *_CGXSpecialPathHandlers;

+ (void)addHandler:(id<CGIContextHandler>)handler forSpecialPath:(NSString *)path
{
    if (!_CGXSpecialPathHandlers)
    {
        @synchronized (self)
        {
            if (!_CGXSpecialPathHandlers)
            {
                _CGXSpecialPathHandlers = [NSMutableDictionary dictionary];
            }
        }
    }
    
    _CGXSpecialPathHandlers[path] = handler;
}

+ (id<CGIContextHandler>)handlerForSpecialPath:(NSString *)path
{
    return _CGXSpecialPathHandlers[path];
}

+ (void)removeHandlerForSpecialPath:(NSString *)path
{
    [_CGXSpecialPathHandlers removeObjectForKey:path];
}

CGXExceptionHandler *_CGXExceptionHandler;

+ (void)initialize
{
    if (self == [CGIListener class])
    {
        [self addHandler:[[CGXUnhandledRequestHandler alloc] init] forSpecialPath:CGISpecialPathMarker];
        [self addHandler:[[CGXErrorPageResourceHandler alloc] init] forSpecialPath:@"CGIKit"];
        _CGXExceptionHandler = [[CGXExceptionHandler alloc] init];
    }
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
    
    context.listener = self;
    
    if ([self.delegate respondsToSelector:@selector(listener:didAcceptContext:)])
        [self.delegate listener:self didAcceptContext:context];
    
    NSRange marker = [context.request.requestURI rangeOfString:CGISpecialPathMarker options:NSBackwardsSearch];
    id<CGIContextHandler> handler = nil;
    
    if (marker.location != NSNotFound)
    {
        NSString *path = [context.request.requestURI substringFromIndex:NSMaxRange(marker)];
        NSString *directory = path.pathComponents.firstObject;
        handler = [[self class] handlerForSpecialPath:directory];
        if (handler)
            objc_setAssociatedObject(context, @selector(handleContext:), path, OBJC_ASSOCIATION_RETAIN);
        else
            marker.location = NSNotFound;
    }
    if (marker.location == NSNotFound)
        handler = [self handlerForContext:context];
    if (!handler)
        handler = self;
    
    NSThread *targetThread = ([handler respondsToSelector:@selector(threadForContext:)]) ? [handler threadForContext:context] : [self threadForContext:context];
    NSDictionary *info = @{@"handler": handler, @"context": context};
    if (targetThread)
        [self performSelector:@selector(_handleContext:)
                     onThread:targetThread
                   withObject:info
                waitUntilDone:NO];
    else
        [self performSelectorInBackground:@selector(_handleContext:)
                               withObject:info];
}

- (void)_handleContext:(NSDictionary *)info
{
    @autoreleasepool
    {
        id<CGIContextHandler> handler = info[@"handler"];
        CGIContext *context = info[@"context"];
        
        @try
        {
            [handler handleContext:context];
        }
        @catch (NSException *exception)
        {
            objc_setAssociatedObject(context, (__bridge const void *)([NSException class]), exception, OBJC_ASSOCIATION_RETAIN);
            [_CGXExceptionHandler handleContext:context];
        }
        @finally
        {
            [context.response send];
        }
    }
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

@implementation CGIListener (CGIListenerDelegate)

- (id<CGIContextHandler>)handlerForContext:(CGIContext *)context
{
    if ([self.delegate respondsToSelector:@selector(listener:handlerForContext:)])
        return [self.delegate listener:self handlerForContext:context];
    else
        return nil;
}

- (void)handleContext:(CGIContext *)context
{
    if ([self.delegate respondsToSelector:@selector(listener:handleContext:)])
        [self.delegate listener:self handleContext:context];
    else
    {
        id<CGIContextHandler> handler = [[self class] handlerForSpecialPath:CGISpecialPathMarker];
        [handler handleContext:context];
    }
}

- (NSThread *)threadForContext:(CGIContext *)context
{
    if ([self.delegate respondsToSelector:@selector(listener:threadForContext:)])
        return [self.delegate listener:self threadForContext:context];
    return nil;
}

@end
