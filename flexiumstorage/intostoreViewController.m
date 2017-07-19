//
//  intostoreViewController.m
//  flexiumstorage
//  Created by flexium on 2017/4/28.
//  Copyright © 2017年 FLEXium. All rights reserved.


#import "intostoreViewController.h"

#import "ZYScannerView.h"

#import <AudioToolbox/AudioToolbox.h>

@interface intostoreViewController ()<NSXMLParserDelegate>

- (IBAction)beginscan:(id)sender;/**< 开始扫码 */

@property (strong, nonatomic) IBOutlet UILabel *scantext;/**< 开始扫描文字 */

@property (assign, nonatomic)  int qingqiutype;/**< 网络请求类型 */

@property (nonatomic, copy) NSString *currentElement;/**< xml标签文件类型 */

@property (nonatomic,strong)NSString *currentElementName;/**< 标签名对比使用 */

@property (nonatomic,assign)BOOL isCheck;/**<对比结果  */

@property (nonatomic,strong)NSString *returnresult;/**< 返回结果string */

@property (nonatomic, strong) NSXMLParser *parser;/**< xml属性 */

@property (nonatomic, strong) NSArray *peoplemessage;/**<人员信息array  */

@property (nonatomic, strong) NSArray *storagemessage;/**< 储位信息array */

@property (nonatomic, strong) NSArray *boxmessage;/**< 外箱返回信息array */

@property (nonatomic, strong) NSArray *storageyongliang;/**< 储位用量 */

@property (nonatomic, strong) NSArray *gengxinrukubiaozhuantairesult;/**< 更新入库表状态返回信息 */

@property (nonatomic, strong) NSArray *charuchuweijieguo;/**< 插入储位结果返回array */

@property (nonatomic, strong) NSArray *charuboxjieguo;/**< 更新外箱状态结果 */

@property (nonatomic, strong) NSArray *arraylist;/**<返回信息暂时接受数组  */

@property (strong,nonatomic)UIActivityIndicatorView *testview;/**< 菊花界面 */

@property (strong, nonatomic) IBOutlet UILabel *emplable;/**< 工卡lable */

@property (strong, nonatomic) IBOutlet UILabel *storageno;/**<储位号码lable  */

@property (strong, nonatomic) IBOutlet UILabel *xianghaolable;/**< 外箱号码lable */

@property (strong, nonatomic) IBOutlet UILabel *fanhuimessage;/**< 返回数据lable */
@property (strong, nonatomic) IBOutlet UIButton *scanbtn;/**<  开始扫描button*/

@property (strong, nonatomic) NSString *empno;/**<工卡号码  */

@property (strong, nonatomic) NSString *empid;/**<工卡对应人员的id  */

@property (strong, nonatomic) NSString *empname;/**< 人员名字 */

@property (strong, nonatomic) NSString *boxno;/**< 外箱号码 */

@property (strong, nonatomic) NSString *storageliaohao;/**< 储位对应的料号 */

@property (strong, nonatomic) NSString *storagechuliang;/**< 储位储量 */

@property (strong, nonatomic) NSString *storagetype;/**< 储位类型 */

@property (strong, nonatomic) NSString *storagezctype;/**< 储位的类型 */

@end

@implementation intostoreViewController

#pragma mark 界面即将显示
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:49.0/255.0 green:134.0/255.0 blue:251.0/255.0 alpha:1];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
}
//界面显示
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title=@"入儲位";
    
    _qingqiutype=0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xianshi) name:@"PassValueWithNotification" object:nil ];
    
    
}
//内存警告
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}

//开始扫描
- (IBAction)beginscan:(id)sender {
    
      self.navigationController.navigationBarHidden=YES;//上方标题栏设置为隐藏
    
    if (_qingqiutype==0) {
        
        [self qingkongallshuju];
        
        //1.掃描工卡
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描工卡" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            NSLog(@"%@",str);
            
            [self scanempno:str];
            
            self.navigationController.navigationBarHidden=NO;
            
        }];
    }
    else if(_qingqiutype==1){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描儲位編號" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            NSLog(@"%@",str);
            
            self.navigationController.navigationBarHidden=NO;
            
            [self scanstorage:str];
            
        }];
    }else if(_qingqiutype==2){
        
        [self qingkongshuju];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描包裝箱號" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            [self checkbox:str];
            
            self.navigationController.navigationBarHidden=NO;
            
            NSLog(@"%@",str);
            
        }];
    }else{
        
        [self tixing:@"未知錯誤，返回重啟"];
        
        self.navigationController.navigationBarHidden=NO;
        
    }
 
}
#pragma mark 掃描工卡
-(void)scanempno:(NSString *)message{
    
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
            
            [self intenererror];
            
        } else {
            
            [self beginjuhua];
            
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
#pragma mark 掃描儲位
-(void)scanstorage:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkstorage xmlns='http://tempuri.org/'> <storagenum>%@</storagenum></checkstorage></soap:Body></soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkstorage" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
        } else {
            
            [self beginjuhua];
            
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
#pragma mark 掃描箱號
-(void)checkbox:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkbox xmlns='http://tempuri.org/'><boxno>%@</boxno> </checkbox> </soap:Body> </soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkbox" forHTTPHeaderField:@"Action"];
    
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
        } else {
            
             [self beginjuhua];
            
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
#pragma mark 檢查儲位已經用了多少
-(void)checkstorageliang:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body><checkstoragecountnum xmlns='http://tempuri.org/'> <storagenum>%@</storagenum> </checkstoragecountnum></soap:Body></soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkstoragecountnum" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
        } else {
            
             [self beginjuhua];
            
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
#pragma mark 更新入庫表狀態
-(void)updatepackage:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <updatepackage xmlns='http://tempuri.org/'><storagenum>%@</storagenum> </updatepackage></soap:Body></soap:Envelope>",self.xianghaolable.text];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/updatepackage" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
        } else {
            
             [self beginjuhua];
            
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
#pragma mark 插入儲位數據庫
-(void)insertstorage:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <insertstoreage xmlns='http://tempuri.org/'> <storagenum>%@</storagenum> <userid>%@</userid><boxno>%@</boxno></insertstoreage> </soap:Body> </soap:Envelope>",self.storageno.text,self.empid,self.xianghaolable.text];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/insertstoreage" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
        } else {
            
             [self beginjuhua];
            
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
#pragma mark 插入內箱質料表
-(void)insertbox:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/intostore.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <insertbox xmlns='http://tempuri.org/'><userid>%@</userid> <boxno>%@</boxno></insertbox></soap:Body></soap:Envelope>",self.empid,self.xianghaolable.text];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkstoragecountnum" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
        } else {
            
             [self beginjuhua];
            
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
    
    [self endjuhua];
    
    if ([_currentElementName isEqualToString:@"checkempResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
        
    }
    if ([_currentElementName isEqualToString:@"checkstorageResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
        
    }
    
    if ([_currentElementName isEqualToString:@"checkboxResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
        
    }
    
    if ([_currentElementName isEqualToString:@"checkstoragecountnumResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
        
    }
    if ([_currentElementName isEqualToString:@"updatepackageResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
        
    }
    if ([_currentElementName isEqualToString:@"insertstoreageResult"]) {
        
        _isCheck = true;
        
        _returnresult = @"";
        
    }
    if ([_currentElementName isEqualToString:@"insertboxResult"]) {
        
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
    
    if ([_currentElementName isEqualToString:@"checkstorageResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.storagemessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"checkboxResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.boxmessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"checkstoragecountnumResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.storageyongliang= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"updatepackageResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.gengxinrukubiaozhuantairesult= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"insertstoreageResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.charuchuweijieguo= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"insertboxResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.charuboxjieguo= [self.returnresult componentsSeparatedByString:@";"];
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
                
                _qingqiutype=1;
                
                self.scantext.text=@"掃描儲位編號";
                
                self.emplable.text=self.peoplemessage[1];
                
                self.empid=self.peoplemessage[2];
                
                self.empno=self.peoplemessage[1];
                
                self.empname=self.peoplemessage[3];
                 AudioServicesPlaySystemSound(1002);
            }else{
                
                [self tixing:self.peoplemessage[1]];
                
            }
        }
//2.掃描儲位編號
        else if(_qingqiutype==1||_qingqiutype==7){
            
            if (_qingqiutype==1) {
                
                NSLog(@"%@",_storagemessage);
                
                if ( [self.storagemessage[0] isEqualToString:@"OK"]) {
                    
                    _qingqiutype=2;
                    
                    self.storageno.text=self.storagemessage[1];
                    
                    self.scantext.text=@"掃描包裝箱號";
                    
                    NSLog(@"%@",self.storagemessage);
                    
                    self.storageliaohao=self.storagemessage[2];
                    
                    self.storagechuliang=self.storagemessage[3];
                    
                    self.storagetype=self.storagemessage[4];
                    
                    self.storagezctype=self.storagemessage[5];
                    
                     AudioServicesPlaySystemSound(1002);
                    
                }else{
                    
                    [self tixing:self.storagemessage[1]];
                    
                }
            }else{
                
                NSLog(@"%@",_storagemessage);
                
                if ( [self.storagemessage[0] isEqualToString:@"OK"]) {
                    
                    _qingqiutype=2;
                    
                    self.storageno.text=self.storagemessage[1];
                    
                    self.scantext.text=@"掃描包裝箱號";
                    
                    NSLog(@"%@",self.storagemessage);
                    
                    self.storageliaohao=self.storagemessage[2];
                    
                    self.storagechuliang=self.storagemessage[3];
                    
                    self.storagetype=self.storagemessage[4];
                    
                    self.storagezctype=self.storagemessage[5];
                    
                     AudioServicesPlaySystemSound(1002);
                    self.navigationController.navigationBarHidden=YES;//上方标题栏设置为隐藏
                    
                    [self qingkongshuju];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"掃描包裝箱號" forKey: @"textlable"];
                    
                    [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
                        
                        [self checkbox:str];
                        
                        self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
                        
                        NSLog(@"%@",str);
                        
                    }];
                    
                }else{
                    
                    [self tixing:self.storagemessage[1]];
                    
                }
            }
        }
        
//3.掃描包裝箱號解析
        else if(_qingqiutype==2){
            
            NSLog(@"%@",self.boxmessage);
            
            if ( [self.boxmessage[0] isEqualToString:@"OK"]) {
                
                //這裡是未來料號的對比成功才能進行入儲位操作
                NSArray *strarray = [self.boxmessage[3] componentsSeparatedByString:@"-"];
                
                if(([_storageliaohao isEqualToString:strarray[0]])){
                    
                    _qingqiutype=3;
                    
                    self.xianghaolable.text=self.boxmessage[1];
                    
                    NSLog(@"%@",self.boxmessage);
                    
                     AudioServicesPlaySystemSound(1002);
                    
                    [self checkstorageliang:self.storageno.text];
                    
                }
                else if([_storagetype isEqualToString:@"Y"]){
                    
                    //都是不良
                    NSLog(@"%@",[strarray[0]substringToIndex:1]);
                    
                    NSLog(@"%@",[_storageliaohao substringToIndex:1]);
                    
                    if( [[strarray[0]substringToIndex:1]isEqualToString:@"X"]){
                        
                        _qingqiutype=3;
                        
                        self.xianghaolable.text=self.boxmessage[1];
                        
                        NSLog(@"%@",self.boxmessage);
                        
                        [self checkstorageliang:self.storageno.text];
                        
                         AudioServicesPlaySystemSound(1002);
                        
                    }
                    //都是正常品
                    else if(![[strarray[0]substringToIndex:1]isEqualToString:@"X"]&&![[_storageliaohao substringToIndex:1]isEqualToString:@"X"]){
                        
                        _qingqiutype=3;
                        
                        self.xianghaolable.text=self.boxmessage[1];
                        
                        NSLog(@"%@",self.boxmessage);
                        
                        [self checkstorageliang:self.storageno.text];
                        
                         AudioServicesPlaySystemSound(1002);
                        
                    }
                    
                    else{
                        
                        _qingqiutype=2;
                        
                        self.scanbtn.userInteractionEnabled=YES;
                        
                        self.scantext.text=@"掃描包裝箱號";
                        
                        self.fanhuimessage.text=[NSString stringWithFormat:@"箱号料号(%@)与储位料号(%@)正常品和不良品不能混装",strarray[0],_storageliaohao];
                        
                        [self tixing:[NSString stringWithFormat:@"箱号料号(%@)与储位料号(%@)正常品和不良品混装",strarray[0],_storageliaohao]];
                        
                    }
                }
                
                else{
                    
                    _qingqiutype=2;
                    
                    self.scanbtn.userInteractionEnabled=YES;
                    
                    self.scantext.text=@"掃描包裝箱號";
                    
                    self.fanhuimessage.text=[NSString stringWithFormat:@"箱号料号(%@)与储位料号(%@)不一致且该储位禁止混装",strarray[0],_storageliaohao];
                    
                    [self tixing:[NSString stringWithFormat:@"箱号料号(%@)与储位料号(%@)不一致且该储位禁止混装",strarray[0],_storageliaohao]];
                    
                }
              
                
            }else{
                
                [self tixing:self.boxmessage[1]];
                
                _qingqiutype=2;
                
                self.scanbtn.userInteractionEnabled=YES;
                
                self.scantext.text=@"掃描包裝箱號";
                
                self.fanhuimessage.text=self.boxmessage[1];
                
               
            }
        }
        
        else if(_qingqiutype==3){
            
            if ([self.storageyongliang[0] isEqualToString:@"OK"]) {
                
                NSLog(@"儲位已用信息如下：%@",self.storageyongliang);
                
                NSLog(@"儲位儲存量信息如下：%@",self.storagechuliang);
                
                int yongliang=[self.storageyongliang[1] intValue];
                
                //還有位置放
                if ([self.storagechuliang intValue]>yongliang) {
                    
                    NSLog(@"可以放入，請執行插入代碼");
                    
                    _qingqiutype=4;
                    
                    self.scanbtn.userInteractionEnabled=NO;
                    
                    [self updatepackage:self.boxno];
                    
                    
                    }
                
                else{
                    
                        //沒有位置放了
                        [self tixing:@"儲位已滿無法進儲位"];
                        
                        _qingqiutype=2;
                        
                        self.scanbtn.userInteractionEnabled=YES;
                        
                        self.scantext.text=@"掃描包裝箱號";
                        
                        self.fanhuimessage.text=@"儲位已滿無法進儲位";
                    
                    }
                }
            else{
                
                [self tixing:@"檢查餘量錯誤。從新操作"];
                
                _qingqiutype=2;
                
                self.scanbtn.userInteractionEnabled=YES;
                
                self.scantext.text=@"掃描包裝箱號";
                
                self.fanhuimessage.text=@"檢查餘量錯誤。從新操作";
                
            }
            
        }
    else if(_qingqiutype==4){
            
            if ([self.gengxinrukubiaozhuantairesult[0] isEqualToString:@"OK"])
                
                {
                
                _qingqiutype=5;
                
                [self insertstorage:@"meiding"];
                
                }
        
            else{
                
                [self tixing:@"更新狀態失敗。無法操作"];
                
                _qingqiutype=2;
                
                self.scanbtn.userInteractionEnabled=YES;
                
                self.scantext.text=@"掃描包裝箱號";
                
                self.fanhuimessage.text=@"更新狀態失敗。無法操作";
                
            }
        
        }
        
        else if(_qingqiutype==5){
            
            if ([self.charuchuweijieguo[0] isEqualToString:@"OK"])
                
                {
                
                NSLog(@"插入成功");
                
                _qingqiutype=6;
                
                [self insertbox:self.boxno];
                
                }
            
            else{
                
                _qingqiutype=2;
                
                self.scanbtn.userInteractionEnabled=YES;
                
                self.scantext.text=@"掃描包裝箱號";
                
                self.fanhuimessage.text=self.charuchuweijieguo[1];
                
                [self tixing:self.charuchuweijieguo[1]];
                
                self.scanbtn.userInteractionEnabled=YES;
                
            }
          
        }
    else if(_qingqiutype==6)
        
            {
            
            NSLog(@"%@",self.charuboxjieguo);
            
            self.fanhuimessage.text=self.charuboxjieguo[1];
            
            self.scanbtn.userInteractionEnabled=YES;
            
            _qingqiutype=2;
            
            self.scantext.text=@"掃描包裝箱號";
            
            if([self.charuboxjieguo[0] isEqualToString:@"OK"])
                {

                    AudioServicesPlaySystemSound(1002);
                    
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
                }
            else{
                
                [self tixing:self.charuboxjieguo[1]];
                
                }
            
            [self beginscaninboxaction];
         
        }

    });

    
    //夏雨悄下天渐凉,思人遥望东南方.
    //佳期渐至日日缓,又恐假期乱事忙.
    //东风吹散北风愁,南归秋燕盼夏凉.
    //一入风云天翻覆,江河终入海风扬.
    
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
-(void)tixing:(NSString *)str{
    
    [self playmusics];
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"未知錯誤(返回錯誤內容為空),請聯繫資訊解決:61353";
        
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
#pragma mark 清空部分数据
-(void)qingkongshuju{
    
    _xianghaolable.text=nil;
    
    _fanhuimessage.text=nil;
    
}

#pragma mark 所有数据
-(void)qingkongallshuju{
    
    _emplable.text=nil;
    
    _storageno.text=nil;
    
    _xianghaolable.text=nil;
    
    _fanhuimessage.text=nil;
    
    
}

-(void)beginscaninboxaction{
    
    _qingqiutype=7;
    
    self.scanbtn.userInteractionEnabled=YES;
    
    self.scantext.text=@"掃描包裝箱號";
    
    [self scanstorage:self.storageno.text];
    
    
}
#pragma mark  显示界面标题栏不隐藏
-(void)xianshi{
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
    
}

#pragma mark  成功提醒界面
-(void)successremind:(NSString *)str{
    
    NSUInteger len = [str length];
    
    if (len<1){
        
        str=@"未知錯誤(返回錯誤內容為空),請聯繫資訊解決:61353";
        
        }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, len)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, len)];
    
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
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
