//
//  ViewController.h
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "FBManager.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoginDelegate, DownloadCompleteDelegate>

@property (nonatomic, weak) IBOutlet UITableView *listTable;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (IBAction)logoutPressed:(id)sender;

@end
