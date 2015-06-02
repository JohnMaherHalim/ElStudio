//
//  FaceBookAlbumsTableViewController.h
//  ElStudio
//
//  Created by John Maher on 6/2/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBookAlbum.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FaceBookAlbumsTableViewController : UITableViewController {
    NSString *globalAlbum; 
}

@property (nonatomic,retain) NSMutableArray *Albums ; 

@end
