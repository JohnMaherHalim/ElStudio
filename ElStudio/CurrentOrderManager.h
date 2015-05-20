//
//  CurrentOrderManager.h
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"

@interface CurrentOrderManager : NSObject

@property (nonatomic,retain) OrderItem *curOrderItem ;

-(void)storeProductName:(NSString*)productName ;
-(void)storeProductImages:(NSMutableArray*)productImages ;
-(void)storeImagesCounts:(NSMutableArray*)imagecounts ;
-(void)storeScales:(NSMutableArray*)imagesscales ; 

+ (id)sharedManager;

-(id)init ;

@end
