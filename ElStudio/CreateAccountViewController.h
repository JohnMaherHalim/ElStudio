//
//  CreateAccountViewController.h
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController

@property (nonatomic,retain) IBOutlet UITextField *UserName ;
@property (nonatomic,retain) IBOutlet UITextField *Email ;
@property (nonatomic,retain) IBOutlet UITextField *Password ;
@property (nonatomic,retain) IBOutlet UITextField *ConfirmPassword ;
@property (nonatomic,retain) IBOutlet UITextField *Address ;
@property (nonatomic,retain) IBOutlet UITextField *PhoneNumber ;

-(IBAction)CreateAccount:(id)sender;

@end
