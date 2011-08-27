//
//  A2BackgroundTableView.h
//
//  Created by Alexsander Akers on 8/18/11.
//  Copyright 2011 Pandamonia LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface A2BackgroundTableView : UITableView
{
	CALayer *_backgroundLayer;
	CGFloat _extraBleedRoom;
	CGFloat _lastConfiguredHeight;
	UIImage *_backgroundImage;
}

- (id) initWithBackgroundImage: (UIImage *) tile;
- (id) initWithFrame: (CGRect) frame backgroundImage: (UIImage *) tile; // Designated initializer.

@end
