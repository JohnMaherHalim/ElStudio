//
//  Product.h
//  ElStudio
//
//  Created by John Maher on 5/31/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject<NSCoding>

@property (nonatomic,retain) NSNumber * Product_id ;
@property (nonatomic,retain) NSString *Product_name ;
@property (nonatomic,retain) NSString *Product_description ;
@property (nonatomic,retain) NSNumber * Product_ParentId ;
@property (nonatomic,retain) NSNumber *Product_basicNumber ;
@property (nonatomic,retain) NSNumber *Product_basicPrice ;
@property (nonatomic,retain) NSNumber *Product_addonNumber ;
@property (nonatomic,retain) NSNumber *Product_addonPrice ;
@property (nonatomic,retain) NSNumber *Product_imagewidth ;
@property (nonatomic,retain) NSNumber *Product_imageheight ;
@property (nonatomic,retain) NSMutableArray *Product_SubProducts ; 

-(id)init;

@end
