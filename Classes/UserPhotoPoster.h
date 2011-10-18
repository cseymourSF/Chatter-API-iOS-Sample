//
//  UserPhotoPoster.h
//  DemoApp
//
//  Created by Chris Seymour on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface UserPhotoPoster : NSObject {
	NSString* url;
	NSMutableData* responseData;
	int statusCode;
}

-(id)initWithUrl:(NSString*)urlIn;
-(void)startPostWithFilename:(NSString*)filename image:(UIImage*)image;

@end
