//
//  Order.h
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject<NSCoding>

@property (nonatomic, retain) NSMutableArray *OrderItems ;
@property  (nonatomic,retain) NSNumber * totalPrice ;

-(id)init ;

@end
