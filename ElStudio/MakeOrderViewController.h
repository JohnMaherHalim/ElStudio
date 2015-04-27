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

-(IBAction)upload ;
-(IBAction)RealUpload:(id)sender;

@end
