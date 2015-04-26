//
//  MakeOrderViewController.h
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeOrderViewController : UIViewController <UIImagePickerControllerDelegate>

@property (nonatomic) IBOutlet UIImageView *myimg ; 

-(IBAction)upload ;
-(IBAction)RealUpload:(id)sender;

@end
