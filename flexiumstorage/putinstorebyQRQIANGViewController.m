//  putinstorebyQRQIANGViewController.m
//  flexiumstorage
//#import <AudioToolbox/AudioToolbox.h>
//  Created by flexium on 2017/6/8.
//  Copyright © 2017年 FLEXium. All rights reserved.
/*   AudioServicesPlaySystemSound(1014)   [self playmusics]    */

#import "putinstorebyQRQIANGViewController.h"

#import "zyscan/ZYScannerView.h"

#import "informationcell.h"

#import <AudioToolbox/AudioToolbox.h>

#import <AVFoundation/AVFoundation.h>

@interface putinstorebyQRQIANGViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

#define CEll1 @"CELL1"

@property(nonatomic,strong)AVAudioPlayer *player;

@property (strong, nonatomic) IBOutlet UILabel *tishijiemian;

@property (strong, nonatomic) IBOutlet UITableView *tableview;/**< tableview定义 */

@property (nonatomic, assign)  int tiaochu;/**< 跳出循环 */

@property (assign, nonatomic)  int qingqiutype;/**< 请求类型 */

@property (assign, nonatomic)  int zhongshu;/**< 总数量  */

@property (nonatomic, assign)  int goodzhongshu;/**< good总数量 */

@property (nonatomic, assign)  int badzhongshu;/**< bad总数量 */

@property (assign, nonatomic)  int gengxingbiaoji;/**< 更新标记使用 */

@property (nonatomic, copy) NSString *currentElement;/**< xml标记标签 */

@property (nonatomic,strong)NSString *currentElementName;/**< 对比标签 */

@property (nonatomic,assign)BOOL isCheck;/**< 对比结果比对 */

@property (nonatomic,strong)NSString *returnresult;/**< 返回结果string */

@property (nonatomic, strong) NSXMLParser *parser;/**< xml解析 */

@property (nonatomic, strong) NSXMLParser *parser2;/**< xml解析2代理 */

@property (nonatomic, strong) NSArray *peoplemessage;/**< 人员信息array */

@property (nonatomic, strong) NSMutableArray *worknomesage;/**< 工单信息array   */

@property (nonatomic, strong) NSArray *inboxmessage;/**< 內箱信息array */

@property (nonatomic, strong) NSArray *insertmessage;/**< 插入数据返回数组 */

@property (nonatomic, strong) NSMutableArray *inboxarray;/**< 外箱号码数组 */

@property (nonatomic, strong) NSMutableArray *caihearray;/**< 彩盒数组 */

@property (nonatomic, strong) NSMutableArray *allcaihemessagearray;/**< 所有彩盒数组 */

@property (nonatomic, strong) NSMutableArray *sapreturnmessagearray;/**< sap检查完成返回数据数组 */

@property (nonatomic,strong)NSString *sapreturnEXMSG;/**< sap返回的错误信息 */

@property (nonatomic, strong) NSArray *arraylist;/**< 暂时存储数组 */

@property (strong,nonatomic)UIActivityIndicatorView *testview;/**< 菊花界面 */

@property (strong, nonatomic) NSString *empno;/**< 工卡号 */

@property (strong, nonatomic) NSString *empid;/**< 工卡id */

@property (strong, nonatomic) NSString *empname;/**< 人员姓名 */

@property (strong, nonatomic) NSString *boxno;/**< 箱号外箱号码   */

@property (strong, nonatomic) NSString *storageliaohao;/**< 储位料号 */

@property (strong, nonatomic) NSString *storagechuliang;/**< 储位储量 */

@property (strong, nonatomic) NSString *storagetype;/**< 储位类型 */

@property (strong, nonatomic) NSString *storagezctype;/**< 储位的料号类型 */

@property (strong, nonatomic) IBOutlet UILabel *empnolable;/**< 工号lable */

@property (strong, nonatomic) IBOutlet UILabel *intostorageordernolable;/**< 入库单号码栏 */

@property (strong, nonatomic) IBOutlet UILabel *inboxnolable;/**< 内箱号标题栏位 */

@property (strong, nonatomic) IBOutlet UILabel *shulianglable;/**< 数量lable显示 */

@property (strong, nonatomic) IBOutlet UILabel *fanhuimessage;/**< 返回信息lable */

- (IBAction)sureupdate:(id)sender;/**< 确认上传按钮*/

@property (strong, nonatomic) IBOutlet UIButton *surebutton;/**< 确认上传 */

@property (strong, nonatomic) IBOutlet UITextField *scantext;

@property (strong, nonatomic) IBOutlet UILabel *biaoti;

@property (strong, nonatomic) NSString *sapgoodfanhui;/**< sapgoodfanhui */


@property (strong, nonatomic) NSString *Attcps;/**< 良品还是不良品 */

@property (strong, nonatomic) NSString *ExZivnos;/**< 工单号 */

@property (nonatomic, assign) int charusuoyoubiaoji;/**< 插入所有标记 */

@property (nonatomic, assign) int teshubiaoji;/**< 特殊标记 */
@property (nonatomic, assign) int teshubiaoji2;/**< teshubiaoji */
@property (nonatomic, assign) int fanhuibiaoji;/**< fanhuibiaoji */
@end

@implementation putinstorebyQRQIANGViewController

#pragma mark 界面显示前的步骤
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:49.0/255.0 green:134.0/255.0 blue:251.0/255.0 alpha:1];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
    
    
}
#pragma mark  文本输入框默认光标放在里面
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    
    //光标默认放入
    [textField resignFirstResponder];
    
    return YES;
    
}
#pragma mark 界面显示
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tiaochu=0;
    
    self.teshubiaoji=0;
    
    self.teshubiaoji2=0;
    
    self.tiaochu=0;
    
    self.biaoti.text=@"產品入庫";
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.scantext.delegate = self;
    
    [self.scantext becomeFirstResponder];
    
    self.scantext.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    //確認按鈕
    self.surebutton.layer.borderWidth = 1.0;
    
    self.surebutton.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.surebutton.layer.cornerRadius=10;
    
    self.surebutton.layer.masksToBounds=YES;
    
    //產品入庫按鈕
    self.title=@"产品入库";
    
    self.worknomesage=[[NSMutableArray alloc]init];
    
    self.inboxarray=[[NSMutableArray alloc]init];
    
    self.caihearray=[[NSMutableArray alloc]init];
    
    self.zhongshu=0;
    
    self.gengxingbiaoji=0;
    
    self.allcaihemessagearray=[[NSMutableArray alloc]init];
    
    self.sapreturnmessagearray=[[NSMutableArray alloc]init];
    
    self.tableview.delegate=self;
    
    self.tableview.dataSource=self;
    
    self.tableview.backgroundColor=[UIColor whiteColor];
    
    //隐藏下方多余的分割线。
    self.tableview.tableFooterView=[[UIView alloc] init];
    
    //下列方法的作用也是隐藏分割线。
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    
    //设置头部不可选择
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // 设置tableview的cell可以自动计算高度；
    self.tableview.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableview];

    
}


#pragma mark 内存报警
- (void)didReceiveMemoryWarning {
    
    [self tixing:@"内存已满,请关闭相关程序并检查内存打开手机" type:@"NG"];
    
    [super didReceiveMemoryWarning];
    
}
#pragma mark 掃描工卡
-(void)scanempno:(NSString *)message{
    
    [self beginjuhua];
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkemp xmlns='http://tempuri.org/'><emp>%@</emp></checkemp></soap:Body></soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength = [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkemp" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            [self intenererror];
            
            }
        else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;
            
            //这一步不能少！
            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}

#pragma mark 掃描工单带出入库单
-(void)checkinboxworksno:(NSString *)message{
    
    [self beginjuhua];
    
    NSString *urlStr = @"http://ksrv-sap-qas.flexium.local:8000/sap/bc/srt/rfc/sap/zsrpp005/888/service/binding";
    //http://ksrv-sap-qas.flexium.local:8000/sap/bc/srt/rfc/sap/zsrmm036d/888/zsrmm036d/binding
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数  600000121648
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:sap-com:document:sap:soap:functions:mc-style'><soapenv:Header/><soapenv:Body> <urn:Zfpp012><ImAufnr>%@</ImAufnr></urn:Zfpp012></soapenv:Body></soapenv:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/Zfpp012" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
            }
        
        else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;
            
            //这一步不能少
            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
    
}


#pragma mark 掃描工单
-(void)checkworkno:(NSString *)message{
    
    [self beginjuhua];
    
    NSString *urlStr = @"http://ksrv-sap-qas.flexium.local:8000/sap/bc/srt/rfc/sap/zsrpp005/888/service/binding";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数  600000121648
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:sap-com:document:sap:soap:functions:mc-style'>  <soapenv:Header/> <soapenv:Body>  <urn:Zfpp007><ImWerks>2011</ImWerks><ImZivno>%@</ImZivno><TabItem><item><Aufnr></Aufnr><Attcp></Attcp><Lgort></Lgort><Bdmng></Bdmng></item> </TabItem></urn:Zfpp007> </soapenv:Body></soapenv:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/Zfpp007" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      
        {
            
        if (error)
            {
            
                NSLog(@"请求数据出错!----%@",error.description);
                
                [self intenererror];
            
            }
        else
            {
            
                self.parser=[[NSXMLParser alloc]initWithData:data];
                
                NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",result);
                
                //添加代理
                self.parser.delegate=self;
                
                //这一步不能少！
                self.parser.shouldResolveExternalEntities=true;
                
                //开始解析Flexiumcn\miracle_zhang 
                [self.parser parse];
            
            }
        
    }];
    
    // 6.开启请求数据
    [dataTask resume];
    
}
#pragma mark 掃描彩盒
-(void)checkinbox:(NSString *)message{
    
    [self beginjuhua];
    
    self.teshubiaoji=0;
    
    self.teshubiaoji2=0;
    
    self.scantext.enabled=NO;
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostorages.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkinboxno xmlns='http://tempuri.org/'> <inboxno>%@</inboxno></checkinboxno></soap:Body></soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkinboxno" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
             {
        
                NSLog(@"请求数据出错!----%@",error.description);
                
                [self intenererror];
            
             }
        
        else {
            
                self.parser=[[NSXMLParser alloc]initWithData:data];
            
                NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",result);
                //添加代理
                self.parser.delegate=self;
                
                //这一步不能少！
                self.parser.shouldResolveExternalEntities=true;
                
                //开始解析
                [self.parser parse];
            
             }
        }];
    
    // 6.开启请求数据
    [dataTask resume];
}


#pragma mark 工单入库
-(void)workintostoragesap:(NSString *)message{
    
    [self endjuhua];
    
    //开始菊花界面02131666021
    [self beginjuhua];
    
    //请求地址ksrv-sap-qas.flexium.local
    NSString *urlStr = @"http://ksrv-sap-qas.flexium.local:8000/sap/bc/srt/rfc/sap/zsrpp005/888/service/binding";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数  600000121648
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:sap-com:document:sap:soap:functions:mc-style'> <soapenv:Header/> <soapenv:Body><urn:Zfpp005><ImChe></ImChe><ImMode></ImMode><ImSingle>X</ImSingle><ImWerks>2011</ImWerks><TabList> <item><Werks></Werks> <ModiNo></ModiNo><SapWorkNo></SapWorkNo> <WorkNo></WorkNo><ModiDt></ModiDt><ApvDt></ApvDt> <Seq></Seq><MtrlId></MtrlId> <StockId></StockId> <GoodQty></GoodQty><BadQty></BadQty><BadStockId></BadStockId><ToSap></ToSap> <Mblnr></Mblnr> <Result></Result><Error></Error> <WorkState></WorkState><SlipNo></SlipNo><EstPdtQty></EstPdtQty> <EstStartDt></EstStartDt><BthNo></BthNo><EstEndDt></EstEndDt><Prueflos></Prueflos><OutSw></OutSw><ToErp></ToErp> <Mesg></Mesg> <Ws4Status></Ws4Status><StationId></StationId><SubStation></SubStation></item></TabList> <TabZivno>  <item> <Zivno>%@</Zivno> </item> </TabZivno>  </urn:Zfpp005> </soapenv:Body></soapenv:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=[NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/Zfpp005" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
            {
                
                NSLog(@"请求数据出错!----%@",error.description);
                
                [self tixing:error.description type:@"NG"];
                
            }
        else {
            
                self.parser2=[[NSXMLParser alloc]initWithData:data];
                
                NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",result);
                
                //添加代理
                self.parser2.delegate=self;
                
                //这一步不能少！
                self.parser2.shouldResolveExternalEntities=true;
                //开始解析
                [self.parser2 parse];
                //结束菊花界面
                [self endjuhua];
             }
        }];
    
    // 6.开启请求数据
    [dataTask resume];
}
#pragma mark 更新mes数据
-(void)updatemes:(NSString *)message{

    [self beginjuhua];
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostorages.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><insertstoreage xmlns='http://tempuri.org/'><ORDERNO>%@</ORDERNO> <userid>%@</userid> <INBOXNO>%@</INBOXNO> </insertstoreage> </soap:Body></soap:Envelope>",self.intostorageordernolable.text,self.peoplemessage[2],message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/insertstoreage" forHTTPHeaderField:@"Action"];
    
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            
        if (error)
            {
                NSLog(@"请求数据出错!----%@",error.description);
                
                [self tixing:error.description type:@"NG"];
                
            }
        else {
            
                self.parser=[[NSXMLParser alloc]initWithData:data];
                
                NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",result);
            
                //添加代理
                self.parser.delegate=self;
            
                //这一步不能少！
                self.parser.shouldResolveExternalEntities=true;
            
                //开始解析
                [self.parser parse];
            
                //结束菊花
                [self endjuhua];
            
            }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
}

#pragma mark 遍历查找xml中文件的元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    _currentElementName = elementName;
    
    if ([_currentElementName isEqualToString:@"checkempResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"Aufnr"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"Attcp"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"Lgort"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"Bdmng"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"checkinboxnoResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if([_currentElementName isEqualToString:@"insertstoreageResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if([_currentElementName isEqualToString:@"ExMblnr"]&&_qingqiutype==3) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if([_currentElementName isEqualToString:@"ExMsg"]&&_qingqiutype==3) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
    
    if([_currentElementName isEqualToString:@"ExZivno"]&&_qingqiutype==1) {
        
        _isCheck = true;
        
        _returnresult = @"";
    }
}

#pragma mark 把第一个代理中我们要找的信息存储在currentstring中并把要找的信息空格和换行符号去除
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //检查工号
    if ([_currentElementName isEqualToString:@"checkempResult"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        self.peoplemessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    //sap返回工單信息
    if ([_currentElementName isEqualToString:@"ExZivno"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        self.ExZivnos=[self.returnresult copy];
        //        [self.worknomesage addObject:_returnresult] ;
    }
    
    //sap返回工單信息
    if ([_currentElementName isEqualToString:@"Aufnr"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        [self.worknomesage addObject:_returnresult] ;
    }
    
    if ([_currentElementName isEqualToString:@"Attcp"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.Attcps=_returnresult;
        //        [self.worknomesage addObject:_returnresult] ;
    }
    
    if ([_currentElementName isEqualToString:@"Lgort"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        [self.worknomesage addObject:_returnresult] ;
    }
    
    if ([_currentElementName isEqualToString:@"Bdmng"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        if ([self.Attcps isEqualToString:@"G"]) {
                [self.worknomesage addObject:_returnresult] ;//总数量
                [self.worknomesage addObject:@"0"] ;//不良品
                [self.worknomesage addObject:_returnresult] ;//良品
            
            }
        else{
                [self.worknomesage addObject:_returnresult] ;//总数量
                [self.worknomesage addObject:_returnresult] ;//不良品
                [self.worknomesage addObject:@"0"] ;//良品
            }
        
        
    }
    
    //检查彩盒
    if ([_currentElementName isEqualToString:@"checkinboxnoResult"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        self.inboxmessage= [self.returnresult componentsSeparatedByString:@";"];
        
        NSLog(@"%@",self.inboxmessage);
        
    }
    
    //插入储位表
    if([_currentElementName isEqualToString:@"insertstoreageResult"]) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        self.insertmessage= [self.returnresult componentsSeparatedByString:@";"];
        
        
    }
    
    //mes返回
    if([_currentElementName isEqualToString:@"ExMblnr"]&&_qingqiutype==3) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        [self.sapreturnmessagearray addObject:_returnresult] ;
        
        self.sapgoodfanhui=[_returnresult copy];
        
    }
    
    //mes返回
    if([_currentElementName isEqualToString:@"ExMsg"]&&_qingqiutype==3) {
        
        _isCheck = true;
        
        _returnresult =[_returnresult stringByAppendingString:string] ;
        
        NSLog(@"%@",_returnresult);
        
        self.sapreturnEXMSG=[_returnresult copy];
        
    }
    
}

#pragma mark 把上部的信息存储到数据中
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
}
#pragma mark 解析结束数据
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [[NSThread currentThread] cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //结束菊花
        [self endjuhua];
        
        [self.surebutton setEnabled:true];
        
        [self.surebutton setBackgroundColor:[UIColor colorWithRed:76.0/225 green:175.0/225 blue:210.0/225 alpha:1]];
        
        self.scantext.text=nil;
        
        [self.view endEditing:YES];
        
        self.scantext.enabled=YES;
        
        [self.scantext becomeFirstResponder];
        
        //1.掃描工號
        if (_qingqiutype==0) {
            
            if ( [self.peoplemessage[0] isEqualToString:@"OK"]) {
                
                _qingqiutype=1;
                
                self.tishijiemian.text=@"掃描工单號" ;
                
                self.empnolable.text=self.peoplemessage[1];
                
                self.empid=self.peoplemessage[2];
                
                self.empno=self.peoplemessage[1];
                
                self.empname=self.peoplemessage[3];
                
                AudioServicesPlaySystemSound(1002);//1002
                
                self.fanhuimessage.textColor=[UIColor blackColor];
                
                self.fanhuimessage.text=@"插入成功";

                
                }
            else{
                
                 [self tixing:self.peoplemessage[1] type:@"NG"];
                
            }
        }
        //2.掃描工单編號
        else if(_qingqiutype==1){
            
            [self endjuhua];
            
            if (_ExZivnos.length>4) {
                
                    _qingqiutype=5;
                    
                    [self checkworkno:_ExZivnos];
                    
                    self.intostorageordernolable.text=_ExZivnos;
                    
                }
            else{
                 self.tishijiemian.text=@"掃描工單號" ;
                
                self.intostorageordernolable.text=@"未查詢到該料號對應的入庫單或對應工單已過賬";
                
                [self tixing:@"未查詢到該料號對應的入庫單或對應工單已過賬" type:@"NG"];
                
            }
        }
        
         //返回工单信息
        else if(_qingqiutype==5)
        {
            
            [self endjuhua];
            
            if (_worknomesage.count>2) {
                
                NSLog(@"workmessage:%@",_worknomesage);
                
                self.qingqiutype=2;
                
                self.zhongshu=0;
                
                self.goodzhongshu=0;
                
                self.badzhongshu=0;
                
                for(int i=0;i<_worknomesage.count/5;i++){
                    
                    _zhongshu=_zhongshu+[_worknomesage[5*i+2] intValue];
                    
                    _goodzhongshu=_goodzhongshu+[_worknomesage[5*i+4]intValue];
                    
                    _badzhongshu=_badzhongshu+[_worknomesage[5*i+3]intValue];
                    
                    
                }
                
                self.shulianglable.text=[NSString stringWithFormat:@"總:0/%d\n 良:0/%d \n不良:0/%d",self.zhongshu,self.goodzhongshu,_badzhongshu];
                
                AudioServicesPlaySystemSound(1002);
                self.fanhuimessage.textColor=[UIColor blackColor];
                self.fanhuimessage.text=@"插入成功";

                  self.tishijiemian.text=@"掃描彩盒號" ;
            }
            else{
                
                  self.tishijiemian.text=@"掃描工單編號" ;
                
                [self tixing:@"该工单无信息或已经完结,请重新操作或查询工单信息是否正确" type:@"NG"];
                
                self.qingqiutype=1;
                
                
                NSLog(@"该工单无信息或已经完结");
                
            }
            
        }
        
        
//3.掃描彩盒號解析
        else if(_qingqiutype==2){
            
            NSLog(@"inboxmessage:%@",_inboxmessage);
            
            if (self.inboxmessage.count>3) {
                
                //这里显示总数据统计的数量
                int saomiaoshulaing=0;
                
                int goodshuliang=0;
                
                int badshuliang=0;
                
                for (int i=0; i<self.inboxarray.count; i++) {
                    
                    saomiaoshulaing=saomiaoshulaing+[self.inboxarray[i][4] intValue]+[self.inboxarray[i][5]intValue];
                    
                    goodshuliang=goodshuliang+[self.inboxarray[i][4] intValue];
                    
                    badshuliang=badshuliang+[self.inboxarray[i][5] intValue];
                }
                self.shulianglable.text=[NSString stringWithFormat:@"總:%d/%d \n良:%d/%d \n 不良:%d/%d",saomiaoshulaing,self.zhongshu,goodshuliang,self.goodzhongshu,badshuliang,_badzhongshu];
                
                if (self.goodzhongshu<(goodshuliang+[self.inboxmessage[4]intValue])) {
                    
                    self.shulianglable.textColor=[UIColor redColor];
                    
//                    [self tixing:@"工單良品數量預加已滿無法掃描加入請確認彩盒信息或工單信息" type:@"NG"];
                    [self liaohaocuowu:@"工單良品數量預加已滿無法掃描加入請確認彩盒信息或工單信息"];
                    self.gengxingbiaoji=0;
                    
                    [self.tableview reloadData];
                    
                }
                
                else if(self.badzhongshu<(badshuliang+[self.inboxmessage[5]intValue]))
                {
                    
                    self.shulianglable.textColor=[UIColor redColor];
                    
//                    [self tixing:@"工單不良數量預加已滿無法掃描加入請確認彩盒信息或工單信息" type:@"NG"];
                    [self liaohaocuowu:@"工單不良數量預加已滿無法掃描加入請確認彩盒信息或工單信息"];
                    self.gengxingbiaoji=0;
                    
                    [self.tableview reloadData];
                    
                }
                
                else{
                    
                    NSLog(@"%@",_caihearray);
                    
                    if(_allcaihemessagearray.count>=1){
                        
                        for (int p=0; p<self.caihearray.count; p++) {
                            
                            if ([self.allcaihemessagearray[p][0] isEqualToString:self.inboxnolable.text])
                            {
                                
//                                [self tixing:@"该彩盒已经扫描禁止重复扫描" type:@"NG"];
                                [self liaohaocuowu:@"该彩盒已经扫描禁止重复扫描"];
                                break;
                                
                            }
                            if (p==self.allcaihemessagearray.count-1) {
                                //重要信息﹣﹣﹣﹣﹣﹣﹣﹣判斷工單的同時判斷储位good判断﹣﹣﹣﹣﹣﹣﹣
                                
                                if([self.inboxmessage[4] intValue]>0){
                                    for (int i=0; i<_worknomesage.count-1; i++) {
                                        /*******************************/
                                        if ([_worknomesage[i] isEqualToString:self.inboxmessage[1]]&&([_worknomesage[i+1] isEqualToString:self.inboxmessage[7]])) {
                                            self.teshubiaoji=1;
                                            self.teshubiaoji2=1;
                                            //添加到彩盒数组
                                            NSLog(@"%@",self.inboxmessage);
                                            
                                            [_caihearray addObject:self.inboxmessage[0]];
                                            
                                            NSMutableArray * inboxmessagessarray=[[NSMutableArray alloc]init];
                                            [inboxmessagessarray addObjectsFromArray:[self.inboxmessage copy]];
                                            
                                            if (_charusuoyoubiaoji==0) {
                                                [self.allcaihemessagearray insertObject:[inboxmessagessarray copy] atIndex:self.allcaihemessagearray.count];
                                                self.charusuoyoubiaoji=1;
                                                 AudioServicesPlaySystemSound(1002);//1002
                                                self.fanhuimessage.textColor=[UIColor blackColor];
                                                self.fanhuimessage.text=@"插入成功";
                                            }
                                            
                                            
                                            [inboxmessagessarray removeObjectAtIndex:8];
                                            [inboxmessagessarray replaceObjectAtIndex:5 withObject:@"0"];
                                            
                                            NSLog(@"%@",self.allcaihemessagearray);
                                            
                                            if (_inboxarray.count==0) {
                                                
                                                [_inboxarray insertObject:inboxmessagessarray atIndex:0];
                                                
                                                break;
                                                
                                            }
                                            else{
                                                
                                                //返回的内向信息
                                                
                                                for (int s=0; s<_inboxarray.count; s++) {
                                                    
                                                    NSLog(@"allcaihemessagearray1111:%@",self.allcaihemessagearray);
                                                    
                                                    NSLog(@"inboxarray：%@",_inboxarray[s]);
                                                    
                                                    /***************************************************************/
                                                    
                                                    if ([_inboxarray[s][1]isEqualToString:self.inboxmessage[1]]&&[_inboxarray[s][7]isEqualToString:self.inboxmessage[7]]) {
                                                        
                                                        self.fanhuibiaoji=s;
                                                        NSLog(@"11111111:%@,%@",_inboxarray[s][4],inboxmessagessarray[4] );
                                                        
                                                        NSString *GOODS=[NSString stringWithFormat:@"%d",([_inboxarray[s][4] intValue]+[inboxmessagessarray[4] intValue])];
                                                        
                                                        NSString *BADS=[NSString stringWithFormat:@"%d",0];
                                                        
                                                        NSLog(@"%@,%@",GOODS,BADS);
                                                        
                                                        NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.inboxarray[s] copyItems:YES];
                                                        
                                                        [newArray replaceObjectAtIndex:4 withObject:GOODS];
                                                        
                                                        [newArray replaceObjectAtIndex:5 withObject:BADS];
                                                        
                                                        [self.inboxarray replaceObjectAtIndex:s withObject:newArray];
                                                        
                                                        NSLog(@"allcaihemessagearray2222:%@",self.allcaihemessagearray);
                                                        
                                                        break;
                                                        
                                                    }
                                                    
                                                    NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                                    
                                                    if(s==_inboxarray.count-1){
                                                        [self.inboxarray insertObject:inboxmessagessarray atIndex:s+1];
                                                        
                                                        break;
                                                        
                                                    }
                                                    
                                                    NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                                    
                                                }
                                                
                                            }
                                            
                                            break;
                                        }
                                        
                                        if ((i==_worknomesage.count-2)&&(self.teshubiaoji==0)) {
                                            
//                                            [self tixing:@"该彩盒工单号与入库单工单号不匹配或储位不匹配无法加入" type:@"NG"];
                                            [self liaohaocuowu:@"该彩盒工单号与入库单工单号不匹配或储位不匹配无法加入"];
                                            self.teshubiaoji=0;
                                            break;
                                            
                                        }
                                    }
                                }
                                if([self.inboxmessage[5] intValue]>0){
                                    self.teshubiaoji=0;
                                    //重要信息﹣﹣﹣﹣﹣﹣﹣﹣判斷工單的同時判斷储位bad判断﹣﹣﹣﹣﹣﹣﹣
                                    
                                    for (int i=0; i<_worknomesage.count-1; i++) {
                                        /*******************************/
                                        if ([_worknomesage[i] isEqualToString:self.inboxmessage[1]]&&([_worknomesage[i+1] isEqualToString:self.inboxmessage[8]])) {
                                            
                                            
                                            self.teshubiaoji=1;
                                            
                                            //添加到彩盒数组
                                            NSLog(@"%@",self.inboxmessage);
                                           
                                            [_caihearray addObject:self.inboxmessage[0]];
                                            
                                            NSMutableArray * inboxmessagessarray=[[NSMutableArray alloc]init];
                                            [inboxmessagessarray addObjectsFromArray:[self.inboxmessage copy]];
                                            
                                            if(_charusuoyoubiaoji==0){
                                                [self.allcaihemessagearray insertObject:inboxmessagessarray atIndex:self.allcaihemessagearray.count];
                                                 AudioServicesPlaySystemSound(1002);//1002
                                                self.fanhuimessage.textColor=[UIColor blackColor];
                                                self.fanhuimessage.text=@"插入成功";

                                            }
                                            
                                            [inboxmessagessarray removeObjectAtIndex:(7)];
                                            
                                            [inboxmessagessarray replaceObjectAtIndex:4 withObject:@"0"];
                                            
                                            
                                            NSLog(@"%@",self.allcaihemessagearray);
                                            
                                            if (_inboxarray.count==0) {
                                                
                                                [_inboxarray insertObject:inboxmessagessarray atIndex:0];
                                                
                                                break;
                                                
                                            }
                                            else{
                                                
                                                //返回的内向信息
                                                
                                                for (int s=0; s<_inboxarray.count; s++) {
                                                    
                                                    NSLog(@"allcaihemessagearray1111:%@",self.allcaihemessagearray);
                                                    
                                                    NSLog(@"inboxarray：%@",_inboxarray[s]);
                                                    
                                                    /***************************************************************/
                                                    
                                                    if ([_inboxarray[s][1]isEqualToString:self.inboxmessage[1]]&&[_inboxarray[s][7]isEqualToString:self.inboxmessage[8]]) {
                                                        NSLog(@"11111111:%@,%@",_inboxarray[s][4],inboxmessagessarray[4] );
                                                        
                                                        NSString *GOODS=[NSString stringWithFormat:@"%d",0];
                                                        
                                                        NSString *BADS=[NSString stringWithFormat:@"%d",([_inboxarray[s][5] intValue]+[inboxmessagessarray[5] intValue])];
                                                        
                                                        NSLog(@"%@,%@",GOODS,BADS);
                                                        
                                                        NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.inboxarray[s] copyItems:YES];
                                                        
                                                        [newArray replaceObjectAtIndex:4 withObject:GOODS];
                                                        
                                                        [newArray replaceObjectAtIndex:5 withObject:BADS];
                                                        
                                                        [self.inboxarray replaceObjectAtIndex:s withObject:newArray];
                                                        
                                                        NSLog(@"allcaihemessagearray2222:%@",self.allcaihemessagearray);
                                                        
                                                        break;
                                                        
                                                    }
                                                    
                                                    NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                                    
                                                    if(s==_inboxarray.count-1){
                                                        [self.inboxarray insertObject:inboxmessagessarray atIndex:s+1];
                                                        
                                                        break;
                                                        
                                                    }
                                                    
                                                    NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                                    
                                                }
                                                
                                            }
                                            
                                            break;
                                        }
                                        
                                        if ((i==_worknomesage.count-2)&&(self.teshubiaoji==0)) {
                                            
                                            if (_teshubiaoji2==1) {
                                                 [self.allcaihemessagearray removeObjectAtIndex:(self.allcaihemessagearray.count-1)];
                                            }
                                          
                                            
                                            if ([self.inboxmessage[4] intValue]>0&&self.teshubiaoji2==1) {
                                                NSMutableArray * inboxmessagessarray=[[NSMutableArray alloc]init];
                                                [inboxmessagessarray addObjectsFromArray:[self.inboxmessage copy]];
                                                NSString *GOODS=[NSString stringWithFormat:@"%d",([_inboxarray[self.fanhuibiaoji][4] intValue]-[inboxmessagessarray[4] intValue])];
                                                
                                                NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.inboxarray[self.fanhuibiaoji] copyItems:YES];
                                                
                                                [newArray replaceObjectAtIndex:4 withObject:GOODS];
                                                
                                               
                                                AudioServicesPlaySystemSound(1002);//1002
                                                
                                                self.fanhuimessage.textColor=[UIColor blackColor];
                                                self.fanhuimessage.text=@"插入成功";

                                                [self.inboxarray replaceObjectAtIndex:_fanhuibiaoji withObject:newArray];
                                                

                                            }
                                            
//                                            [self tixing:@"该彩盒工单号与入库单工单号不匹配或储位不匹配无法加入" type:@"NG"];
                                            [self liaohaocuowu:@"该彩盒工单号与入库单工单号不匹配或储位不匹配无法加入"];
                                            self.teshubiaoji=0;
                                            NSLog(@"%@",_inboxarray);
                                            NSLog(@"%@",_caihearray);
                                            break;
                                            
                                        }
                                    }
                                }
                                break;
                            }
                        }
                    }
                    
                    
                    
            else{
                        
                        self.teshubiaoji2=0;
                        
                        self.teshubiaoji=0;
                        
                        //工单信息
                        for (int i=0; i<_worknomesage.count-1; i++) {
                            NSLog(@"%d,%d",[self.inboxmessage[4]intValue],[self.inboxmessage[5] intValue]);
                            /***************************GOODQTY*********************************/
                            if ([self.inboxmessage[4] intValue]>0) {
                                
                                if ([_worknomesage[i] isEqualToString:self.inboxmessage[1]]&&([_worknomesage[i+1] isEqualToString:self.inboxmessage[7]])) {
                                    
                                    
                                    self.teshubiaoji=1;
//                                    self.teshubiaoji2=1;
                                    
                                    //添加到彩盒数组
                                    [_caihearray addObject:self.inboxmessage[0]];
                                    
                                    NSLog(@"SELF.INBOXMESSAGE:%@",self.inboxmessage);
                                    
                                    NSMutableArray * inboxarray=[[NSMutableArray alloc]init];
                                    //                            [inboxarray addObject:_inboxmessage];
                                    [inboxarray addObjectsFromArray:_inboxmessage];
                                    //                            inboxarray=[_inboxmessage copy];
                                    NSLog(@"inboxarray:%@",inboxarray);
                                    
                                    
                                    NSLog(@"inboxarray:%@",inboxarray[8]);
                                    [self.allcaihemessagearray insertObject:[inboxarray copy]atIndex:self.allcaihemessagearray.count];
                                    
                                    AudioServicesPlaySystemSound(1002);//1002
                                    self.fanhuimessage.textColor=[UIColor blackColor];
                                    self.fanhuimessage.text=@"插入成功";

                                    
                                    self.charusuoyoubiaoji=1;
                                    
                                    [inboxarray removeObjectAtIndex:8];
                                    [inboxarray replaceObjectAtIndex:5 withObject:@"0"];
                                    NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                    
                                    
                                    NSLog(@"%@",self.inboxmessage);
                                    
                                    if (_inboxarray.count==0) {
                                        
                                        [_inboxarray insertObject:inboxarray atIndex:0];
                                        
                                        //                                break;
                                        
                                    }
                                    else{
                                        
                                        //返回的内向信息
                                        for (int s=0; s<_inboxarray.count; s++) {
                                            
                                            NSLog(@"inboxarray：%@,inboxmessage:%@",_inboxarray[s],self.inboxmessage);
                                            //                                    NSLog(@"inboxarray：%@",_inboxarray[s]);
                                            /*****************11111111111111111111111111111*******************************/
                                            //这里说明原来统计数组里面就有，要在里面加算插入
                                            if ([_inboxarray[s][1]isEqualToString:self.inboxmessage[1]]&&[_inboxarray[s][7]isEqualToString:self.inboxmessage[7]]) {
                                                
                                                self.inboxarray[s][4]=[NSString stringWithFormat:@"%d",[_inboxarray[s][4] intValue]+[self.inboxmessage[4]intValue]];
                                                
                                                //                                        _inboxarray[s][5]=[NSString stringWithFormat:@"%d",[_inboxarray[s][5] intValue]+[self.inboxmessage[5] intValue]];
                                                
                                                NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                                
                                                break;
                                                
                                            }
                                            NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                            
                                            if(s==_inboxarray.count-1){
                                                [_inboxarray insertObject:inboxarray atIndex:s+1];
                                                
                                                //                                        break;
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    //                            break;
                                }
                            }
                            
                            
                            /*************************BADQTY***********12345678*********************************/
                            if([self.inboxmessage[5] intValue]>0){
                                
                                if ([_worknomesage[i] isEqualToString:self.inboxmessage[1]]&&([_worknomesage[i+1] isEqualToString:self.inboxmessage[8]])) {
                                    
                                    self.teshubiaoji2=1;
                                    
                                    
                                    //添加到彩盒数组
                                    [_caihearray addObject:self.inboxmessage[0]];
                                    
                                    NSLog(@"%@",self.inboxmessage);
                                    
                                    NSMutableArray *inboxarray=[[NSMutableArray alloc]init];
                                    [inboxarray addObjectsFromArray:_inboxmessage];
                                    
                                    if (self.charusuoyoubiaoji==0) {
                                         AudioServicesPlaySystemSound(1002);//1002
                                        self.fanhuimessage.textColor=[UIColor blackColor];
                                        self.fanhuimessage.text=@"插入成功";

                                        [self.allcaihemessagearray insertObject:inboxarray atIndex:self.allcaihemessagearray.count];
                                    }
                                    
                                    [inboxarray removeObjectAtIndex:7];
                                    [inboxarray replaceObjectAtIndex:4 withObject:@"0"];
                                    
                                    NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                    
                                    NSLog(@"%@",self.inboxmessage);
                                    
                                    if (_inboxarray.count==0) {
                                        
                                        [_inboxarray insertObject:inboxarray atIndex:0];
                                        
                                        break;
                                        
                                    }
                                    else{
                                        
                                        //返回的内向信息
                                        for (int s=0; s<_inboxarray.count; s++) {
                                            
                                            NSLog(@"inboxarray：%@,inboxmessage:%@",_inboxarray[s],self.inboxmessage);
                                            /*****************11111111111111111111111111111*******************************/
                                            //这里说明原来统计数组里面就有，要在里面加算插入
                                            if ([_inboxarray[s][1]isEqualToString:self.inboxmessage[1]]&&[_inboxarray[s][7]isEqualToString:self.inboxmessage[8]]) {
                                                
                                                _inboxarray[s][5]=[NSString stringWithFormat:@"%d",[_inboxarray[s][5] intValue]+[self.inboxmessage[5] intValue]];
                                                
                                                NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                                
                                                break;
                                                
                                            }
                                            NSLog(@"allcaihemessagearray:%@",self.allcaihemessagearray);
                                            
                                            if(s==_inboxarray.count-1){
                                                [_inboxarray insertObject:inboxarray atIndex:s+1];
                                                
                                                break;
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    break;
                                }
                                
                                
                            }
                            
                            
                            if (((i==_worknomesage.count-2)&&(self.teshubiaoji==1&&self.teshubiaoji2==0&&[self.inboxmessage[5] intValue]>0))||((i==_worknomesage.count-2)&&(self.teshubiaoji==0&&self.teshubiaoji2==0&&[self.inboxmessage[4] intValue]>0))) {
                                
                                
                                [self.allcaihemessagearray removeAllObjects];
                                [self.inboxarray removeAllObjects];
                                [self.caihearray removeAllObjects];
                                NSLog(@"%@",_inboxarray);
                                NSLog(@"%@",_caihearray);
                                [self tixing:@"该彩盒工单号与入库单工单号不匹配或储位不匹配无法加入" type:@"NG"];
                                self.teshubiaoji=0;
                                
                                break;
                                
                            }

                        }
                    }
                    int saomiaoshulaing=0;
                    
                    int goodshuliangs=0;
                    
                    int badshuliangs=0;
                    
                    for (int i=0; i<self.inboxarray.count; i++) {
                        
                        saomiaoshulaing=saomiaoshulaing+[self.inboxarray[i][4] intValue]+[self.inboxarray[i][5]intValue];
                        
                        goodshuliangs=goodshuliangs+[self.inboxarray[i][4] intValue];
                        
                        badshuliangs=badshuliangs+[self.inboxarray[i][5] intValue];
                        
                    }
                    
                        NSLog(@"%@",self.inboxarray);
                        
                        self.shulianglable.text=[NSString stringWithFormat:@"總:%d/%d \n良:%d/%d \n 不良:%d/%d",saomiaoshulaing,self.zhongshu,goodshuliangs,self.goodzhongshu,badshuliangs,_badzhongshu];
                        
                        self.shulianglable.textColor=[UIColor blackColor];
                        
                        self.gengxingbiaoji=0;
                        
                        [self.tableview reloadData];
                        
                        self.gengxingbiaoji=0;
                        
                        [self.tableview reloadData];
                        
                        [self.tableview bringSubviewToFront:self.view];
                        
                        [self.scantext becomeFirstResponder];
                    }
                    
                }
            else{
                
//                [self tixing:self.inboxmessage[self.inboxmessage.count-1] type:@"NG"];
                [self liaohaocuowu:self.inboxmessage[self.inboxmessage.count-1]];
                self.qingqiutype=2;
                
                self.tishijiemian.text=@"掃描彩盒號";
                
                [self.scantext becomeFirstResponder];
                
            }
            
        }
        
        
    
        
        if(_qingqiutype==3){
            
            [self endjuhua];
            
            self.biaoti.text=@"產品入庫";
            
            self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
            
            NSLog(@"######请注意....请注意########SAP返回:%@,正常:%@,錯誤返回:%@",_sapreturnmessagearray,self.sapgoodfanhui,self.sapreturnEXMSG);
            
            if (self.sapgoodfanhui.length<1) {

                [self tixing:[NSString stringWithFormat:@"%@%@",self.sapreturnEXMSG,_sapgoodfanhui] type:@"NG"];
                
                self.fanhuimessage.text=[NSString stringWithFormat:@"%@:%@",self.sapreturnEXMSG,_sapgoodfanhui];
                
            }
            //成功
            else{
                //如果更新成功插入数据库
                NSString * caihejihe=@"";
                
                if (_allcaihemessagearray.count>1) {
                    
                    
                    if (_allcaihemessagearray.count>1) {
                        
                        for(int i=0;i<_allcaihemessagearray.count;i++){
                            
                            if (i==0) {
                                
                                caihejihe=[NSString stringWithFormat:@"'%@'",self.allcaihemessagearray[i][0]];
                                
                            }
                            else{
                                
                                caihejihe=[NSString stringWithFormat:@"%@,'%@'",caihejihe,self.allcaihemessagearray[i][0]];
                                
                            }
                        }
                    }

                }
                
                NSLog(@"%@",caihejihe);
                
                //过账成功，更新mes的数据。
                _qingqiutype=4;
                
                [self updatemes:caihejihe];
                
                NSLog(@"%@",caihejihe);
                
            }
        }
        //插入mes数据库
        else if(_qingqiutype==4){
            
            if([self.insertmessage[0]isEqualToString:@"OK"]){
                
                 _qingqiutype=0;
                
                 self.tishijiemian.text=@"掃描工卡" ;
                
                [self tixing:self.insertmessage[1] type:@"OK"];
                
                [self qingkongallshuju];

            }
            else{
                
                _qingqiutype=0;
                
                self.tishijiemian.text=@"掃描工卡" ;
                
                [self tixing:self.insertmessage[1] type:@"NG"];
                
            }
        }
    });
}

#pragma mark 網絡錯誤提示界面

-(void)intenererror{
    
    [self endjuhua];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"網絡錯誤,請聯繫61332" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"網絡錯誤,請聯繫61332"];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 13)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 13)];
    
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
}

#pragma mark 提醒界面的方法
-(void)tixing:(NSString *)str type:(NSString *)type{
    
    [self endjuhua];
    
    [self.surebutton setEnabled:true];
    
    [self.surebutton setBackgroundColor:[UIColor colorWithRed:76.0/225 green:175.0/225 blue:210.0/225 alpha:1]];
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"未知錯誤(返回錯誤內容為空),請聯繫資訊解決:61353";
        
        len=[str length];
        
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    if([type isEqualToString:@"OK"])
        {
        
            [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, len)];
            
            AudioServicesPlaySystemSound(1002);//1014
            
            self.fanhuimessage.textColor=[UIColor blackColor];
            
            self.fanhuimessage.text=@"插入成功";
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
        
            }
        else{
            
               [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, len)];
            
              [self playmusics];//1002
            
               AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            
            }
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, len)];
    
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
}
#pragma mark 建立并开始菊花界面请求
-(void)beginjuhua{
    
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    
    [testActivityIndicator setFrame :CGRectMake(100, 200, 100, 100)];//不建议这样设置，因为
    
    [self.view addSubview:testActivityIndicator];
    
    testActivityIndicator.color = [UIColor greenColor]; // 改变圈圈的颜色为红色； iOS5引入
    
    [testActivityIndicator startAnimating]; // 开始旋转
    
    self.testview=testActivityIndicator;
    
    [self.testview bringSubviewToFront:self.view];
    

}
#pragma mark 结束并移除菊花界面
-(void)endjuhua{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_testview stopAnimating]; // 结束旋转
        
        [_testview removeFromSuperview]; //当旋转结束时移除
        
    });
}

#pragma 下列方法为tableview方法实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
#pragma mark 有多少行cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allcaihemessagearray.count;
}
#pragma mark cell顯示內容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    informationcell *cell1=[tableView dequeueReusableCellWithIdentifier:CEll1];
    
    if (cell1 ==nil)
        
        {
        
            cell1=[[[NSBundle mainBundle]loadNibNamed:@"informationcell" owner:nil options:nil]objectAtIndex:0];
            cell1.contentView.backgroundColor=[UIColor lightGrayColor];
            cell1.backgroundColor=[UIColor lightGrayColor];
            
        }
    
            cell1.xunhao.text=[NSString stringWithFormat:@"%ld",(long)(self.allcaihemessagearray.count-indexPath.row)];
            cell1.xunhao.layer.borderWidth=0.5f;
            cell1.xunhao.numberOfLines=0;
            cell1.xunhao.layer.borderColor=[[UIColor blackColor] CGColor];
    
            cell1.caihehao.text=self.allcaihemessagearray[self.allcaihemessagearray.count-indexPath.row-1][0];
            cell1.caihehao.numberOfLines=0;
            cell1.caihehao.layer.borderWidth=0.5f;
            cell1.caihehao.layer.borderColor=[[UIColor blackColor] CGColor];

            int t=[self.allcaihemessagearray[self.allcaihemessagearray.count-indexPath.row-1][4] intValue ];
    
            cell1.gooqty.text=[NSString stringWithFormat:@"%d",t];
            cell1.gooqty.layer.borderWidth=0.5f;
            cell1.gooqty.layer.borderColor=[[UIColor blackColor] CGColor];
            cell1.gooqty.numberOfLines=0;
            
            cell1.badqty.text=self.allcaihemessagearray[self.allcaihemessagearray.count-indexPath.row-1][5];
            cell1.badqty.layer.borderWidth=0.5f;
            cell1.badqty.numberOfLines=0;
            cell1.badqty.layer.borderColor=[[UIColor blackColor] CGColor];
            
            return cell1;
        
}

#pragma mark 确认提交工单 confirm sumbit order work
- (IBAction)sureupdate:(id)sender {
    
    self.sapreturnEXMSG=nil;
    
    [self.surebutton setEnabled:false];
    
    [self.surebutton setBackgroundColor:[UIColor grayColor]];
    
    if (self.gengxingbiaoji==0) {
        
        //如果彩盒统计数组等于工单数组
        NSLog(@"inboxarray%@worknomesage%@",self.inboxarray,_worknomesage);
        
        if ((self.inboxarray.count==(self.worknomesage.count/5))&&(self.inboxarray.count>0)) {
            
            //重要信息﹣﹣﹣﹣﹣﹣﹣解決方法同時判斷﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣﹣
            
            for (int i=0; i<self.worknomesage.count/5; i++) {
                
                NSString *inboxnos=self.worknomesage[i*5];
                
                NSString *chuwei=self.worknomesage[i*5+1];
                
                NSLog(@"储位地点：%@",chuwei);
                
                NSString *goodshuliang=self.worknomesage[i*5+4];
                
                NSString *badshuliang=self.worknomesage[i*5+3];
                
                NSLog(@"%@,%@,%@",inboxnos,goodshuliang,badshuliang);
                
                
                for (int j=0; j<self.inboxarray.count; j++) {
                    
                    NSLog(@"%@",self.inboxarray[j][1]);
                    
                    //88888888888888888888888888888888888888888888888888//
                    
                    if ([inboxnos isEqualToString:self.inboxarray[j][1]]&&([chuwei isEqualToString:self.inboxarray[j][7] ])) {
                        
                        NSString *goodshu=self.inboxarray[j][4];
                        
                        NSString *badshu= self.inboxarray[j][5];
                        
                        if (([goodshuliang intValue]== [goodshu intValue])&&([badshuliang intValue]==[badshu intValue])) {
                            
                            if(i==(self.worknomesage.count/5)-1){
                                
//                                NSLog(@"这个数据是合格的且数据可以进行其他数据检查");
//                                [self tixing:@"这个数据是合格的且数据可以进行其他数据检查" type:@"OK"];
                            self.navigationController.navigationBarHidden=YES;

                            self.biaoti.text=@"入庫中..........";

                            self.qingqiutype=3;

                            [[NSThread currentThread] cancel];

                            [self workintostoragesap:self.intostorageordernolable.text];
                                
                            break;
                                
                            }
                        }
                        else{
                            
                            self.tiaochu=1;
                            
                            [self tixing:[NSString stringWithFormat:@"%@工單對應的总數量與彩盒扫描总數量不一致禁止入庫",inboxnos] type:@"NG"];
                            
                            break;
                            
                        }
                    }
                }
                //跳出循环
                if (self.tiaochu==1) {
                    
                    break;
                    
                }
            }
            
        }
        else{
            
            [self tixing:@"工單量與掃描的數量不一致,請檢查完成再進行操作" type:@"NG"];
            
        }
        
    }
    else{
        
        [self tixing:@"掃描總數量超過工單總數量無法更新入庫" type:@"NG"];
        
    }
    
}

#pragma mark 清空数据
-(void)qingkongshuju{
    
    self.worknomesage=[[NSMutableArray alloc]init];
    
    self.inboxarray=[[NSMutableArray alloc]init];
    
    self.caihearray=[[NSMutableArray alloc]init];
    
    self.zhongshu=0;
    
    self.badzhongshu=0;
    
    self.goodzhongshu=0;
    
    self.gengxingbiaoji=0;
    
    self.allcaihemessagearray=[[NSMutableArray alloc]init];
    
    self.sapreturnmessagearray=[[NSMutableArray alloc]init];
    
}


#pragma mark  文字代理监控方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endjuhua];
    
    NSLog(@"%@",self.scantext.text);
    
    NSArray *strarray=[[NSArray alloc]init];
    
    strarray= [self.scantext.text componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strarray);
    
    if (_qingqiutype==0) {
        
            [self qingkongshuju];
        
            [self scanempno:strarray[0]];/**而我唯愿此生只暖你一人*/
            
            self.empnolable.text=strarray[0];

    }
    
    //扫描工单
    else if(_qingqiutype==1){
      
            [self checkinboxworksno:strarray[0]];
        
    }
    
    //扫描彩盒
    else if(_qingqiutype==2){
        
            self.inboxnolable.text=strarray[0];
        
            self.charusuoyoubiaoji=0;
            
            self.teshubiaoji=0;
        
            [self checkinbox:strarray[0]];
        
    }
    
    return YES;
}

#pragma mark 清空所有数据
-(void)qingkongallshuju{
    
    self.worknomesage=[[NSMutableArray alloc]init];
    
    self.inboxarray=[[NSMutableArray alloc]init];
    
    self.caihearray=[[NSMutableArray alloc]init];
    
    self.zhongshu=0;
    
    self.badzhongshu=0;
    
    self.goodzhongshu=0;
    
    self.gengxingbiaoji=0;
    
    self.allcaihemessagearray=[[NSMutableArray alloc]init];
    
    self.sapreturnmessagearray=[[NSMutableArray alloc]init];
    
    self.peoplemessage=nil;/**< 人员信息array */
    
    self.inboxmessage=nil;/**< 內箱信息array */
    
    self.insertmessage=nil;/**< 插入数据返回数组 */
    
    self.inboxarray=nil;/**< 外箱号码数组 */
    
    self.sapreturnEXMSG=nil;/**< 错误信息为空 */
    
    self.arraylist=nil;/**< 暂时存储的数组 */
    
    self.empno=nil;/**< 设置工卡为空 */

    self.empid=nil;/**< 工卡id变量为空 */
    
    self.empname=nil;/**< 员工姓名 */
    
    self.boxno=nil;/**< 箱号为空 */
    
    self.storageliaohao=nil;/**< 储位料号 */
    
    self.storagechuliang=nil;/**< 储位储量*/
    
    self.storagetype=nil;/**< 储位类型 */
    
    self.sapgoodfanhui=nil;/**< sap成功返回 */
    
    self.empnolable.text=nil;/**< 工号lable */
    
    self.intostorageordernolable.text=nil;/**< 工单lable */
    
    self.inboxnolable.text=nil;/**< 内箱号码lable */
    
    self.shulianglable.text=nil;/**< 数量lable */
    
    self.fanhuimessage.text=nil;/**< 返回信息的lable */
    
    self.tiaochu=0;/**< 控制输出信息 */
    
    [self.tableview reloadData];/**< tableview更新 */
    
    self.charusuoyoubiaoji=0;
    
    self.teshubiaoji=0;
    
}

-(void)playmusics
    {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"3617" withExtension:@"mp3"];
            
        NSError *error = nil;
            
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
        self.player.volume = 1.0;//范围为（0到1）；
            
        //设置循环次数，如果为负数，就是无限循环
        self.player.numberOfLoops =0;
            
        //设置播放进度
        self.player.currentTime = 0;
            
        //准备播放
        [self.player prepareToPlay];
            
        [self.player play];
            
    }

-(void)liaohaocuowu:(NSString*)str{
    
    [self endjuhua];
    
    [self.surebutton setEnabled:true];
    
    [self.surebutton setBackgroundColor:[UIColor colorWithRed:76.0/225 green:175.0/225 blue:210.0/225 alpha:1]];
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"未知錯誤(返回錯誤內容為空),請聯繫資訊解決:61353";
        
        len=[str length];
        
    }
   
    [self playmusics];//1002
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    self.fanhuimessage.text=str;
    
    self.fanhuimessage.textColor=[UIColor redColor];
    
}

#pragma mark  这边可以写一个识别


@end
