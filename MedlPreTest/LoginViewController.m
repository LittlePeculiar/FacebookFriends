//
//  LoginViewController.m
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ReachabilityManager.h"


@interface LoginViewController ()
@property (nonatomic, strong) ReachabilityManager *reachabilityManager;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageLabel.text = @"Log in to Facebook to access your friends list";
    
    if (self.reachabilityManager == nil)
    {
        self.reachabilityManager = [[ReachabilityManager alloc] init];
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.session.isOpen)
    {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                
            }];
        }
    }
}

- (IBAction)loginPressed:(id)sender
{
    if ([self.reachabilityManager isReachable])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            if (status == FBSessionStateOpen)
                [self.delegate userDidLogin:YES];
            else
            {
                self.messageLabel.text = @"Unable to Login. Please check your username and password and try again";
                [self.delegate userDidLogin:NO];
            }
            
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Network Connectivity"
                              message:@"Your device is not connected to a network. Please check your settings and try again"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
