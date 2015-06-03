//
//  SubProductsTableViewController.h
//  ElStudio
//
//  Created by John Maher on 6/3/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface SubProductsTableViewController : UITableViewController{
    //NSMutableArray *products ;
    Product *globalprod ;
}

@property (nonatomic,retain) NSMutableArray *products;

@end
