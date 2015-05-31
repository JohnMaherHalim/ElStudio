//
//  MakeOrderViewController.m
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "MakeOrderViewController.h"
#import "ShowImagesViewController.h"


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
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
    
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
    
    [self performSegueWithIdentifier:@"GoToImages"
                              sender:nil];
    
}


-(IBAction)Instagram:(id)sender {
    BOOL LoggedIn = true ;
    
    if (!LoggedIn) {
        [self performSegueWithIdentifier:@"InstagramLogin" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"InstagramShow" sender:nil];
    }
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
