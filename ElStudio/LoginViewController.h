//
//  LoginViewController.h
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField* UserName ;
@property (nonatomic,retain) IBOutlet UITextField *Password ;

-(IBAction)Login:(id)sender;

@end
