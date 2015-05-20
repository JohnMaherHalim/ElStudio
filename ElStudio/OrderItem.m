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
}

- (id)initWithCoder:(NSCoder *)decoder {
	self.ProductName = [decoder decodeObjectForKey:@"ProductName"];
	self.ProductImages = [decoder decodeObjectForKey:@"ProductImages"];
	self.ImagesCounts = [decoder decodeObjectForKey:@"ImagesCounts"];
	self.ImagesScales = [decoder decodeObjectForKey:@"ImagesScales"];
	return self;
}

@end
