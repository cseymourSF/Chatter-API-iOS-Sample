//
//  ObjectFetcher.h
//  DemoApp
//
//  Copyright 2011 Salesforce.com. All rights reserved.
//
//  This is sample code provided as a learning tool. Feel free to 
//  learn from it and incorporate elements into your own code. 
//  No guarantees are made about the quality or security of this code.
//
//  THIS SOFTWARE IS PROVIDED BY Salesforce.com "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Salesforce.com OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

#import "RKObject.h"
#import "RKObjectLoader.h"

@protocol ObjectFetcherDelegate<NSObject>
- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded; 
@end

@interface ObjectFetcher : NSObject<RKObjectLoaderDelegate> {
	NSString* tag;
	RKObject* obj;
	NSObject<ObjectFetcherDelegate>* myDelegate;
}

@property(nonatomic, retain) NSString* tag;
@property(nonatomic, retain) RKObject* obj;
@property(nonatomic, assign) NSObject<ObjectFetcherDelegate>* myDelegate;

// We assume the delegate will outlive this object, it is not retained.
- initWithTag:(NSString*)inTag object:(RKObject*)inObj delegate:(NSObject<ObjectFetcherDelegate>*)inDelegate;

- (void)fetch;

@end
