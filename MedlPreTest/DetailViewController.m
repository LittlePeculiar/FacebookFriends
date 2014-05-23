//
//  DetailViewController.m
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import "DetailViewController.h"
#import "FBManager.h"
#import <FacebookSDK/FacebookSDK.h>


@interface DetailViewController ()
@property (nonatomic, strong) FBManager *fbManager;
@end

@implementation DetailViewController

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
    
    self.title = @"Share";
    
    // init
    if (self.fbManager == nil)
    {
        self.fbManager = [[FBManager alloc] init];
    }
    
    // setup the view
    [self getImage];
    self.profileName.text = self.friendData.userName;
    self.commentsField.text = @"";
}

- (IBAction)sharePressed:(id)sender
{
    if ([self.commentsField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Please add a comment to post"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        [self.commentsField resignFirstResponder];
        [self.fbManager shareWithFriend:self.friendData message:self.commentsField.text];
        
    }
}

- (void)getImage
{
    // want normal size
    NSString *urlStr = [NSString stringWithFormat:@"https://graph.facebook.com/%i/picture?type=normal", self.friendData.userID];
    [self.fbManager retrieveImage:urlStr withCompletionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded && image != nil)
        {
            // all good, use the downloaded image
            self.profilePhoto.image = image;
        }
        else
        {
            // bad image or download failure
            self.profilePhoto.image = [UIImage imageNamed:@"facebook.png"];
        }
    }];
}

- (void)commentPosted:(BOOL)success
{
    if (success)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Status updated successfully"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error updating status"
                              message:nil
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // dismiss the keyboard - need delay to make it work here
    [self.commentsField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.01];
    [self.commentsField setClearButtonMode:UITextFieldViewModeAlways];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // dismiss the keyboard - need delay to make it work here
    [self.commentsField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.01];
    [self.commentsField setText:@""];
    
    return YES;
}

@end
