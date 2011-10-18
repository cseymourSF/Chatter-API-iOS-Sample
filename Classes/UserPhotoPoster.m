//
//  UserPhotoPoster.m
//  DemoApp
//
//  Created by Chris Seymour on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserPhotoPoster.h"
#import "AuthContext.h"

@implementation UserPhotoPoster

-(id)initWithUrl:(NSString*)urlIn {
	self = [super init];
	if (self != nil) {
		url = [urlIn retain];
		statusCode = 0;
	}
	return self;
}

-(void)dealloc {
	[url release];
	
	[super dealloc];
}

-(void)startPostWithFilename:(NSString*)filename image:(UIImage*)image {
	// Post the user photo, using a regular HTTP POST because
	// RestKit doesn't support multipart binary posts yet.
	NSString* targetUrl = [NSString stringWithFormat:@"%@%@", [[AuthContext context] instanceUrl], url];
	NSLog(@"Posting to url: %@", targetUrl);
	
	// Make the request.
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:targetUrl]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData // Don't use the cache.
													   timeoutInterval:60];
	
	[[AuthContext context] addOAuthHeaderToNSRequest:request];
	[request setHTTPMethod:@"POST"];
	
	NSString* boundary = @"-----------------2342342352342343";
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	// Assemble the body.
	NSString* boundaryBreak = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
	NSString* body = boundaryBreak;
	
	body = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"fileUpload\"; filename=\"%@\"\r\n", body, filename];
	body = [NSString stringWithFormat:@"%@Content-Type: image/jpeg\r\n\r\n", body]; // can't be octet-stream
	
	NSMutableData* bodyData = [NSMutableData data];
	[bodyData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSData* imageData = UIImageJPEGRepresentation(image, 90);
	[bodyData appendData:imageData];
	
	NSData* boundaryDataEnd = [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[bodyData appendData:boundaryDataEnd];
	
	[request setHTTPBody:bodyData];
	
	// Send the request asynchronously.
	[NSURLConnection connectionWithRequest:request delegate:self];
}

// ================
// NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Failed to finish user photo post request: %@", error);
	[responseData release];
	responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData release];
	responseData = [[NSMutableData dataWithCapacity:1024] retain];
	[responseData setLength:0];
	
	statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSLog(@"User photo post status code: %d", statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData {
	[responseData appendData:inData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString* responseStr = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];

	// Show a modal popup with the result.
	NSString* result;
	if (statusCode == 201) {
		result = @"Success";
	} else {
		result = @"Failed";
		NSLog(@"User photo post failed with response: %@", responseStr);
	}	
	
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Photo Post Result" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	
	[responseData release];
	responseData = nil;
}

@end
