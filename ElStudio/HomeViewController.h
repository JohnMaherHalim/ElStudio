//
//  HomeViewController.h
//  ElStudio
//
//  Created by John Maher on 5/13/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property BOOL jumpflag ;
@property BOOL Productflag ;

@property (nonatomic, retain) IBOutlet UIButton *LogIn ;
@property (nonatomic ,retain) IBOutlet UIButton *LogOut ; 

-(IBAction)GoToCart:(id)sender;
-(IBAction)LogOut:(id)sender;

@end
