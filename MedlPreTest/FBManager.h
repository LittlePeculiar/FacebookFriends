//
//  FBManager.h
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBData.h"

@protocol DownloadCompleteDelegate <NSObject>
- (void)downloadComplete:(NSArray*)friendsList;
@end


@interface FBManager : NSObject

@property (nonatomic, weak) id<DownloadCompleteDelegate>delegate;
@property (nonatomic, readwrite) BOOL isSpinning;

- (void)getFriendsList;
- (void)shareWithFriend:(FBData*)friend message:(NSString*)message;
- (void)retrieveImage:(NSString*)urlString withCompletionBlock:(void (^)(BOOL succeeded, UIImage *image))completed;


@end
