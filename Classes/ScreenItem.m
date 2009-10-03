//
//  ScreenItem.m
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import "ScreenItem.h"


@implementation ScreenItem

@synthesize item;
@synthesize message;
@synthesize kitten;

-(id)initWithLabel:(UILabel *)label message:(NSString *)mess {
	NSLog(@"Creating new item");
	self.item = label;
	self.message = mess;
	self.kitten = NO;
	return self;
}

- (void)dealloc {
	NSLog(@"Being deallocd");
	[item dealloc];
	[message dealloc];
    [super dealloc];
}


@end
