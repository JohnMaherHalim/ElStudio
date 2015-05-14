//
//  OrderItem.h
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject

@property (nonatomic,retain) NSString *ProductName ;
@property (nonatomic,retain) NSMutableArray *ProductImages ;

-(id)init ;

@end
