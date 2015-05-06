//
//  AffineImageViewController.m
//  ElStudio
//
//  Created by John Maher on 4/28/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "AffineImageViewController.h"
//#import "BRRequestUpload.h"

@interface AffineImageViewController ()

@end

@implementation AffineImageViewController

@synthesize myimage, myimageview ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [myimageview setImage:myimage];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

-(IBAction)scale:(UIPinchGestureRecognizer*)pinch
{
 	float scale = pinch.scale;
 	myimageview.transform = CGAffineTransformScale(myimageview.transform, scale, scale);
 	pinch.scale = 1;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
