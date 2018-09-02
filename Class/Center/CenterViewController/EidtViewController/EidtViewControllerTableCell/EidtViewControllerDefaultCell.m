//
//  EidtViewControllerDefaultCell.m
//  WePlan
//
//  Created by Harry on 2018/8/31.
//  Copyright © 2018年 Harry. All rights reserved.
//

#define Spacing 10
#define Width_Cell (self.contentView.frame.size.width - Spacing *2)
#define TextView_Spaceing 7.5

#import "EidtViewControllerDefaultCell.h"
@interface EidtViewControllerDefaultCell()
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UISwitch *allDaySwitch;

@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *startWeek;
@property (nonatomic, copy) NSString *endWeek;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation EidtViewControllerDefaultCell

#pragma mark 设置cell 配置 //代替了cellForRow
- (EidtViewControllerDefaultCell *)indexPath:(NSIndexPath *)indexPath WithEvent:(EKEvent *)event {
    /**
     0 标题
     1 位置
     2 时间信息
     3 全天开关
     4 开始时间
     5 结束时间
     6 提醒
     7 备注
     8 删除
     */
#pragma mark 初始化数据
    EidtViewControllerDefaultCell *cell = self;
    self.event = event;
    self.rowHeight = cell.contentView.frame.size.height;
    [self setDateWithEvent:event];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//如果是全天隐藏 开始时间和结束时间
//    if (event.allDay) {
//        if (indexPath.row == 3 || indexPath.row == 4) {
//            cell.rowHeight = 0;
//            return cell;
//        }
//    }
    switch (indexPath.row) {
        case 0: //标题
            [cell type:EidtViewControllerCellTypeTitleTextView content:event.title];
            break;
        case 1: //位置
            [cell type:EidtViewControllerCellTypeLocation content:event.location];
            break;
        case 2: { // 显示时间， 传入为EKEvent 对象
            [cell type:EidtViewControllerCellTypeDate content:event];
        }
            break;
        case 3:
            cell.titleLabel.text = @"全天";
            self.allDaySwitch.on = event.allDay;
            break;

        case 4:
            cell.type = EidtViewControllerCellTypeArrow;
            cell.titleLabel.text = @"开始时间";
            cell.describeLabel.text = [NSString stringWithFormat:@"%@ %@",_startDate,_startTime];
            break;

        case 5:
            cell.type = EidtViewControllerCellTypeArrow;
            cell.titleLabel.text = @"结束时间";
            BOOL isEqutoDate = [_startDate isEqualToString:_endDate];
            cell.describeLabel.text = [NSString stringWithFormat:@"%@%@",isEqutoDate?@"":[NSString stringWithFormat:@"%@ ",_endDate],_endTime];
            break;

        case 6:
            cell.type = EidtViewControllerCellTypeDefault;
            cell.titleLabel.text = @"提醒";
            cell.describeLabel.text = @"无";
            break;

        case 7:
            cell.type = EidtViewControllerCellTypeDefault;
            cell.titleLabel.text = @"备注";
            [cell type:EidtViewControllerCellTypeTitleTextView content:event.title];
            cell.textView.frame = CGRectMake(Spacing, 44 + Spacing, CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame));
            cell.rowHeight += 44;

            break;

        case 8:
            cell.type = EidtViewControllerCellTypeDelete;
            cell.titleLabel.text = @"删除日程";
            break;

        default:
            break;
    }

    return cell;
}

#pragma mark 设置样式 坐标
- (void)type:(EidtViewControllerCellType)type content:(id)content{
    if (!content) {
        content = @"";
    }
    self.type = type;
    switch (type) {
        case EidtViewControllerCellTypeTitleTextView:{
            [self setUIProperty:self.textView content:content spacing:Spacing];
        }
            break;

        case EidtViewControllerCellTypeLocation:{//位置
            //FIXME: 待定 ：坐标 高度
            self.titleLabel.text = content;
            self.titleLabel.font = [UIFont fontWithName:@".SFUIText" size:10];
            [self setUIProperty:self.titleLabel content:content spacing:Spacing];
            self.titleLabel.frame = CGRectMake(Spacing, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height - Spacing*2);
            self.rowHeight = self.titleLabel.frame.size.height;
        }
            break;
        case EidtViewControllerCellTypeDate:{
            NSString *content;
            EKEvent *event = (EKEvent *)content;
            if (event.allDay) {
                content = @"全天";
            }else {
                BOOL isEqutoDate = [_startDate isEqualToString:_endDate];
                BOOL isEqutoTime = [_startTime isEqualToString:_endTime];

                if (isEqutoDate) {
                    content = [NSString stringWithFormat:@"%@ %@\n%@ %@ %@",_startDate,_startWeek,
                               _startTime,isEqutoTime?@"":@"~",isEqutoTime?@"":_endTime];
                }else {
                    content = [NSString stringWithFormat:@"%@ %@ %@\n%@ %@ %@",_startDate,_startWeek,_startTime,_endDate,_endWeek,_endTime];
                }
            }
            [self setUIProperty:self.titleLabel content:content spacing:Spacing];
        }
            break;


        default:{

        }
            break;
    }
}

- (void)setType:(EidtViewControllerCellType)type {
    _type = type;
    switch (_type) {
        case EidtViewControllerCellTypeArrow:
            [self arrowImageView];
            break;
        case EidtViewControllerCellTypeDelete:{
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.textColor = [UIColor redColor];
            self.titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
            self.titleLabel.font = [UIFont fontWithName:@".SFUIText" size:32];
        }
            break;

        default:
            break;
    }
}

//TODO: 计算高度。
- (void)setUIProperty:(id)view content:(id)content spacing:(CGFloat)spacing{
    UILabel *label = view;
    label.text = content;
    CGFloat textViewHeight = [label.text stringHeightWithViewWidth:(Width_Cell)-spacing*2 Font:label.font];
    label.frame = CGRectMake(Spacing, Spacing, Width_Cell, textViewHeight + spacing*2);//TextView 显示有距离
    self.rowHeight = textViewHeight + spacing*2 + Spacing * 2;
}
- (void)setDateWithEvent:(EKEvent *)event {
    NSArray *startArr = [[NSString stringWithFormat:@"%@",event.startDate] componentsSeparatedByString:@" "];
    NSArray *endArr = [[NSString stringWithFormat:@"%@",event.endDate] componentsSeparatedByString:@" "];

    self.startDate = [self stringDate:startArr[0]];
    self.endDate = [self stringDate:endArr[0]];
    self.startTime = startArr[1];
    self.endTime = endArr[1];
    self.startWeek = [startArr[0] getWeekDay];
    self.endWeek = [endArr[0] getWeekDay];

    //时间去掉秒

    self.startTime = [self.startTime substringToIndex:5];
    self.endTime = [self.endTime substringToIndex:5];
}

- (NSString *)stringDate:(NSString *)date {
    NSArray *dateArr = [date componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@年%@月%@日",dateArr[0],dateArr[1],dateArr[2]];
}

- (void)allDaySwitchEvent:(UISwitch *)sender {
    NSLog(@"%d",sender.on);
}

#pragma mark -- 懒加载
- (UITextView *)textView {
    if (_textView) return _textView;
    _textView = [UITextView new];
    _textView.font = [UIFont fontWithName:@".SFUIText" size:15];
    [self.contentView addSubview:_textView];
    return _textView;
}
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    self.titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    return _titleLabel;
}

- (UILabel *)describeLabel {
    if (_describeLabel) return _describeLabel;
    _describeLabel = [[UILabel alloc] init];
    _describeLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _describeLabel.textColor = [UIColor grayColor];
    _describeLabel.numberOfLines = 2;
    CGFloat width =[UIScreen mainScreen].bounds.size.width - Spacing - (_type==EidtViewControllerCellTypeArrow?(7+Spacing):0);
    _describeLabel.frame = CGRectMake(0, 0,width , 44);
    _describeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_describeLabel];
    return _describeLabel;
}

- (UISwitch *)allDaySwitch {
    if (_allDaySwitch) return _allDaySwitch;
    _allDaySwitch = [[UISwitch alloc] init];
    _allDaySwitch.center = self.contentView.center;
    _allDaySwitch.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 51 - Spacing, _allDaySwitch.frame.origin.y, 0, 0);
    [_allDaySwitch addTarget:self action:@selector(allDaySwitchEvent:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_allDaySwitch];
    return _allDaySwitch;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView) return _arrowImageView;
    CGFloat width = 7,height = 14;

    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    _arrowImageView.bounds = CGRectMake(0, 0, width, height);
    _arrowImageView.center = self.contentView.center;
    _arrowImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - Spacing - width, _arrowImageView.frame.origin.y, width, height);
    [self.contentView addSubview:_arrowImageView];
    return _arrowImageView;
}
@end
