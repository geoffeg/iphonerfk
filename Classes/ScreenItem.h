//
//  ScreenItem.h
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import <Foundation/Foundation.h>


@interface ScreenItem : NSObject {
	UILabel *item;
	NSString *message;
	BOOL kitten;
}

@property (nonatomic, retain) UILabel *item;
@property (nonatomic, retain) NSString *message;
@property (nonatomic) BOOL kitten;


-(id)initWithLabel:(UILabel *)label message:(NSString *)mess;
@end
