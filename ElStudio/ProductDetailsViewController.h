//
//  ProductDetailsViewController.h
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductDetailsViewController : UIViewController

@property (nonatomic ,retain) Product *myproduct ;
@property (nonatomic , retain) IBOutlet UILabel *BasicNumber ;
@property (nonatomic , retain) IBOutlet UILabel *BasicPrice ;
@property (nonatomic , retain) IBOutlet UILabel *AddOnNumber ;
@property (nonatomic , retain) IBOutlet UILabel *AddOnPrice ;
@property (nonatomic , retain) IBOutlet UILabel *Resolution ; 

@end
