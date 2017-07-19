//
//  ViewController.m
//  flexiumstorage
//  Created by flexium on 2017/4/28.
//  Copyright © 2017年 FLEXium. All rights reserved.
//

#import "ViewController.h"
#import "PutinstorageViewController.h"
#import "intostoreViewController.h"
#import "outstoreViewController.h"
#import "repeatworkViewController.h"
#import "repeatworkboxViewController.h"
#import "samplingcheckViewController.h"
#import "samplingreturnViewController.h"
#import "replacestoreViewController.h"
#import "replacequalifiedViewController.h"
#import "putinstorebyQRQIANGViewController.h"
/** 屏幕尺寸参数 */
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()


@property (strong, nonatomic) IBOutlet UIButton *Putinstorage;/**<  入库按钮 */

- (IBAction)putinstoragebtn:(UIButton *)sender;/**<  入库按钮 */


@property (strong, nonatomic) IBOutlet UIButton *intostore;/**<  进储位 */

- (IBAction)intostorebtn:(UIButton *)sender;/**< 进储位 */


@property (strong, nonatomic) IBOutlet UIButton *outstore;/**< 出储位 */

- (IBAction)outstorebtn:(UIButton *)sender;/**< 出储位 */


@property (strong, nonatomic) IBOutlet UIButton *repeatwork;/**< 重工单by箱号 */

- (IBAction)repeatworkbtn:(id)sender;/**< 重工单by箱号 */

@property (strong, nonatomic) IBOutlet UIButton *repeatworkbox;/**< 重工单by彩盒 */

- (IBAction)repeatworkboxbtn:(id)sender;/**< 重工单by彩盒 */

@property (strong, nonatomic) IBOutlet UIButton *samplingcheck;/**< 抽样检查 */

- (IBAction)samplingcheckbtn:(id)sender;/**< 抽样检查 */

@property (strong, nonatomic) IBOutlet UIButton *samplingreturn;/**< 抽样归还 */

- (IBAction)samplingreturnbtn:(id)sender;/**< 抽样归还 */

@property (strong, nonatomic) IBOutlet UIButton *replacestore;/**< 更换储位 */

- (IBAction)replacestorebtn:(id)sender;/**< 更换储位 */

@property (strong, nonatomic) IBOutlet UIButton *replacequalified;/**< 出储位by不良品 */

- (IBAction)replacequalifiedbtn:(id)sender;/**< 出储位by不良品 */

- (IBAction)maiangruku:(id)sender;/**< 入库by扫描枪 */

@property (strong, nonatomic) IBOutlet UIButton *maqiangruku;/**< 入库by扫描枪 */

#define  daimai temporaryBarButtonItem.title =@"返回";temporaryBarButtonItem.tintColor=[UIColor blackColor];

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=YES;//上方标题栏
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:49.0/255.0 green:134.0/255.0 blue:251.0/255.0 alpha:1]];//背景颜色
    
}
#pragma mark 界面即将显示

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //入庫按鈕
    self.Putinstorage.layer.borderWidth = 1.0;
    self.Putinstorage.layer.borderColor = [UIColor grayColor].CGColor;
    self.Putinstorage.layer.cornerRadius=10;
    self.Putinstorage.layer.masksToBounds=YES;
    
    //入儲位
    self.intostore.layer.borderWidth = 1.0;
    self.intostore.layer.borderColor = [UIColor grayColor].CGColor;
    self.intostore.layer.cornerRadius=10;
    self.intostore.layer.masksToBounds=YES;
    
    //良品出庫
    self.outstore.layer.borderWidth = 1.0;
    self.outstore.layer.borderColor = [UIColor grayColor].CGColor;
    self.outstore.layer.cornerRadius=10;
    self.outstore.layer.masksToBounds=YES;
    
    //重工單彩盒
    self.repeatwork.layer.borderWidth = 1.0;
    self.repeatwork.layer.borderColor = [UIColor grayColor].CGColor;
    self.repeatwork.layer.cornerRadius=10;
    self.repeatwork.layer.masksToBounds=YES;
    
    //重工by箱號
    self.repeatworkbox.layer.borderWidth = 1.0;
    self.repeatworkbox.layer.borderColor = [UIColor grayColor].CGColor;
    self.repeatworkbox.layer.cornerRadius=10;
    self.repeatworkbox.layer.masksToBounds=YES;
    
    //抽樣檢查
    self.samplingcheck.layer.borderWidth = 1.0;
    self.samplingcheck.layer.borderColor = [UIColor grayColor].CGColor;
    self.samplingcheck.layer.cornerRadius=10;
    self.samplingcheck.layer.masksToBounds=YES;
    
    //抽樣歸還
    self.samplingreturn.layer.borderWidth = 1.0;
    self.samplingreturn.layer.borderColor = [UIColor grayColor].CGColor;
    self.samplingreturn.layer.cornerRadius=10;
    self.samplingreturn.layer.masksToBounds=YES;
    
    //更換儲位
    self.replacestore.layer.borderWidth = 1.0;
    self.replacestore.layer.borderColor = [UIColor grayColor].CGColor;
    self.replacestore.layer.cornerRadius=10;
    self.replacestore.layer.masksToBounds=YES;
    
    //不良出貨
    self.replacequalified.layer.borderWidth = 1.0;
    self.replacequalified.layer.borderColor = [UIColor grayColor].CGColor;
    self.replacequalified.layer.cornerRadius=10;
    self.replacequalified.layer.masksToBounds=YES;
    
    //条码枪入库
    self.maqiangruku.layer.borderWidth = 1.0;
    self.maqiangruku.layer.borderColor = [UIColor grayColor].CGColor;
    self.maqiangruku.layer.cornerRadius=10;
    self.maqiangruku.layer.masksToBounds=YES;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
  
}

#pragma mark 入库
- (IBAction)putinstoragebtn:(UIButton *)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    PutinstorageViewController *pvc=[[PutinstorageViewController alloc]init];
    
    [self.navigationController pushViewController:pvc animated:YES];
    
}

#pragma mark 进储位
- (IBAction)intostorebtn:(UIButton *)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    intostoreViewController *itsvc=[[intostoreViewController alloc]init];
    
    [self.navigationController pushViewController:itsvc animated:YES];
    
}

#pragma mark 出储位
- (IBAction)outstorebtn:(UIButton *)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    outstoreViewController *ostvc=[[outstoreViewController alloc ]init];
    
    [self.navigationController pushViewController:ostvc animated:YES];
    
}

#pragma mark 重工单（箱号）
- (IBAction)repeatworkbtn:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    repeatworkViewController *rwvc=[[repeatworkViewController alloc]init];
    
    [self.navigationController pushViewController:rwvc animated:YES];
    
    
}

#pragma mark 重工单（彩盒）
- (IBAction)repeatworkboxbtn:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    repeatworkboxViewController *rwbvc=[[repeatworkboxViewController alloc]init];
    
    [self.navigationController pushViewController:rwbvc animated:YES];
    
}

#pragma mark 抽样检查
- (IBAction)samplingcheckbtn:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    samplingcheckViewController *scvc=[[samplingcheckViewController alloc]init];
    
    [self.navigationController pushViewController:scvc animated:YES];
    
}

#pragma mark 抽样归还
- (IBAction)samplingreturnbtn:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    samplingreturnViewController *rwvc=[[samplingreturnViewController alloc]init];
    
    [self.navigationController pushViewController:rwvc animated:YES];
    
}

#pragma mark 更换储位
- (IBAction)replacestorebtn:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    replacestoreViewController *rsvc=[[replacestoreViewController alloc]init];
    
    [self.navigationController pushViewController:rsvc animated:YES];
    
}

#pragma mark 出储位by不良品
- (IBAction)replacequalifiedbtn:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    replacequalifiedViewController *rqvc=[[replacequalifiedViewController alloc]init];
    
    [self.navigationController pushViewController:rqvc animated:YES];
}

#pragma mark 網絡錯誤提示界面
-(void)intenererror{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"網絡錯誤" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"網絡錯誤"];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
    
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
}

#pragma mark 提醒界面的方法
-(void)tixing:(NSString *)str{
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"错误,且返回错误,请联系资讯解决";
        
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, len)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, len)];
    
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
   
}


#pragma mark 图片的水印
-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    NSString* mark = name;
    
    mark=locationString;
    
    NSLog(@"%@",mark);
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0,0 , w, h)];
    
    NSDictionary *attr = @{
                       
               NSFontAttributeName: [UIFont boldSystemFontOfSize:14],  //设置字体
               
               NSForegroundColorAttributeName : [UIColor redColor]   //设置字体颜色
               
                   };
    
    [mark drawInRect:CGRectMake(w -160, 10, 160, 30) withAttributes:attr]; //右上角
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
}


#pragma mark 条码枪入库
- (IBAction)maiangruku:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title =@"返回";
    
    temporaryBarButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    putinstorebyQRQIANGViewController *rsvc=[[putinstorebyQRQIANGViewController alloc]init];
    
    [self.navigationController pushViewController:rsvc animated:YES];

    
}

@end
