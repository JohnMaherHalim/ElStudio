//
//  AffineImageViewController.h
//  ElStudio
//
//  Created by John Maher on 4/28/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface AffineImageViewController : UIViewController 

@property (retain) UIImage *myimage ;
@property (retain) IBOutlet UIImageView *myimageview ;
@property (retain) IBOutlet UIImageView *resultimageview ;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultimageheight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultimagewidth;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;
-(IBAction)scale:(UIPinchGestureRecognizer*)pinch;
-(IBAction)ModifyImage:(id)sender;

@end
