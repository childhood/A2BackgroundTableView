//
//  A2BackgroundTableView.h
//
//  Created by Alexsander Akers on 8/18/11.
//  Copyright 2011 Pandamonia LLC. All rights reserved.
//

#import <UIKit/UITableView.h>

@interface A2BackgroundTableView : UITableView
{
@private
	CALayer *_backgroundLayer;
	UIImage *_backgroundImage;
	CGFloat _lastConfiguredHeight;
}

- (id) initWithBackgroundImage: (UIImage *) tile;
- (id) initWithFrame: (CGRect) frame backgroundImage: (UIImage *) tile; // Designated initializer.

@end
