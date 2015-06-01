//
//  ProductsTableViewController.h
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductsTableViewController : UITableViewController{
    NSMutableArray *products ;
    Product *globalprod ; 
}

@end
