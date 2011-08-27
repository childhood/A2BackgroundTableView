//
//  A2BackgroundTableView.m
//
//  Created by Alexsander Akers on 8/18/11.
//  Copyright 2011 Pandamonia LLC. All rights reserved.
//

#import "A2BackgroundTableView.h"

NSString *const kADBackgroundImageKey = @"ADBackgroundImage";

@implementation A2BackgroundTableView

- (id) initWithBackgroundImage: (UIImage *) tile
{
	return [self initWithFrame: CGRectZero backgroundImage: tile];
}
- (id) initWithFrame: (CGRect) frame
{
	return [self initWithFrame: frame backgroundImage: nil];
}
- (id) initWithFrame: (CGRect) frame backgroundImage: (UIImage *) tile
{
	NSAssert(tile != nil, @"A2BackgroundTableView must be supplied with a tileable background image.");
	if ((self = [super initWithFrame: frame style: UITableViewStyleGrouped]))
	{
		_backgroundImage = [tile retain];
	}
	
	return self;
}
- (id) initWithFrame: (CGRect) frame style: (UITableViewStyle) style
{
	return [self initWithFrame: frame backgroundImage: nil];
}

- (UIColor *) backgroundColor
{
	return [UIColor clearColor];
}

- (void) dealloc
{
	[_backgroundImage release];
	[_backgroundLayer release];
	[super dealloc];
}
- (void) setBackgroundColor: (UIColor *) backgroundColor
{
	// Deliberately suppressed.
}
- (void) setContentSize: (CGSize) contentSize
{
	[super setContentSize: contentSize];
	
	CGFloat h = MAX(CGRectGetHeight(self.bounds), contentSize.height);
	if (_lastConfiguredHeight != h)
	{
		if (!_extraBleedRoom) _extraBleedRoom = 2 * CGRectGetHeight(self.bounds);
		
		if (_backgroundLayer)
		{
			CGRect r = _backgroundLayer.frame;
			r.size.height = h + 2 * _extraBleedRoom;
			_backgroundLayer.frame = r;
		}
		else
		{
			_backgroundLayer = [[CALayer layer] retain];
			_backgroundLayer.backgroundColor = [UIColor colorWithPatternImage: _backgroundImage].CGColor;
			_backgroundLayer.frame = CGRectMake(0, -_extraBleedRoom, CGRectGetWidth(self.bounds), h + 2 * _extraBleedRoom);
			_backgroundLayer.zPosition = -1.0;
			[self.layer addSublayer: _backgroundLayer];
		}
		
		[self.layer.sublayers enumerateObjectsUsingBlock: ^(CALayer *layer, NSUInteger idx, BOOL *stop) {
			if (CGRectEqualToRect(self.layer.bounds, layer.frame)) layer.hidden = YES;
		}];
		
		_lastConfiguredHeight = h;
	}
}

#pragma mark - Coding

- (id) initWithCoder: (NSCoder *) decoder
{
	if ((self = [super initWithCoder: decoder]))
	{
		if ([decoder allowsKeyedCoding])
			_backgroundImage = [[decoder decodeObjectForKey: kADBackgroundImageKey] retain];
		else
			_backgroundImage = [[decoder decodeObject] retain];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
	[super encodeWithCoder: coder];
	
	if ([coder allowsKeyedCoding])
		[coder encodeObject: _backgroundImage forKey: kADBackgroundImageKey];
	else
		[coder encodeObject: _backgroundImage];
}

@end
