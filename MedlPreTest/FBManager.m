//
//  FBManager.m
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import "FBManager.h"
#import "AppDelegate.h"
#import "FBData.h"
#import "SVProgressHUD.h"

@implementation FBManager

- (void)getFriendsList
{
    if (!FBSession.activeSession.isOpen)
    {
        NSLog(@"permissions::%@",FBSession.activeSession.permissions);
        
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error)
                                          {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          }
                                          else if (session.isOpen)
                                          {
                                              [self showWithStatus:@""];
                                              FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=name,picture,gender"];
                                              [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                  NSArray *data = [result objectForKey:@"data"];
                                                  NSMutableArray *friendsList = [[NSMutableArray alloc] init];
                                                  for (FBGraphObject<FBGraphUser> *friend in data)
                                                  {
                                                      //NSLog(@"friend:%@", friend);
                                                      NSDictionary *picture = [friend objectForKey:@"picture"];
                                                      NSDictionary *pictureData = [picture objectForKey:@"data"];
                                                      //NSLog(@"picture:%@", picture);
                                                      FBData *fb = [[FBData alloc]
                                                                    initWithData:(NSString*)[friend objectForKey:@"name"]
                                                                    userID:(NSInteger)[[friend objectForKey:@"id"] integerValue]
                                                                    gender:(NSString*)[friend objectForKey:@"gender"]
                                                                    photoURL:(NSString*)[pictureData objectForKey:@"url"]
                                                                    photo:(UIImage*)nil
                                                                    isPhotoDownloaded:(BOOL)NO];
                                                      [friendsList addObject:fb];
                                                  }
                                                  
                                                  [self dismissStatus];
                                                  [self.delegate downloadComplete:friendsList];
                                              }];
                                          }
                                      }];
        
    }
}

- (void)shareWithFriend:(FBData*)friend message:(NSString*)message
{
    NSLog(@"permissions::%@",FBSession.activeSession.permissions);
    
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
                                       defaultAudience:FBSessionDefaultAudienceFriends
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                         
                                         NSMutableDictionary *params = [NSMutableDictionary  dictionaryWithObjectsAndKeys:message, @"message", nil];
                                         FBRequest *friendRequest = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%i/feed", friend.userID]
                                                                                         parameters:params HTTPMethod:@"POST"];
                                         [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                             //NSArray *data = [result objectForKey:@"data"];
                                             NSLog(@"error:%@", [error description]);
                                         }];
                                         
                                     }];
}

- (void)retrieveImage:(NSString*)urlString withCompletionBlock:(void (^)(BOOL succeeded, UIImage *image))completed
{
    NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error)
                               {
                                   UIImage *downloadedImage = [UIImage imageWithData:data];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIImage *image = downloadedImage;
                                       completed(YES, image);
                                   });
                               }
                               else
                               {
                                   completed(NO, nil);
                               }
                           }];
}

#pragma mark - SVProgressHUD


- (void)showWithStatus:(NSString*)message;
{
    if (self.isSpinning)
        return;
    
    self.isSpinning = YES;
	[SVProgressHUD showWithStatus:message
                         maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)dismissStatus
{
    if (self.isSpinning == NO)
        return;
    
    self.isSpinning = NO;
	[SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
