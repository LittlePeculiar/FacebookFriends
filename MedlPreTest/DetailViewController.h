//
//  DetailViewController.h
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBData.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) FBData *friendData;

@property (nonatomic, weak) IBOutlet UIImageView *profilePhoto;
@property (nonatomic, weak) IBOutlet UILabel *profileName;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UITextField *commentsField;

- (IBAction)sharePressed:(id)sender;


@end
