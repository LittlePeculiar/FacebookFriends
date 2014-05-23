//
//  LoginViewController.h
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol LoginDelegate <NSObject>
- (void)userDidLogin:(BOOL)loggedIn;
@end


@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;


// Outlet for FBLogin button
- (IBAction)loginPressed:(id)sender;


@end
