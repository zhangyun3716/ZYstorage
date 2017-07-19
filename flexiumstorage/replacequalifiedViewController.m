//  replacequalifiedViewController.m
//  flexiumstorage
//  Created by flexium on 2017/4/28.
//  Copyright © 2017年 FLEXium. All rights reserved.

#import "replacequalifiedViewController.h"

//扫描插件
#import "ZYScannerView.h"

//自定义cell格式
#import "informationcell.h"

#define CEll1 @"CELL1"

#define CEll2 @"CELL2"

/** 屏幕尺寸参数 */
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

@interface replacequalifiedViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

#define CEll1 @"CELL1"/**< cell重用机制 */

@property (assign, nonatomic)  int qingqiutype;/**< 请求类型 */

@property (strong,nonatomic)UIActivityIndicatorView *testview;/**< 菊花界面 */

@property (nonatomic, copy) NSString *currentElement;/**<xml标记当前  */

@property (nonatomic,strong)NSString *currentElementName;/**<标记名称  */

@property (nonatomic,assign)BOOL isCheck;/**< xml标签检查 */

@property (nonatomic,strong)NSString *returnresult;/**< 返回结果string */

@property (nonatomic, strong) NSXMLParser *parser;/**< xml解析代理 */

- (IBAction)beginscan:(UIButton *)sender;/**< 开始扫描开关 */

@property (strong, nonatomic) IBOutlet UILabel *beginscantextlable;/**<开始扫描文字提醒框  */

@property (strong, nonatomic) IBOutlet UILabel *empnolable;/**< 工号显示lable */

@property (strong, nonatomic) IBOutlet UILabel *boxnolable;/**< 外箱箱号lable */

@property (strong, nonatomic) IBOutlet UILabel *fanhuimessagelable;/**< 返回类型结果标题lable */

- (IBAction)querenupdate:(id)sender;/**< 确认更新按钮 */

@property (strong, nonatomic) IBOutlet UITableView *tableview;/**< tableview界面 */

@property (strong, nonatomic)  UITableView *billnotableview;/**<tableview的定义  */

@property (nonatomic, strong) NSArray *peoplemessage;/**< 人员信息array */

@property (nonatomic, strong) NSArray *boxnomessage;/**<外箱号码array  */

@property (nonatomic, strong) NSArray *sapboxnomessage;/**< sap外箱信息array */

@property (nonatomic, strong) NSArray *mesupdatemessage;/**< mes更新array */

@property (nonatomic, strong) NSMutableArray *allboxnomessagearray;/**< 所有箱号信息array */

@property (nonatomic, strong) NSArray *allbillsno;/**< 所有箱號選擇 */

@property (nonatomic, strong) NSArray *newboxmessagearray;/**< 暫時存取的數組 */

@property (nonatomic, strong) NSMutableArray *sapupdatemessagearray;/**< sap更新数据array */

@property (nonatomic, strong) NSArray *maxbillsno;/**< 流水號 */

@property (nonatomic, strong) NSString *sapretrunno;/**< sap返回号码 */

@property (strong, nonatomic) IBOutlet UILabel *billsids;

- (IBAction)buildbillsID:(UIButton *)sender;

- (IBAction)sechbillno:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *sechbillno;

@property (nonatomic, assign) int zanshideqingqiutype;/**< 暫時的請求類型緩存 */

- (IBAction)zuofeiaction:(UIButton *)sender;

@property (nonatomic, strong) NSArray *dingdanzuofeifanhuimeissage;/**< 訂單作廢返回信息 */


@end

@implementation replacequalifiedViewController

#pragma mark 界面即将显示
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:49.0/255.0 green:134.0/255.0 blue:251.0/255.0 alpha:1];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];
  
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
}
#pragma mark 界面显示中
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xianshi) name:@"PassValueWithNotification" object:nil ];//设置观察者
    
    self.title=@"產品出儲位BY不良品";
    
    self.tableview.delegate=self;
    
    self.tableview.dataSource=self;
    
    self.tableview.backgroundColor=[UIColor whiteColor];
    //隐藏下方多余的分割线。
    self.tableview.tableFooterView=[[UIView alloc] init];
    //下列方法的作用也是隐藏分割线。
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    
    //头部不可选择
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableview.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableview];
    
    self.allboxnomessagearray=[[NSMutableArray alloc]init];
    
    self.sapupdatemessagearray=[[NSMutableArray alloc]init];
    
    self.qingqiutype=0;
    
    self.allboxnomessagearray=[[NSMutableArray alloc]init];
    
    self.sapupdatemessagearray=[[NSMutableArray alloc]init];
    
    self.qingqiutype=0;
    
    self.billnotableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 350)];
    
    [self.view addSubview:self.billnotableview];
    
    self.billnotableview.delegate=self;
    
    self.billnotableview.dataSource=self;
    
    self.billnotableview.backgroundColor=[UIColor whiteColor];
 
    self.billnotableview.estimatedRowHeight = 100;
    
    self.billnotableview.rowHeight = UITableViewAutomaticDimension;
    
    self.billnotableview.hidden=YES;
    
}
#pragma mark 内存警告
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



#pragma mark 开始扫描
- (IBAction)beginscan:(UIButton *)sender {
    
    self.billnotableview.hidden=YES;
    
      self.sechbillno.selected=0;
    
    if (self.billsids.text.length<7) {
        
        [self tixing:@"請先產生流水號再操作"];
        
    }else{
        
        self.navigationController.navigationBarHidden=YES;//上方标题栏设置为隐藏
       
        //請求工卡
        if (_qingqiutype==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"掃描工卡" forKey: @"textlable"];
            
            [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
                
                [self scanempno:str];
                
                self.empnolable.text=str;
                
                self.navigationController.navigationBarHidden=NO;//上方标题栏设置隐藏
                
                NSLog(@"%@",str);
                
            }];
            
        }
        //掃描箱號
        if (_qingqiutype==1) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"掃描箱號" forKey: @"textlable"];
            
            [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
                
                [self checkboxno:str];
                
                self.navigationController.navigationBarHidden=NO;//上方标题栏设置隐藏
                
                NSLog(@"%@",str);
                
            }];
        }
        
    }
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
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkemp" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
             [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
            
        } else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:
                                NSUTF8StringEncoding];
            
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
#pragma mark 掃描箱號
-(void)checkboxno:(NSString *)message{
    
    int user_Id=[self.peoplemessage[2] intValue];
    
    NSLog(@"%d",user_Id);
    
    [self beginjuhua];
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstores.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <checkboxno xmlns='http://tempuri.org/'> <boxno>%@</boxno> <user_id>%d</user_id><bills_id>%@</bills_id><type>X</type></checkboxno></soap:Body> </soap:Envelope>",message,user_Id,self.billsids.text];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkboxno" forHTTPHeaderField:@"Action"];
    
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
             [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
        }
        else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;
        
            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
}
#pragma mark 產生流水號
-(void)buildliushui:(NSString *)message{
    
    [self beginjuhua];
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstores.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkmaxbillsno xmlns='http://tempuri.org/' /></soap:Body></soap:Envelope>"];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkmaxbillsno" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
             [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
            }
        else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;

            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
}


#pragma mark sap檢查箱號
-(void)sapcheckboxno:(NSString *)message{
    
    NSString *urlStr = @"http://ksrv-sap-qas.flexium.local:8000/sap/bc/srt/rfc/sap/zsrpp005/888/service/binding";
    
    // 1.请求地址
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:sap-com:document:sap:soap:functions:mc-style'> <soapenv:Header/><soapenv:Body><urn:Zfpp008><ExMsg>2011</ExMsg><ImOutboxno>%@</ImOutboxno> <ImWerks>2011</ImWerks></urn:Zfpp008></soapenv:Body></soapenv:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/Zfpp008" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
        } else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;

            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}

#pragma mark sap返回提單號
-(void)sapreturenworkno:(NSString *)message{
    
    // sap更新返回数组显示
    self.sapupdatemessagearray=[[NSMutableArray alloc]init];
    
    // 0.访问地址string
    NSString *urlStr = @"http://ksrv-sap-qas.flexium.local:8000/sap/bc/srt/rfc/sap/zsrpp005/888/service/binding";
    
    // 1.服务器地址
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    //    <Outboxno>201703BOX00632</Outboxno>
    //    <Outboxno>201703BOX00682</Outboxno>
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:sap-com:document:sap:soap:functions:mc-style'><soapenv:Header/><soapenv:Body><urn:Zfpp009><ImPakguser>KEVIN</ImPakguser> <ImRefxtype>E</ImRefxtype><ImWerks>2011</ImWerks><TabBoxno>%@</TabBoxno></urn:Zfpp009></soapenv:Body></soapenv:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/Zfpp009" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {

            [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
        } else {
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


#pragma mark mes更新記錄
-(void)updatemesboxno:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstores.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body><updateboxmessage xmlns='http://tempuri.org/'><boxno>%@</boxno> <userid>%@</userid> <bills_no>%@</bills_no><BILLS_ID>%@</BILLS_ID></updateboxmessage></soap:Body> </soap:Envelope>",message,_peoplemessage[2],self.sapretrunno,self.billsids.text];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/updateboxmessage" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
             [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            }
        else
            {
            self.parser=[[NSXMLParser alloc]initWithData:data];
                
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                
            NSLog(@"%@",result);
                
            //添加代理
            self.parser.delegate=self;
          
            self.parser.shouldResolveExternalEntities=true;
                
            //开始解析
            [self.parser parse];
            
        }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
}
#pragma mark 订单作废
-(void)dingdanzuofei:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstores.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <zuofeibillsno xmlns='http://tempuri.org/'><bills_id>%@</bills_id></zuofeibillsno></soap:Body> </soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/zuofeibillsno" forHTTPHeaderField:@"Action"];
    
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
        }
        else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;
         
            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
}

#pragma mark 查询所有预定单编号
-(void)searchbillsno:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstores.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body><searchbills_no xmlns='http://tempuri.org/'><TYPE>X</TYPE></searchbills_no> </soap:Body> </soap:Envelope>"];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/searchbills_no" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
             [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            }
        else {
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;
          
            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
        }
    }];
    
    // 6.开启请求数据
    [dataTask resume];
}

#pragma mark 查询订单箱号信息
-(void)searhboxmessage:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstores.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <searchboxmessage xmlns='http://tempuri.org/'><bills_id>%@</bills_id></searchboxmessage></soap:Body></soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/searchboxmessage" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self tixing:[NSString stringWithFormat:@"请求数据出错!----%@",error.description]];
            
        } else {
            
            self.parser=[[NSXMLParser alloc]initWithData:data];
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",result);
            
            //添加代理
            self.parser.delegate=self;
         
            self.parser.shouldResolveExternalEntities=true;
            
            //开始解析
            [self.parser parse];
            
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
    
    if ([_currentElementName isEqualToString:@"checkboxnoResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"ExMsg"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"updateboxmessageResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"ExPakgcode"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"checkmaxbillsnoResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"searchbills_noResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"searchboxmessageResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"zuofeibillsnoResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
}

#pragma mark 把第一个代理中我们要找的信息存储在currentstring中并把要找的信息空格和换行符号去除
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([_currentElementName isEqualToString:@"checkempResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.peoplemessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"checkboxnoResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.boxnomessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"ExMsg"]&&_qingqiutype==2) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        _sapboxnomessage= [self.returnresult componentsSeparatedByString:@";"];
        
    }
    
    if ([_currentElementName isEqualToString:@"ExMsg"]&&_qingqiutype==3) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        [self.sapupdatemessagearray addObject:_returnresult] ;
        
    }
    
    if ([_currentElementName isEqualToString:@"ExPakgcode"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        _sapretrunno=_returnresult ;
        
    }
    
    if ([_currentElementName isEqualToString:@"updateboxmessageResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        _mesupdatemessage= [self.returnresult componentsSeparatedByString:@";"];
        
    }
    
    if ([_currentElementName isEqualToString:@"checkmaxbillsnoResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.maxbillsno= [self.returnresult componentsSeparatedByString:@";"];
        
    }
    
    if ([_currentElementName isEqualToString:@"searchbills_noResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.allbillsno= [self.returnresult componentsSeparatedByString:@";"];
        
    }
    
    if ([_currentElementName isEqualToString:@"searchboxmessageResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.newboxmessagearray= [self.returnresult componentsSeparatedByString:@";"];
        
    }
    
    if ([_currentElementName isEqualToString:@"zuofeibillsnoResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.dingdanzuofeifanhuimeissage= [self.returnresult componentsSeparatedByString:@";"];
        
    }
}

#pragma mark 把上部的信息存储到数据中
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}
#pragma mark 解析结束数据
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self endjuhua];
        
        //1.掃描工號
        if (_qingqiutype==0) {
            
            if ( [self.peoplemessage[0] isEqualToString:@"OK"]) {
                
                 AudioServicesPlaySystemSound(1002);
                
                //去請求箱號
                _qingqiutype=1;
                
                self.beginscantextlable.text=@"掃描箱號";
                
                self.empnolable.text=self.peoplemessage[1];
                
            }else{
                
                [self tixing:self.peoplemessage[1]];
                
            }
        }
        //2.掃描箱號
        else if(_qingqiutype==1){
            
            if ([self.boxnomessage[0] isEqualToString:@"OK"]) {
                if([[self.boxnomessage[2]substringToIndex:1]isEqualToString:@"X"]){
               
                    _qingqiutype=2;
                    
                    //sap檢查箱號如果sap檢查也是ok的則插入數組中并顯示在下面
                    [self sapcheckboxno:self.boxnomessage[1]];
                    
                     AudioServicesPlaySystemSound(1002);
                    
                }
                else{
                    self.qingqiutype=1;
                    
                    [self tixing:@"該箱號為正常品,請用出儲位by良品功能出貨"];
  
                }

            }else{
                
                self.qingqiutype=1;
                
                [self tixing:self.boxnomessage[1]];
                
            }
            
        }
        //3.sap箱號檢查
        else if(_qingqiutype==2){
            
            if ([_sapboxnomessage[0]isEqualToString:@"OK"]) {
                
                if (self.allboxnomessagearray.count==0) {
                    
                    _qingqiutype=1;
                    
                    _beginscantextlable.text=@"掃描箱號";
                    
                    self.boxnolable.text=self.boxnomessage[1];
                    
                    [self.allboxnomessagearray insertObject:self.boxnomessage atIndex:self.allboxnomessagearray.count];
                    
                    NSLog(@"%@",self.allboxnomessagearray);
                    
                    [self.tableview reloadData];
                    
                    [self beginscanboxaction];
                    
                }else{
                    
                    for (int i=0; i<self.allboxnomessagearray.count; i++) {
                        
                        if ([self.allboxnomessagearray[i][1]isEqualToString:self.boxnomessage[1]]) {
                            
                            [self tixing:@"箱號已掃描禁止重複掃描"];
                            
                            _qingqiutype=1;
                            
                            _beginscantextlable.text=@"掃描箱號";
                            
                            break;
                        }
                        else if(i==self.allboxnomessagearray.count-1){
                            
                            _qingqiutype=1;
                            
                            _beginscantextlable.text=@"掃描箱號";
                            
                            self.boxnolable.text=self.boxnomessage[1];
                            
                            [self.allboxnomessagearray insertObject:self.boxnomessage atIndex:self.allboxnomessagearray.count];
                            
                            NSLog(@"%@",self.allboxnomessagearray);
                            
                            [self.tableview reloadData];
                            
                             AudioServicesPlaySystemSound(1002);
                            
                            [self beginscanboxaction];
                            
                            break;
                        }
                    }
                    
                }
            }else{
                
                [self tixing:self.sapboxnomessage[0]];
                
                _qingqiutype=1;
                
                _beginscantextlable.text=@"掃描箱號";
                
            }
        }
        //更新sap返回提單號
        else if(_qingqiutype==3){
            
            NSLog(@"%@",self.sapupdatemessagearray);
            NSLog(@"%@",self.sapretrunno);
            NSLog(@"%@",self.allboxnomessagearray);
            
            if (self.sapretrunno.length>2) {
                
                self.qingqiutype=4;
                
                NSString *message=@"";
                
                for (int i=0; i<self.allboxnomessagearray.count; i++) {
                    
                    if (i==0) {
                        
                        message=[NSString stringWithFormat:@"'%@'",self.allboxnomessagearray[0][1]];
                        
                    }else{
                        
                        message=[NSString stringWithFormat:@"%@,'%@'",message,self.allboxnomessagearray[i][1]];
                    }
                }
                
                NSLog(@"%@",message);
                
                [self updatemesboxno:message];
                
            }else{
                
                [self tixing:self.sapupdatemessagearray[0]];
                
                self.beginscantextlable.text=@"扫描工卡";
                
                self.qingqiutype=0;
                
            }
        }
        //更新mes數據庫
        else if(_qingqiutype==4){
            
            if([_mesupdatemessage[0]isEqualToString:@"OK"]){

              [self successremind:[NSString stringWithFormat:@"%@,提單號為:%@",_mesupdatemessage[1],self.sapretrunno]];
                
                self.fanhuimessagelable.text=[NSString stringWithFormat:@"%@,提單號為:%@",_mesupdatemessage[1],self.sapretrunno];
                
                [self Cleanalldate];
                
                self.beginscantextlable.text=@"扫描工卡";
                
                self.qingqiutype=0;
                
            }else{
                
                [self tixing:_mesupdatemessage[1]];
                
                self.fanhuimessagelable.text=_mesupdatemessage[1];
                
                self.beginscantextlable.text=@"扫描工卡";
                
                self.qingqiutype=0;
                
            }
            
        }
        else if(_qingqiutype==5){
            
            self.billsids.text=self.maxbillsno[1];
            
            self.qingqiutype=0;
            
        }
        else if(_qingqiutype==6){
            
            self.qingqiutype=self.zanshideqingqiutype;//暂时把数据储存到变量中,方便更换
            
            self.billnotableview.hidden=NO;
            
            if ([self.allbillsno[0]isEqualToString:@"NG"]) {
                
                [self tixing:self.allbillsno[1]];
                
            }
            
            [self.billnotableview reloadData];
            
        }
        else if(_qingqiutype==7){
            
            NSLog(@"%@",self.newboxmessagearray);
            
            if([self.newboxmessagearray[0]isEqualToString:@"NG"]){
                
                [self tixing:self.newboxmessagearray[1]];
                
                self.qingqiutype=0;
                
                
            }else{
                
                for(int i=0;i<self.newboxmessagearray.count/3;i++){
                    
                    NSArray *arry2=@[@"OK",self.newboxmessagearray[i*3],self.newboxmessagearray[i*3+1],self.newboxmessagearray[i*3+2]];
                    
                    [self.allboxnomessagearray insertObject:arry2 atIndex:self.allboxnomessagearray.count];
                    
                }
                
                self.qingqiutype=0;
                
                [self.tableview reloadData];
                
            }
        }
        else if(_qingqiutype==8){
            
            _qingqiutype=_zanshideqingqiutype;
            
            if([_dingdanzuofeifanhuimeissage[0]isEqualToString:@"NG"]){
                [self tixing:self.dingdanzuofeifanhuimeissage[1]];
                
                
            }else{
                
                [self Cleanalldate];
                
                self.qingqiutype=0;
                
                self.beginscantextlable.text=@"扫描工卡";
                
            }
        }
        
        
    });
    
    
}


#pragma 下列方法为tableview方法实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView==self.tableview) {
        
        return 1;
        
    }else{
        
        if ([self.allbillsno[0]isEqualToString:@"NG"]) {
            
            self.allbillsno=nil;
            
            return 0;
            
        }else{
            
            return 1;
            
        }
    }
}

#pragma mark 有多少行cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.tableview) {
        
        return self.allboxnomessagearray.count;
        
        }
    else{
        
        return self.allbillsno.count;
        
    }
}

#pragma mark cell顯示內容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tableview) {
        
        informationcell *cell1=[tableView dequeueReusableCellWithIdentifier:CEll1];
        
        if (cell1 ==nil) {
            
            cell1=[[[NSBundle mainBundle]loadNibNamed:@"informationcell" owner:nil options:nil]objectAtIndex:0];
            
            cell1.contentView.backgroundColor=[UIColor lightGrayColor];
            
            cell1.backgroundColor=[UIColor lightGrayColor];
            
        }
        
        cell1.xunhao.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1] ;
        
        cell1.xunhao.layer.borderWidth=0.5f;
        
        cell1.xunhao.numberOfLines=0;
        
        cell1.xunhao.layer.borderColor=[[UIColor blackColor] CGColor];
        
        cell1.caihehao.text=self.allboxnomessagearray[indexPath.row][1];
        
        cell1.caihehao.numberOfLines=0;
        
        cell1.caihehao.layer.borderWidth=0.5f;
        
        cell1.caihehao.layer.borderColor=[[UIColor blackColor] CGColor];
        
        cell1.gooqty.text=self.allboxnomessagearray[indexPath.row][2];
        
        cell1.gooqty.layer.borderWidth=0.5f;
        
        cell1.gooqty.layer.borderColor=[[UIColor blackColor] CGColor];
        
        cell1.gooqty.numberOfLines=0;
        
        cell1.badqty.text=self.allboxnomessagearray[indexPath.row][3];
        
        cell1.badqty.layer.borderWidth=0.5f;
        
        cell1.badqty.numberOfLines=0;
        
        cell1.badqty.layer.borderColor=[[UIColor blackColor] CGColor];
        
        return cell1;
        
    }else{
        
        static NSString *cellIdentifier =@"cell_id";
        
        //重用机制有关系
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            
            //样式
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            
        }
        
        cell.textLabel.text= self.allbillsno[indexPath.row];
        
        cell.textLabel.font=[UIFont systemFontOfSize:21];
        
        return cell;
        
        
    }
    
}
#pragma mark 選擇操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tableview) {
        
        NSLog(@"選擇%ld,%ld",(long)indexPath.row,(long)indexPath.section);
        
    }else{
        
        self.billnotableview.hidden=YES;
        
        self.billsids.text=self.allbillsno[indexPath.row];
        
        [self searhboxmessage:self.billsids.text ];
        
        self.qingqiutype=7;
        
        NSLog(@"選擇%ld,%ld",(long)indexPath.row,(long)indexPath.section);
        
    }
}

#pragma mark 網絡錯誤提示界面
-(void)intenererror{
    
    [self endjuhua];
   [self playmusics];//1002
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
-(void)tixing:(NSString *)str{
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"未知錯誤(返回錯誤內容為空),請聯繫資訊解決:61353";
        
    }
   [self playmusics];//1002
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
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

#pragma mark 建立并开始菊花界面请求
-(void)beginjuhua{
    
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);
    
    [testActivityIndicator setFrame :CGRectMake(100, 200, 100, 100)];
    
    [self.view addSubview:testActivityIndicator];
    
    testActivityIndicator.color = [UIColor greenColor];
   
    [testActivityIndicator startAnimating];
    
    self.testview=testActivityIndicator;
    
}

#pragma mark 结束并移除菊花界面
-(void)endjuhua{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_testview stopAnimating]; // 结束旋转
        
        [_testview removeFromSuperview]; //当旋转结束时移除
        
    });
    
}

#pragma mark 清空数据
-(void)qingkongshuju{
    
    _boxnolable.text=nil;
    
    _empnolable.text=nil;
    
    _fanhuimessagelable.text=nil;
    
}

#pragma mark 确认更新
- (IBAction)querenupdate:(id)sender {
    
    self.qingqiutype=3;
    
    NSString *message=@"";
    
    for (int i=0; i<self.allboxnomessagearray.count; i++) {
        
        NSString *str2=[NSString stringWithFormat:@" <item><Outboxno>%@</Outboxno><Kunnr></Kunnr><Cpn></Cpn> </item>",self.allboxnomessagearray[i][1]];
        
        message=[NSString stringWithFormat:@"%@%@",message,str2];
        
    }
   
    [self sapreturenworkno:message];
    
}

#pragma mark 扫描外箱号码
-(void)beginscanboxaction{
    self.navigationController.navigationBarHidden=YES;//上方标题栏设置为不隐藏
    //掃描箱號
    if (_qingqiutype==1) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描箱號" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            [self checkboxno:str];
            
            self.navigationController.navigationBarHidden=NO;//上方标题栏设置隐藏
            
            NSLog(@"%@",str);
            
        }];
    }
    
}
#pragma mark 通知显示

-(void)xianshi{
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
    
}
#pragma mark 清空所有数据

-(void)Cleanalldate{
    
    self.peoplemessage=nil;/**< 人员信息array */
    
    self.boxnomessage=nil;/**<外箱号码array  */
    
    self.sapboxnomessage=nil;/**< sap外箱信息array */
    
    self.mesupdatemessage=nil;/**< mes更新array */
    
    self.allboxnomessagearray=[[NSMutableArray alloc]init];/**< 所有箱号信息array */
    
    self.sapupdatemessagearray=[[NSMutableArray alloc]init];/**< sap更新数据array */
    
    self.sapretrunno=nil;/**< sap返回号码 */
    
    self.empnolable.text=nil;/**< 工卡号码lable */
    
    self.boxnolable.text=nil;/**< 外箱号码 */
    
    self.fanhuimessagelable.text=nil;/**<返回数据lable  */
    
    self.billsids.text=nil;
    
    [self.tableview reloadData];
    
    self.allbillsno=nil;/**< 所有箱號選擇 */
    
    self.newboxmessagearray=nil;/**< 暫時存取的數組 */
    
    self.maxbillsno=nil;/**< 流水號 */
    
    
    
}

-(void)successremind:(NSString *)str{
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"未知錯誤(返回錯誤內容為空),請聯繫資訊解決:61353";
        
    }
    AudioServicesPlaySystemSound(1002);//1002
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, len)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, len)];
    
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    

}

#pragma mark 建立流水
- (IBAction)buildbillsID:(UIButton *)sender {
    
    if (self.billsids.text.length>7) {
        
        [self tixing:@"流水號已經產生,請務重複操作"];
        
        }
    else{
       
        self.qingqiutype=5;
        
        [self buildliushui:@"111"];
        
    }
}

#pragma mark  查询流水号对应的东西
- (IBAction)sechbillno:(UIButton *)sender {
    
    if(  self.newboxmessagearray.count>0||_qingqiutype!=0){
        
        [self tixing:@"查詢功能請在進入界面開始就進行操作"];
        
        }
    else{
        
        sender.selected=!sender.selected;
        
        if (sender.selected==1) {
            
            self.qingqiutype=self.zanshideqingqiutype;
            
            self.qingqiutype=6;
            
            self.allbillsno=nil;
            
            [self searchbillsno:@"1"];
            
            }
        else{
            
            self.billnotableview.hidden=YES;
            
        }
    }
}

#pragma mark  获取当前时间
-(NSString *)huoqudangqianshjian{
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
    
}

#pragma mark  作废流水号功能
- (IBAction)zuofeiaction:(UIButton *)sender {
    
    _zanshideqingqiutype=_qingqiutype;
    
    if(self.billsids.text.length<5){
        
        [self tixing:@"請先查詢流水并選擇要作廢的流水號然後再操作作廢"];
        
        }
    else{
        
        [self baojingtanchukuang];
        
    }
    
}
#pragma mark  作废的时候弹出的提醒框
-(void)baojingtanchukuang{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"一旦刪除將無法返回是否確定" preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击确认");
        
        _qingqiutype=8;
        
        [self dingdanzuofei:self.billsids.text];
        
    }]];
    
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];
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

@end
