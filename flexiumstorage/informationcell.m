//
//  informationcell.m
//  saptest
//  Created by flexium on 2016/10/28.
//  Copyright © 2016年 FLEXium. All rights reserved.
#import "informationcell.h"

@implementation informationcell
/** 屏幕尺寸参数 */
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _xunhao=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*1.00/4.00, 50)];
        
        _caihehao=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*1.00/4.00, 0, SCREEN_WIDTH*1.00/4, 50)];
        
        _gooqty=[[UILabel alloc]initWithFrame:CGRectMake( 2*SCREEN_WIDTH*1.00/4.00,0, SCREEN_WIDTH*1.00/4, 50)];
        
        _badqty=[[UILabel alloc]initWithFrame:CGRectMake( 3*SCREEN_WIDTH*1.00/4.00,0, SCREEN_WIDTH*1.00/4, 50)];
        
        _xunhao.textAlignment=NSTextAlignmentCenter;
        
        _caihehao.textAlignment=NSTextAlignmentCenter;
        
        _gooqty.textAlignment=NSTextAlignmentCenter;
        
        _badqty.textAlignment=NSTextAlignmentCenter;
        
        _xunhao.font=[UIFont systemFontOfSize:12.0];
        
        _caihehao.font=[UIFont systemFontOfSize:12.0];
        
        _gooqty.font=[UIFont systemFontOfSize:12.0];
        
        _badqty.font=[UIFont systemFontOfSize:12.0];
        
        [self addSubview:_xunhao];
        
        [self addSubview:_caihehao];
        
        [self addSubview:_gooqty];
        
        [self addSubview:_badqty];
        
        
    }
    
    return self;
}
//让我有了敢于追求爱情的勇气,我真的特别想努力去完成我对你的每个诺言
@end
