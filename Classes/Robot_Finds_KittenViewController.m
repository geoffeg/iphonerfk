//
//  Robot_Finds_KittenViewController.m
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import "Robot_Finds_KittenViewController.h"
#import "messages.h"
#import "ScreenItem.h"

@implementation Robot_Finds_KittenViewController

@synthesize youWon;
@synthesize message;
@synthesize restart;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	srand(time(NULL));
	items = [[NSMutableArray alloc] initWithCapacity:200];
	
	
	// Create a list of primary and secondary colors
	colors = [NSArray arrayWithObjects:
		[UIColor colorWithRed:1 green:0 blue:0 alpha:1] , // Red
	    [UIColor colorWithRed:0 green:1 blue:0 alpha:1], // Green
		[UIColor colorWithRed:0 green:0 blue:1 alpha:1], // Blue
		[UIColor colorWithRed:1 green:1 blue:0 alpha:1], // Yellow
		[UIColor colorWithRed:1 green:0 blue:1 alpha:1], // Purple
        [UIColor colorWithRed:0 green:0 blue:1 alpha:1], // Cyan
        [UIColor colorWithRed:1 green:1 blue:1 alpha:1], // White
	    nil
	];
	[colors retain];
	
	[self setupGame];
}

-(void)setupGame {
	youWon.hidden = YES;
	message.text = @"";
	restart.hidden = YES;
	for (int i = 0; i < [items count]; i++) {
		ScreenItem *item = [items objectAtIndex:i];
		[item.item removeFromSuperview];
	}
	[items removeAllObjects];
	
	// Generate items
	while ([items count] < 25) {
		int top = (arc4random() % 16) * 20;
		int left = (arc4random() % 20) * 20 + 50;
		
		// make sure there isn't already a character at this position		
		if ([self itemAtLocation:CGRectMake(top, left, 20, 20)] != nil) continue;
		
		int charaCode = arc4random() % (126-'!'+1)+'!';
		NSString *theCharacter = [[NSString alloc] initWithFormat:@"%c", charaCode];
		[self createCharacter:theCharacter top:top left:left color:[colors objectAtIndex:arc4random() % [colors count]] bold:YES];
		[theCharacter release];
	}
	
	// Mark one of the items as the kitten!
	ScreenItem *item = [items objectAtIndex:arc4random() % [items count]];
	item.kitten = YES;
#ifdef DEBUG
	item.item.text = @"@";
#endif
	// Draw the robot, but make sure we don't draw it on top of another item
	int top, left;
	do {
		top = (arc4random() % 16) * 20;
		left = (arc4random() % 20) * 20 + 50;
	} while ([self itemAtLocation:CGRectMake(top, left, 20, 20)] != nil);
	robot = [self createCharacter:@"#" top:top left:left color:[UIColor whiteColor] bold:YES];
}


-(IBAction) moveUp:(id)sender {
	CGRect robotPosition = [robot frame];
	robotPosition.origin.y -= 20;
	if (robotPosition.origin.y < 40) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && [item kitten]) {
		[self foundKitten];
		return;
	} else if (item != nil && [item kitten] == NO) {		
		message.text = [item message];
		return;
	}
	
	robot.frame = robotPosition;
}

-(IBAction) moveRight:(id)sender {
	CGRect robotPosition = [robot frame];
	robotPosition.origin.x += 20;
	if (robotPosition.origin.x > 300) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && [item kitten]) {
		[self foundKitten];
		return;
	} else if (item != nil && [item kitten] == NO) {		
		message.text = [item message];
		return;
	}	
	
	robot.frame = robotPosition;	
}

-(IBAction) moveDown:(id)sender {
	CGRect robotPosition = [robot frame];
	robotPosition.origin.y += 20;
	if (robotPosition.origin.y > 440) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && [item kitten]) {
		[self foundKitten];
		return;
	} else if (item != nil && [item kitten] == NO) {		
		message.text = [item message];
		return;
	}
	
	robot.frame = robotPosition;
}

-(IBAction) moveLeft:(id)sender {
	CGRect robotPosition = [robot frame];
	robotPosition.origin.x -= 20;
	if (robotPosition.origin.x < 0) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && [item kitten]) {
		[self foundKitten];
		return;
	} else if (item != nil && [item kitten] == NO) {		
		message.text = [item message];
		return;
	}
	robot.frame = robotPosition;
}

-(void) foundKitten {
	message.text = @"";
	youWon.hidden = NO;
	restart.hidden = NO;
	[self.view bringSubviewToFront:restart];
	[self.view bringSubviewToFront:youWon];					
}

-(IBAction) restart:(id)sender {
	[self setupGame];
}

-(ScreenItem *) itemAtLocation:(CGRect) robotPosition {
	CGRect itemPosition;
	for (int i = 0; i < [items count]; i++) {
		itemPosition = [[[items objectAtIndex: i] item] frame];
		if (robotPosition.origin.x == itemPosition.origin.x && robotPosition.origin.y == itemPosition.origin.y) {
			return [items objectAtIndex:i];
		} 
	}
	return nil;
}

-(NSString *) getMessage {
	int index;
	do {
		index = arc4random() % MESSAGES;
	} while (index < 0);
	return [[NSString alloc] initWithFormat:@"%s", messages[index]];
}

- (UILabel *)createCharacter:(NSString *)character top:(int)top left:(int)left color:(UIColor *)textColor bold:(BOOL)isBold {
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(top, left, 20, 20)];
	newLabel.text = character;
	newLabel.textAlignment = UITextAlignmentCenter;
	UIFont *font;
	font = isBold ? [UIFont fontWithName:@"CourierNewPS-BoldMT" size: 20.0] : [UIFont fontWithName:@"Courier New" size: 20.0];
	newLabel.font = font;
	[font release];
	newLabel.textColor = textColor;
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.numberOfLines = 1;
	[self.view addSubview:newLabel];
	ScreenItem *item = [[ScreenItem alloc] initWithLabel:newLabel message:[self getMessage]];
	[items addObject:item];
	//[item release];
	[newLabel release];
	return newLabel;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
