//
//  FeedItemPoster.m
//  DemoApp
//
//  Created by Chris Seymour on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedItemPoster.h"
#import "AuthContext.h"


@implementation FeedItemPoster

+ (NSString*)addTextParam:(NSString*)param value:(NSString*)value body:(NSString*)body boundary:(NSString*)boundary {
	NSString* start = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"\r\n\r\n", body, param];
	return [NSString stringWithFormat:@"%@%@%@", start, value, boundary];
}

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

-(void)startPostWithMessage:(NSString*)message desc:(NSString*)desc filenamePrefix:(NSString*)filenamePrefix image:(UIImage*)image {
	// Post the photo to the group, using a regular HTTP POST because
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
	
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
   forHTTPHeaderField:@"Content-Type"];
	
	// Assemble the body.
	NSString* boundaryBreak = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
	NSString* body = boundaryBreak;
	
	body = [FeedItemPoster addTextParam:@"text" value:message body:body boundary:boundaryBreak];
	body = [FeedItemPoster addTextParam:@"desc" value:desc body:body boundary:boundaryBreak];
	
	NSDateFormatter* dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"M/d/y h:m:s"];
	NSString* date = [dateFormat stringFromDate:[NSDate date]];
	
	NSString* filenameStr = [NSString stringWithFormat:@"%@ %@.jpg", filenamePrefix, date];
	
	body = [FeedItemPoster addTextParam:@"fileName" value:filenameStr body:body boundary:boundaryBreak];
	
	body = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"feedItemFileUpload\"; filename=\"%@\"\r\n", body, filenameStr];
	body = [NSString stringWithFormat:@"%@Content-Type: application/octet-stream\r\n\r\n", body];
	
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
	NSLog(@"Failed to finish photo post request: %@", error);
	[responseData release];
	responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData release];
	responseData = [[NSMutableData dataWithCapacity:1024] retain];
	[responseData setLength:0];
	
	statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSLog(@"status code: %d", statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData {
	[responseData appendData:inData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString* responseStr = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"Response: %@", responseStr);
	
	// Show a modal popup with the result.
	NSString* result;
	if (statusCode == 201) {
		result = @"Success";
	} else {
		result = @"Failed";
	}	
	
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Post Result" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	
	[responseData release];
	responseData = nil;
}

@end
