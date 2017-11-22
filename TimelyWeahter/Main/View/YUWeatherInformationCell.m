//
//  YUWeatherInformationCell.m
//  TimelyWeahter
//
//  Created by timely on 15/3/4.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUWeatherInformationCell.h"
#import "YUWeatherDataModel.h"

@interface YUWeatherInformationCell ()

@property (weak, nonatomic) IBOutlet UILabel *sunRaiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windPowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *airPressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ziWaiXianLabel;


@end

@implementation YUWeatherInformationCell

- (void)awakeFromNib {
    
    
    self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.15];
    
}

- (void)setWeatherModel:(YUWeatherDataModel *)weatherModel
{
    _weatherModel = weatherModel;

    if ([weatherModel.sun_begin_end isEqualToString:@"null|null"]) {
        
        
        self.sunRaiseLabel.text = @"";
        self.sunSetLabel.text = @"";
    } else
    {
        self.sunRaiseLabel.text = [weatherModel.sun_begin_end substringToIndex:5];
        self.sunSetLabel.text = [weatherModel.sun_begin_end substringFromIndex:6];
    }
    
    self.windDirectionLabel.text = weatherModel.day_wind_direction;
    self.windPowerLabel.text = weatherModel.day_wind_power;
    self.airPressLabel.text = weatherModel.air_press;
    self.ziWaiXianLabel.text = weatherModel.ziwaixian;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
