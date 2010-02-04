//
//  Robot_Finds_KittenViewController.h
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import <UIKit/UIKit.h>
#import "ScreenItem.h"

@interface Robot_Finds_KittenViewController : UIViewController {
	UILabel *robot;
	NSMutableArray *items;
	IBOutlet UILabel *message;
	IBOutlet UILabel *youWon;
	IBOutlet	UIButton *restart;
	IBOutlet UIButton *moveUpButton;
	IBOutlet UIButton *moveRightButton;
	IBOutlet UIButton *moveDownButton;
	IBOutlet UIButton *moveLeftButton;

	NSArray *colors;
}


@property (nonatomic, retain) UILabel *youWon;
@property (nonatomic, retain) UILabel *message;
@property (nonatomic, retain) UIButton *restart;
@property (nonatomic, retain) UIButton *moveUpButton;
@property (nonatomic, retain) UIButton *moveRightButton;
@property (nonatomic, retain) UIButton *moveDownButton;
@property (nonatomic, retain) UIButton *moveLeftButton;



-(IBAction) moveUp:(id)sender;
-(IBAction) moveRight:(id)sender;
-(IBAction) moveDown:(id)sender;
-(IBAction) moveLeft:(id)sender;
-(IBAction) restart:(id)sender;
-(void) moveRobot:(CGRect) robotPosition;
-(void)bounceRobot:(CGRect) robotPosition;
-(void) startDemo;
-(void)buttonAnimationFinished:(NSString*)animationID finished:(BOOL)finished context:(void*)context;
-(void)robotBounceAnimationReturn:(NSString*)animationID finished:(BOOL)finished context:(void*)context;

- (UILabel *) createCharacter:(NSString *)character top:(int)top left:(int)left color:(UIColor *)color bold:(BOOL)isBold ;
- (NSString *) getMessage;
- (ScreenItem *) itemAtLocation:(CGRect) robotPosition;
- (void) setupGame;
- (void) foundKitten;
@end

