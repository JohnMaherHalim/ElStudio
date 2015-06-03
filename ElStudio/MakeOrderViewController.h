//
//  MakeOrderViewController.h
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"

@interface MakeOrderViewController : UIViewController <UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>

@property (nonatomic) IBOutlet UIImageView *myimg ;
@property (nonatomic) NSMutableArray *imgarray ;
@property (nonatomic , retain) IBOutlet UIButton *InstLogOutBtn ;
@property (nonatomic , retain) IBOutlet UIButton *FBAlbumBtn ; 
@property BOOL gotoinstagram ; 

-(IBAction)upload ;
-(IBAction)RealUpload:(id)sender;
-(IBAction)Instagram:(id)sender;
-(IBAction)InstagramLogOut:(id)sender;

@end
