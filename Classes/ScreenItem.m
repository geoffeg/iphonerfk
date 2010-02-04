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

-(id)initWithLabel:(UILabel *)label message:(NSString *)mess {
#ifdef DEBUG
	NSLog(@"Creating new item");
#endif
	self.item = label;
	self.message = mess;
	return self;
}

- (void)dealloc {
#ifdef DEBUG
	NSLog(@"Being deallocd");
#endif
	[item dealloc];
	[message dealloc];
    [super dealloc];
}


@end
