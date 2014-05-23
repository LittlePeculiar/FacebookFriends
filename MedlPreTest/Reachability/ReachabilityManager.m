//
//  ReachabilityManager.m
//  LAFitness
//
//  Created by Gina Mullins on 9/24/13.
//  Copyright (c) 2013 Fitness International LLC. All rights reserved.
//


#import "ReachabilityManager.h"
#import "Reachability.h"


@interface ReachabilityManager ()

@end


@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager
{
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

- (void)dealloc
{
    // Stop Notifier
    if (_reachability)
    {
        [_reachability stopNotifier];
    }
}

- (BOOL)isReachable
{
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}

- (BOOL)isUnreachable
{
    return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}

- (BOOL)isReachableViaWWAN
{
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

- (BOOL)isReachableViaWiFi
{
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}



@end
