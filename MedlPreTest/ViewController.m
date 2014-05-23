//
//  ViewController.m
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "FBManager.h"
#import "FBData.h"
#import "ProfileCell.h"
#import "ReachabilityManager.h"
#import "AppDelegate.h"

NSString * const REUSE_CUSTOMCELL_ID = @"ProfileCell";

@interface ViewController ()

@property (nonatomic, strong) FBManager *fbManager;
@property (nonatomic, strong) ReachabilityManager *reachabilityManager;
@property (nonatomic, strong) UIRefreshControl  *refreshControl;
@property (nonatomic, strong) NSMutableArray *listArray;


@end

@implementation ViewController

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
    
    self.title = @"My Friends";
    
    // set searchBar background to black
    self.searchBar.barTintColor = [UIColor blackColor];
    
    // init
    if (self.listArray == nil)
        self.listArray = [[NSMutableArray alloc] init];
    
    if (self.fbManager == nil)
    {
        self.fbManager = [[FBManager alloc] init];
        self.fbManager.delegate = self;
    }
    if (self.reachabilityManager == nil)
    {
        self.reachabilityManager = [[ReachabilityManager alloc] init];
    }
    
    // for faster and more efficient table loading
    UINib *tableCellNib = [UINib nibWithNibName:REUSE_CUSTOMCELL_ID bundle:[NSBundle bundleForClass:[ProfileCell class]]];
    [self.listTable registerNib:tableCellNib forCellReuseIdentifier:REUSE_CUSTOMCELL_ID];
    
    // add a refresh control for quick table reloading
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downloadData) forControlEvents:UIControlEventValueChanged];
    [self.listTable addSubview:self.refreshControl];
    
    // add logout button and title
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutPressed:)];
    [[self navigationItem] setLeftBarButtonItem:logoutButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // login into facebook
    [self setupLoginView];
}

- (void)setupLoginView
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedIn"] == NO)
    {
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginView.delegate = self;
        loginView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginView animated:YES completion:nil];
    }
    else
        [self downloadData];
}

- (void)downloadData
{
    // stop anything else happening
    [self.searchBar resignFirstResponder];
    [self.refreshControl endRefreshing];
    
    if ([self.reachabilityManager isReachable])
    {
        [self.fbManager getFriendsList];
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

- (NSInteger)getIndexForSearch:(NSString*)userName
{
    __block NSInteger index = 0;
    
    [self.listArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        @autoreleasepool
        {
            FBData *fb = (FBData*)obj;
            if ([[fb.userName uppercaseString] isEqualToString:[userName uppercaseString]])
            {
                index = (NSInteger)idx;
                *stop = YES;
            }
        }
    }];
    
    return index;
}

- (IBAction)logoutPressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.session.isOpen)
    {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // go back to login
        [self setupLoginView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.listTable = nil;
    self.searchBar = nil;
    self.fbManager = nil;
    self.reachabilityManager = nil;
    self.refreshControl = nil;
    self.listArray = nil;
}


#pragma mark = LoginViewDelegate

- (void)userDidLogin:(BOOL)loggedIn
{
    if (loggedIn == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self downloadData];
    }
}

#pragma mark - DownloadCompleteDelegate

- (void)downloadComplete:(NSArray*)friendsList
{
    [self.listArray removeAllObjects];
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"userName" ascending:YES];
    NSArray *sortedArray = [friendsList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortName, nil]];
    if ([sortedArray count] > 0)
    {
        self.listArray = [NSMutableArray arrayWithArray:sortedArray];
        [self.listTable reloadData];
    }
}


#pragma mark - Search Bar and Display

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // find the friend and scroll to the top - todo
    self.searchBar.placeholder = self.searchBar.text;
    NSInteger index = [self getIndexForSearch:self.searchBar.text];
    if (index < [self.listArray count])
    {
        [self.listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CUSTOMCELL_ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCustomCell:(ProfileCell*)cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCustomCell:(ProfileCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBData *data = [self.listArray objectAtIndex:indexPath.row];
    cell.userName.text = data.userName;
    cell.userGender.text = data.gender;
    cell.profileImage.image = [UIImage imageNamed:@"facebook.png"];
    
    // get the image
    if ([data.photoURL length] == 0)
    {
        // nothing found - will use the placeholder image
        data.isPhotoDownloaded = NO;
    }
    else
    {
        if (data.photo == nil)
        {
            // don't have this one yet, need to download
            [self.fbManager retrieveImage:data.photoURL withCompletionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded)
                {
                    // all good, use the downloaded image
                    cell.profileImage.image = image;
                    data.photo = image;
                    data.isPhotoDownloaded = YES;
                }
                else
                {
                    // bad image or download failure
                    data.isPhotoDownloaded = NO;
                }
            }];
        }
        else
        {
            // use the one we already have
            cell.profileImage.image = data.photo;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailView.friendData = [self.listArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailView animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
