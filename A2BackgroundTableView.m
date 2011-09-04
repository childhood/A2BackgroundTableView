//
//  File: A2BackgroundTableView.h
//  Abstract: A UITableView subclass that allows a scrolling and tiled background image
//      to be displayed behind grouped cells.
//  
//  Disclaimer: IMPORTANT: This Pandamonia software is supplied to you by
//  Alexsander Akers on behalf of and by Pandamonia LLC ("Pandamonia") in
//  consideration of your agreement to the following terms, and your use,
//  installation, modification or redistribution of this Pandamonia software
//  constitutes acceptance of these terms. If you do not agree with these terms,
//  please do not use, install, modify or redistribute this Pandamonia software.
//  
//      In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Pandamonia grants you a personal, non-exclusive
//  license, under Pandamonia's copyrights and intellectual property rights in
//  this original Pandamonia software (the "Pandamonia Software"), to use,
//  reproduce, modify and redistribute a part of or the entirety of the
//  Pandamonia Software, with or without modifications, in source and/or binary
//  forms, or by any electronic or mechanical means, including information and
//  retrieval systems (collectively, "to Redistribute"); provided that if you
//  Redistribute the Pandamonia Software, you must retain this notice and the
//  following text and disclaimers in all such redistributions of the Pandamonia
//  Software, including the documentation and/or other materials provided with
//  the distribution.
//  
//      Neither the name, trademarks, service marks or logos of Pandamonia may
//  be used to endorse or promote products derived from the Pandamonia Software
//  without specific prior written permission from Pandamonia. Except as
//  expressly stated in this notice, no other rights or licenses, express or
//  implied, are granted by Pandamonia herein, including but not limited to any
//  patent rights that may be infringed by your derivative works or by other
//  works in which the Pandamonia Software may be incorporated.
//  
//      The Pandamonia Software is provided by Pandamonia on an "AS IS" basis.
//  PANDAMONIA MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT
//  LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE PANDAMONIA SOFTWARE OR ITS
//  USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//  
//      IN NO EVENT SHALL PANDAMONIA BE LIABLE FOR ANY SPECIAL, INDIRECT,
//  INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//  OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//  MODIFICATION AND/OR DISTRIBUTION OF THE PANDAMONIA SOFTWARE, HOWEVER CAUSED
//  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT
//  LIABILITY OR OTHERWISE, EVEN IF PANDAMONIA HAS BEEN ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//  
//  Copyright (c) 2011 Pandamonia. All rights reserved.
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
