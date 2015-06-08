//
//  Admin.h
//  ElStudio
//
//  Created by John Maher on 6/8/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Admin : NSObject

@property (nonatomic,retain) NSNumber *Admin_id ;
@property BOOL Admin_fbEnabled ;
@property BOOL Admin_instaEnabled ;
@property (nonatomic,retain) NSString *Admin_AboutUs ;
@property (nonatomic,retain) NSString *Admin_Name ;
@property (nonatomic,retain) NSString *Admin_Address ;
@property (nonatomic,retain) NSString *Admin_Phone ; 

@end
