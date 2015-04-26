//
//  MakeOrderViewController.m
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "MakeOrderViewController.h"

@interface MakeOrderViewController ()

@end

@implementation MakeOrderViewController

@synthesize myimg ; 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)upload {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	
	// Don't forget to add UIImagePickerControllerDelegate in your .h
	picker.delegate = self;
	
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	
	[self presentModalViewController:picker animated:YES];
}

-(IBAction)RealUpload:(id)sender {
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	myimg.image = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
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
