//
//  Product.m
//  ElStudio
//
//  Created by John Maher on 5/31/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "Product.h"

@implementation Product
 

-(id)init {
    if (self = [super init])
    {
        self.Product_SubProducts = [[NSMutableArray alloc]init] ;
    }
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.Product_id forKey:@"Product_id"];
    [encoder encodeObject:self.Product_name forKey:@"Product_name"];
    [encoder encodeObject:self.Product_description forKey:@"Product_description"];
    [encoder encodeObject:self.Product_ParentId forKey:@"Product_ParentId"];
    [encoder encodeObject:self.Product_basicNumber forKey:@"Product_basicNumber"];
    [encoder encodeObject:self.Product_basicPrice forKey:@"Product_basicPrice"];
    [encoder encodeObject:self.Product_addonNumber forKey:@"Product_addonNumber"];
    [encoder encodeObject:self.Product_addonPrice forKey:@"Product_addonPrice"];
    [encoder encodeObject:self.Product_imagewidth forKey:@"Product_imagewidth"];
    [encoder encodeObject:self.Product_imageheight forKey:@"Product_imageheight"];
    [encoder encodeObject:self.Product_SubProducts forKey:@"Product_SubProducts"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.Product_id = [decoder decodeObjectForKey:@"Product_id"];
    self.Product_name = [decoder decodeObjectForKey:@"Product_name"];
    self.Product_description = [decoder decodeObjectForKey:@"Product_description"];
    self.Product_basicNumber = [decoder decodeObjectForKey:@"Product_basicNumber"];
    self.Product_basicPrice = [decoder decodeObjectForKey:@"Product_basicPrice"];
    self.Product_addonNumber = [decoder decodeObjectForKey:@"Product_addonNumber"];
    self.Product_addonPrice = [decoder decodeObjectForKey:@"Product_addonPrice"];
    self.Product_imagewidth = [decoder decodeObjectForKey:@"Product_imagewidth"];
    self.Product_imageheight = [decoder decodeObjectForKey:@"Product_imageheight"];
    self.Product_ParentId = [decoder decodeObjectForKey:@"Product_ParentId"];
    self.Product_SubProducts = [decoder decodeObjectForKey:@"Product_SubProducts"];
    return self;
}

@end
