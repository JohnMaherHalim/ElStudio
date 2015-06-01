//
//  OrderItem.h
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface OrderItem : NSObject

@property (nonatomic,retain) NSString *ProductName ;
@property (nonatomic,retain) Product *product ;
@property BOOL BasicCheck ;
@property NSInteger AddOns ;
@property (nonatomic,retain) NSMutableArray *ProductImages ;
@property (nonatomic,retain) NSMutableArray *ImagesCounts ;
@property (nonatomic,retain) NSMutableArray *ImagesScales ;

-(id)init ;

@end
