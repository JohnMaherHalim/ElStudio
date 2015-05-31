//
//  ProductsStore.h
//  ElStudio
//
//  Created by John Maher on 5/31/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsStore : NSObject

@property (nonatomic,retain) NSMutableArray *Products ; 

+ (id)sharedManager;

-(id)init ;

@end
