//
//  SHWeekDayTableViewCell.m

//

#import "SHWeekDayTableViewCell.h"

@interface SHWeekDayTableViewCell ()

@property (nonatomic, strong) UIImageView *checkView;

@end

@implementation SHWeekDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)cheakView
{
    if (_checkView == nil) {
        _checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        self.accessoryView = _checkView;
    }
    return _checkView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    }
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.textLabel.text = dataDict[@"weekDay"];
    self.isSelected = [dataDict[@"isSelected"] boolValue];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.cheakView.hidden = !isSelected;
}

@end
