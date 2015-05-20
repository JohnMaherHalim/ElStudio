//
//  Order.m
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "Order.h"

@implementation Order

-(id)init {
    if (self = [super init])
    {
        self.OrderItems = [[NSMutableArray alloc]init] ;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.OrderItems forKey:@"OrderItems"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	self.OrderItems = [decoder decodeObjectForKey:@"OrderItems"];
	return self; 
}

@end
