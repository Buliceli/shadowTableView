//
//  LDHeaderView.m
//  FoldTableVIewText
//
//  Created by 李洞洞 on 2020/8/13.
//  Copyright © 2020 co. All rights reserved.
//

#import "LDHeaderView.h"
#import "Masonry.h"
@implementation LDHeaderView
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
    }
    return _nameLabel;
}
- (UIImageView *)directionImv
{
    if (!_directionImv) {
        _directionImv = [[UIImageView alloc]init];
    }
    return _directionImv;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.directionImv];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.directionImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(30);
        make.left.mas_offset(20);
        make.centerY.mas_offset(0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(self.directionImv.mas_right).mas_offset(15);
    }];
    
}
@end
