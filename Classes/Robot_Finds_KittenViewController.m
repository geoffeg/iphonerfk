//
//  Robot_Finds_KittenViewController.m
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import <QuartzCore/QuartzCore.h>
#import "Robot_Finds_KittenViewController.h"
#import "messages.h"
#import "ScreenItem.h"

@implementation Robot_Finds_KittenViewController

@synthesize youWon;
@synthesize message;
@synthesize restart;
CGRect robotPosition;
int totalMovements;
int requiredMovements = 0;
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

		NSString *theCharacter;
		do {
			int charaCode = arc4random() % (126-'!'+1)+'!';
			theCharacter = [[NSString alloc] initWithFormat:@"%c", charaCode];			
		} while ([theCharacter compare:@"#"] == NSOrderedSame);
		[self createCharacter:theCharacter top:top left:left color:[colors objectAtIndex:arc4random() % [colors count]] bold:YES];
		[theCharacter release];
	}
	
	// Mark one of the items as the kitten!
	requiredMovements = (arc4random() % [items count]) + 1;
#ifdef DEBUG
	requiredMovements = 2;
#endif
	
	// Draw the robot, but make sure we don't draw it on top of another item
	int top, left;
	do {
		top = (arc4random() % 16) * 20;
		left = (arc4random() % 20) * 20 + 50;
	} while ([self itemAtLocation:CGRectMake(top, left, 20, 20)] != nil);
	robot = [self createCharacter:@"#" top:top left:left color:[UIColor whiteColor] bold:YES];
	
	totalMovements = 0;
}


-(IBAction) moveUp:(id)sender {
	robotPosition = [robot frame];
	robotPosition.origin.y -= 20;
	if (robotPosition.origin.y < 40) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && ++totalMovements == requiredMovements) {
		[self foundKitten];
		return;
	} else if (item != nil) {		
		[self bounceRobot:robotPosition];
		message.text = [item message];
		return;
	}
	[self moveRobot:robotPosition];
}

-(IBAction) moveRight:(id)sender {
	robotPosition = [robot frame];
	robotPosition.origin.x += 20;
	if (robotPosition.origin.x > 300) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && ++totalMovements == requiredMovements) {
		[self foundKitten];
		return;
	} else if (item != nil) {		
		[self bounceRobot:robotPosition];
		message.text = [item message];
		return;
	}	
	[self moveRobot:robotPosition];
}

-(IBAction) moveDown:(id)sender {
	robotPosition = [robot frame];
	robotPosition.origin.y += 20;
	if (robotPosition.origin.y > 440) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && ++totalMovements == requiredMovements) {
		[self foundKitten];
		return;
	} else if (item != nil) {		
		[self bounceRobot:robotPosition];
		message.text = [item message];
		return;
	}
	[self moveRobot:robotPosition];
}

-(IBAction) moveLeft:(id)sender {
	robotPosition = [robot frame];
	robotPosition.origin.x -= 20;
	if (robotPosition.origin.x < 0) return;
	ScreenItem *item = [self itemAtLocation:robotPosition];
	if (item != nil && ++totalMovements == requiredMovements) {
		[self foundKitten];
		return;
	} else if (item != nil) {
		[self bounceRobot:robotPosition];
		message.text = [item message];
		return;
	}
	[self moveRobot:robotPosition];
}

-(void)bounceRobot:(CGRect) robotPosition {
	CABasicAnimation *robotAnimation;
	
	if ([robot frame].origin.x > robotPosition.origin.x) { // robot is trying to move left
		robotAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
		robotAnimation.toValue = [NSNumber numberWithFloat:-10.0];			
	} else if ([robot frame].origin.x < robotPosition.origin.x) { // robot is trying to move right
		robotAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
		robotAnimation.toValue = [NSNumber numberWithFloat:10.0];					
	} else if ([robot frame].origin.y > robotPosition.origin.y) { // robot is trying to move up
		robotAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
		robotAnimation.toValue = [NSNumber numberWithFloat:-10.0];
	} else if ([robot frame].origin.y < robotPosition.origin.y) { // robot is trying to move down
		robotAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
		robotAnimation.toValue = [NSNumber numberWithFloat:10.0];
	}
	robotAnimation.duration = .2;
	robotAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	[robot.layer addAnimation:robotAnimation forKey:@"bounceRobot"];
	
}

-(void) moveRobot:(CGRect) robotPosition {
	[UIView beginAnimations:@"MoveRobot" context:nil];
	[UIView setAnimationDuration:.2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	robot.frame = robotPosition;
	[UIView commitAnimations];
	//[self startDemo];
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

- (void)startDemo {
	// Highlight the robot
	[UIView beginAnimations:@"ShowRobot" context:nil];
	[UIView setAnimationDuration:3];
	[UIView setAnimationBeginsFromCurrentState:YES];	
	robot.backgroundColor = [UIColor whiteColor];
	[UIView commitAnimations];
	
	// Explain the buttons.
	moveUpButton.alpha = .1f;
	youWon.text = @"Use these buttons to move the robot";
	youWon.hidden = NO;
	[UIView beginAnimations:@"ShowButton" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationBeginsFromCurrentState:YES];	
	[UIView setAnimationRepeatCount:2];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(buttonAnimationFinished:finished:context:)];
	moveUpButton.alpha = .6f;
	[UIView commitAnimations];

	 

	// "Touch an item 
}

-(void)buttonAnimationFinished:(NSString*)animationID finished:(BOOL)finished context:(void*)context {
	//[UIView beginAnimations:@"HideButton" context:nil];
//	[UIView setAnimationDuration:1];
//	[UIView setAnimationBeginsFromCurrentState:YES];	
//	moveUpButton.alpha = .1f;
//	[UIView commitAnimations];
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
