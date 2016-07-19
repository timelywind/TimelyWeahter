//
//  YULivingIndexCell.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/4.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YULivingIndexCell.h"
#import "YULivingIndexModel.h"

@interface YULivingIndexCell ()

@property (weak, nonatomic) IBOutlet UILabel *clothesLabel;
@property (weak, nonatomic) IBOutlet UILabel *lsLabel;
@property (weak, nonatomic) IBOutlet UILabel *gmLabel;
@property (weak, nonatomic) IBOutlet UILabel *clLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelLabel;
@property (weak, nonatomic) IBOutlet UILabel *pjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dyLabel;

@end

@implementation YULivingIndexCell

- (void)awakeFromNib {
    self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.15];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    
    [super setFrame:frame];
}

- (void)setLivingIndexModel:(YULivingIndexModel *)livingIndexModel
{
    _livingIndexModel = livingIndexModel;
    
    self.clothesLabel.text = livingIndexModel.clothes_title;
    self.lsLabel.text = livingIndexModel.ls_title;
    self.gmLabel.text = livingIndexModel.cold_title;
    self.clLabel.text = livingIndexModel.cl_title;
    self.travelLabel.text = livingIndexModel.travel_title;
    self.pjLabel.text = livingIndexModel.pj_title;
    self.dyLabel.text = livingIndexModel.dy_title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
