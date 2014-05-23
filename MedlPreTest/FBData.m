//
//  FBData.m
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import "FBData.h"

@implementation FBData

- (id)initWithData:(NSString*)userName
            userID:(NSInteger)userID
            gender:(NSString*)gender
          photoURL:(NSString*)photoURL
             photo:(UIImage*)photo
 isPhotoDownloaded:(BOOL)isPhotoDownloaded
{
    if ((self = [super init]))
    {
        self.userName = userName;
        self.userID = userID;
        self.gender = gender;
        self.photoURL = photoURL;
        self.photo = photo;
        self.isPhotoDownloaded = isPhotoDownloaded;
    }
    return self;
}

- (void)dealloc
{
    self.userName = nil;
    self.gender = nil;
    self.photoURL = nil;
    self.photo = nil;
}

@end
