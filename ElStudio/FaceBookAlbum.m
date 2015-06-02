//
//  FaceBookAlbum.m
//  ElStudio
//
//  Created by John Maher on 6/2/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "FaceBookAlbum.h"

@implementation FaceBookAlbum

-(id)init {
    if (self = [super init])
    {
        self.AlbumName = [[NSString alloc]init];
        self.AlbumId = [[NSString alloc]init];
    }
    return self;
}

@end
