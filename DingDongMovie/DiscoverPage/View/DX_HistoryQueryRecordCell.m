//
//  DX_HistoryQueryRecordCell.m
//  DingDongMovie
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#import "DX_HistoryQueryRecordCell.h"

@implementation DX_HistoryQueryRecordCell

- (void)dealloc
{
    [_label release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createLabelsCell];
    }
    return self;
}

- (void)createLabelsCell
{
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.textColor = [UIColor grayColor];
    self.label.layer.borderColor = [UIColor grayColor].CGColor;
    self.label.layer.borderWidth = 0.3;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.layer.cornerRadius = 5;
    self.label.clipsToBounds = YES;
    [self.contentView addSubview:self.label];
    [_label release];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, 30);
}

@end
