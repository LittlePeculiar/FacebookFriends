//
//  ReachabilityManager.h
//  LAFitness
//
//  Created by Gina Mullins on 9/24/13.
//  Copyright (c) 2013 Fitness International LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

+ (ReachabilityManager *)sharedManager;
- (BOOL)isReachable;
- (BOOL)isUnreachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;


@end
