//
//  AffineImageViewController.m
//  ElStudio
//
//  Created by John Maher on 4/28/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "AffineImageViewController.h"
#import "UIDeviceHardware.h"
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

-(IBAction)ModifyImage:(id)sender {
    int height = 4 ;
    int width = 4;
    
    UIImage *img = [self ModifyTheImage:myimage inHeightInches:height andWidthInches:width];
    
    self.resultimageheight.constant = img.size.height ;
    self.resultimagewidth.constant = img.size.width ; 
    
    [self.resultimageview setImage:img] ;
    
    
}


-(UIImage*)ModifyTheImage:(UIImage*)firstimg inHeightInches:(int)height andWidthInches:(int)width {
    UIImage *img = [[UIImage alloc]init];
    
    int ppi = 326 ;
    
   UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSString *currentDevice = [h platformString] ;
    
   /* if ([currentDevice isEqualToString:@"iPhone 4S"]) {
        ppi = 326 ;
    } else if ([currentDevice isEqualToString:@"iPhone 5 (GSM)"] || [currentDevice isEqualToString:@"iPhone 5 (GSM+CDMA)"]|| [currentDevice isEqualToString:@"iPhone 5c (GSM)"]|| [currentDevice isEqualToString:@"iPhone 5c (GSM+CDMA)"]|| [currentDevice isEqualToString:@"iPhone 5s (GSM)"]|| [currentDevice isEqualToString:@"iPhone 5s (GSM+CDMA)"]){
        ppi = 326 ;
    } else if ([currentDevice isEqualToString:@"iPhone 6"]) {
        ppi = 326 ;
    } else */
    if ([currentDevice isEqualToString:@"iPhone 6 Plus"]) {
        ppi = 401 ;
    }
    
    int HeightInPixels = height * ppi ;
    int WidthInPixels = width * ppi ;
    
    img = [self imageWithImage:firstimg scaledToSize:CGSizeMake(WidthInPixels, HeightInPixels)];
    
    return img ;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
