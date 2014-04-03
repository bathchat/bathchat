//
//  BCEditImageView.m
//  Bathchat
//
//  Created by Derek Schultz on 4/3/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCEditImageView.h"

@implementation BCEditImageView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"init 1");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSLog(@"init 2");
    [self setBackgroundColor:[UIColor blackColor]];
    self.userInteractionEnabled = YES;
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    UIImage* ducky = [[UIImage alloc] initWithContentsOfFile:@"ducky"];
    UIImageView* duckyView = [[UIImageView alloc] initWithImage:ducky];
    [self addSubview:duckyView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
