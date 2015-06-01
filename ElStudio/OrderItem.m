//
//  OrderItem.m
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

-(id)init {
    if (self = [super init])
    {
        self.ProductImages = [[NSMutableArray alloc]init] ;
        self.ImagesCounts = [[NSMutableArray alloc]init] ;
		self.ImagesScales = [[NSMutableArray alloc]init]; 
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.ProductName forKey:@"ProductName"];
	[encoder encodeObject:self.ProductImages forKey:@"ProductImages"];
	[encoder encodeObject:self.ImagesCounts forKey:@"ImagesCounts"];
	[encoder encodeObject:self.ImagesScales forKey:@"ImagesScales"];
    [encoder encodeInteger:self.ItemPrice forKey:@"ItemPrice"];
    [encoder encodeInteger:self.AddOns forKey:@"AddOns"];
    [encoder encodeObject:self.product forKey:@"Product"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	self.ProductName = [decoder decodeObjectForKey:@"ProductName"];
	self.ProductImages = [decoder decodeObjectForKey:@"ProductImages"];
	self.ImagesCounts = [decoder decodeObjectForKey:@"ImagesCounts"];
	self.ImagesScales = [decoder decodeObjectForKey:@"ImagesScales"];
    self.ItemPrice = [decoder decodeIntegerForKey:@"ItemPrice"];
    self.AddOns = [decoder decodeIntegerForKey:@"AddOns"];
    self.product = [decoder decodeObjectForKey:@"Product"];
	return self;
}

-(void)modifyItemPrice :(NSInteger)currentCount {
    NSInteger Sum = 0 ;
    Sum += [self.product.Product_basicPrice integerValue] ;
    
    NSInteger IndexAfter = currentCount - [self.product.Product_basicNumber integerValue];
    NSInteger divided = IndexAfter/[self.product.Product_addonNumber integerValue] ;
    if (IndexAfter % [self.product.Product_addonNumber integerValue] != 0) {
        divided++ ;
    }
    [self setAddOns:divided];
    
    Sum += self.AddOns * [self.product.Product_addonPrice integerValue];
    self.ItemPrice = Sum;
}

@end
