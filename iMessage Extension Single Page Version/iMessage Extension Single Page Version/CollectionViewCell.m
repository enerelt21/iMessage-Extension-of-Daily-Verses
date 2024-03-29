//
//  CollectionViewCell.m
//  iMessage Extension Single Page Version
//
//  Created by Bat-Erdene, Ene on 5/30/19.
//  Copyright © 2019 Bat-Erdene, Ene. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.verseImage = UIImageView.new;
    self.verseImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.verseImage];
    [self.verseImage.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.verseImage.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    //self.verseImage.opaque = NO;
    //self.verseImage.hidden = NO;
    [self.verseImage.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    [self.verseImage.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    
    self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.bounds.origin.x, self.bounds.origin.y, 50, 12)];
    [self.cellLabel setBackgroundColor:[UIColor whiteColor]];
    [self.cellLabel setTextColor:[UIColor blackColor]];
    [self.cellLabel setFont:[UIFont boldSystemFontOfSize:8]];
    self.cellLabel.layer.cornerRadius = 5;
    self.cellLabel.clipsToBounds = YES;
//    UIImage *backGroundImage = [UIImage imageNamed:@"olivetree_cell_icon.png"];
//    self.verseImage = [self.verseImage initWithImage:backGroundImage];

    return self;
}
-(void) prepareForReuse{
    self.verseImage.image = nil;
    self.url = nil;
    //self.cellLabel = nil;
    [super prepareForReuse];
}

@end
