//
//  BCInboxViewCell.m
//  Bathchat
//
//  Created by Derek Schultz on 4/3/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCInboxViewCell.h"

@implementation BCInboxViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
