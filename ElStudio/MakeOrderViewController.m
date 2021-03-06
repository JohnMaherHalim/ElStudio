//
//  MakeOrderViewController.m
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "MakeOrderViewController.h"
#import "ShowImagesViewController.h"
#import "InstagramKit.h" 
#import "Product.h"
#import "CurrentOrderManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProductsStore.h"

@interface MakeOrderViewController ()

@end

@implementation MakeOrderViewController

@synthesize myimg ; 
@synthesize imgarray ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgarray = [[NSMutableArray alloc]init];
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    NSString *instagramtoken = [defaults objectForKey:@"instatoken"];
    
    
    
    
    if (!instagramtoken)
        [self.InstLogOutBtn setHidden:YES] ;
    else
        [self.InstLogOutBtn setHidden:NO];
    
    if (self.gotoinstagram) {
        [self Instagram:nil];
        self.gotoinstagram = NO ; 
    }
    
    if([FBSDKProfile currentProfile])
        [self.FBAlbumBtn setHidden:NO];
    else
        [self.FBAlbumBtn setHidden:YES] ;
    
    [self CheckAdminFlags];
    
}

-(void)CheckAdminFlags {
    Admin *myAdmin = [[ProductsStore sharedManager]myAdmin];
    
    if (myAdmin.Admin_fbEnabled)
        [self.FBAlbumBtn setHidden:NO];
    else
        [self.FBAlbumBtn setHidden:YES];
    
    if (myAdmin.Admin_instaEnabled) {
        [self.InstagramBtn setHidden:NO];
        [self.InstLogOutBtn setHidden:NO] ;
    } else {
        [self.InstagramBtn setHidden:YES];
        [self.InstLogOutBtn setHidden:YES] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)upload {
	/*UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	
	// Don't forget to add UIImagePickerControllerDelegate in your .h
	picker.delegate = self;
	
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	
	[self presentModalViewController:picker animated:YES];*/
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4
    
    Product *myprod = [[[CurrentOrderManager sharedManager]curOrderItem]product];
    elcPicker.ProductBasicNumber = 2 ;//  [myprod.Product_basicNumber integerValue];
    elcPicker.ProductAddOnNumber = 2 ; // [myprod.Product_addonNumber integerValue];
    
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
    //[self.navigationController pushViewController:elcPicker animated:YES];
    
    // Release if not using ARC
    
}

-(IBAction)RealUpload:(id)sender {
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	myimg.image = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToImages"]) {
        ShowImagesViewController *showimgs = [segue destinationViewController] ;
        [showimgs setImages:imgarray];
    }
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [imgarray removeAllObjects];
   // NSMutableArray *myimgs = [[NSMutableArray alloc]init];
    
    for (NSDictionary *curinfo in info) {
        UIImage *img = (UIImage*) [curinfo objectForKey:UIImagePickerControllerOriginalImage];
        [imgarray addObject:img];
    }
    
    BOOL BasicFlag = [[[CurrentOrderManager sharedManager]curOrderItem]BasicCheck];
    
    if (BasicFlag) {
        [self performSegueWithIdentifier:@"GoToImages"
                                  sender:nil];
    } else {
         Product *myprod = [[[CurrentOrderManager sharedManager]curOrderItem]product];
        NSString *msgtext = [NSString stringWithFormat:@"Choosing this product, you should choose at least %@ photos in order to complete your order",myprod.Product_basicNumber];
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Not enough images" message:msgtext  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
    }
    
    
    
}


-(IBAction)Instagram:(id)sender {
    BOOL LoggedIn = [[NSUserDefaults standardUserDefaults]objectForKey:@"instatoken"] ;
    
    if (!LoggedIn) {
        [self performSegueWithIdentifier:@"InstagramLogin" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"InstagramShow" sender:nil];
    }
}

-(IBAction)InstagramLogOut:(id)sender{
    [[InstagramEngine sharedEngine] logout];
    NSUserDefaults *defaults=  [NSUserDefaults standardUserDefaults] ;
    [defaults setObject:nil forKey:@"instatoken"];
    UIButton *btn = (UIButton*)sender ;
    [btn setHidden:YES] ;
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
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
