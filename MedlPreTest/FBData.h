//
//  FBData.h
//  MedlPreTest
//
//  Created by Gina Mullins on 4/21/14.
//  Copyright (c) 2014 Gina Mullins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBData : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, readwrite) BOOL isPhotoDownloaded;

- (id)initWithData:(NSString*)userName
            userID:(NSInteger)userID
            gender:(NSString*)gender
          photoURL:(NSString*)photoURL
             photo:(UIImage*)photo
 isPhotoDownloaded:(BOOL)isPhotoDownloaded;

@end
