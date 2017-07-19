//
//  repeatworkViewController.m
//  flexiumstorage
//  Created by flexium on 2017/4/28.
//  Copyright © 2017年 FLEXium. All rights reserved.
//

#import "repeatworkViewController.h"

#import "ZYScannerView.h"

@interface repeatworkViewController ()<NSXMLParserDelegate>

@property (nonatomic, copy) NSString *currentElement;/**< xml解析标签 */

@property (nonatomic,strong)NSString *currentElementName;/**< xml解析的标签对比 */

@property (nonatomic,assign)BOOL isCheck;/**<标签判断  */

@property (nonatomic,strong)NSString *returnresult;/**< 返回数据未分割 */

@property (nonatomic, strong) NSXMLParser *parser;/**<xml解析代理  */

@property (strong,nonatomic)UIActivityIndicatorView *testview;/**< 菊花界面 */

@property (nonatomic, strong) NSArray *peoplemessage;/**< 人员信息array */

@property (nonatomic, strong) NSArray *boxnomessage;/**< 彩盒信息array */

@property (nonatomic, strong) NSArray *reworkmesage;/**<工单信息array  */

@property (nonatomic, strong) NSArray *insertreworkmessage;/**< 插入工单记录返回array */

@property (nonatomic, strong) NSArray *updateboxmessage;/**< 更新入库记录array */

//請求數據類型0：請求工號 1：請求工單號 2：請求彩盒 3：插入重工工單記錄 4：更新彩盒數據記錄 5：更新內箱信息
@property (nonatomic, assign) int httptype;/**< 网络请求类型 */

@property (nonatomic, strong) NSString * reworkno;/**<重工工单号码  */

@property (nonatomic, strong) NSString * xianghao;/**< 箱号号的外箱号码 */

@property (nonatomic, strong) NSString * boxno;/**< 箱号 */

@property (strong, nonatomic) IBOutlet UILabel *empnolable;/**<工号lable  */

@property (strong, nonatomic) IBOutlet UILabel *reworknolable;/**< 重工工单号码 */

@property (strong, nonatomic) IBOutlet UILabel *boxnolable;/**< 箱号号码 */

@property (strong, nonatomic) IBOutlet UILabel *gongdnashulianglable;/**< 工单数量 */

@property (strong, nonatomic) IBOutlet UILabel *fanhuimessagelable;/**< 返回信息lable */
- (IBAction)beginscan:(id)sender;/**<  开始扫描*/

@property (strong, nonatomic) IBOutlet UILabel *beginscantext;/**< 开始扫描text */

@property (strong, nonatomic) NSString *zhongshuliang;/**< 总数量统计 */

@end

@implementation repeatworkViewController

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
#pragma mark 界面显示中
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title=@"重工單BY箱號";
    
    _httptype=0;
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xianshi) name:@"PassValueWithNotification" object:nil ];//设置观察者
    
    
}
#pragma mark 清空数据
-(void)qingkongshuju{
    
    self.empnolable.text=nil;
    
    self.boxnolable.text=nil;
    
    self.reworknolable.text=nil;
    
    self.fanhuimessagelable.text=nil;
    
    _gongdnashulianglable.text=nil;
    
}
#pragma mark 清空部分数据
-(void)qingkongbufengshuju{
    
    self.boxnolable.text=nil;
    
    self.fanhuimessagelable.text=nil;
    
    _gongdnashulianglable.text=nil;
    
    
}


#pragma mark 开始扫描
- (IBAction)beginscan:(id)sender {
    
     self.navigationController.navigationBarHidden=YES;//上方标题栏设置为隐藏
   
    //訪問員工服務
    if (_httptype==0) {
        
        [self qingkongshuju];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描工卡" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            NSLog(@"%@",str);
            
            [self scanempno:str];
            
             self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
            
        }];
    }
    //掃描重工工單
    else if(_httptype==1){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描彩重工工單" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            [self checkreturnworkno:str];
            
            _reworkno=str;
            
            self.reworknolable.text=str;
            
            self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
            
        }];
    }
    //掃描箱號
    else if(_httptype==2){
        
        [self qingkongbufengshuju];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描箱號外標籤" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            self.xianghao=str;
            
            [self checkboxno:str];
            
            self.boxnolable.text=str;
            
            self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
            
        }];
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
            
            }
        else {
            
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
#pragma mark 掃描重工工單
-(void)checkreturnworkno:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstorebyboxno.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkreworkno xmlns='http://tempuri.org/'><workno>%@</workno></checkreworkno> </soap:Body> </soap:Envelope>",message];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checkreworkno" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
            }
        else {
            
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
#pragma mark 掃描箱号
-(void)checkboxno:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstorebyboxno.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><checkboxno xmlns='http://tempuri.org/'><boxno>%@</boxno></checkboxno></soap:Body></soap:Envelope>",message];
    
    NSLog(@"%@",str1);
    
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
            
            [self intenererror];
            
            }
        else {
            
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
#pragma mark 插入重工記錄表并更新入库数据
-(void)insertreworklist:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstorebyboxno.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    int zhongliang=[self.boxnomessage[2]intValue]+[self.boxnomessage[3]intValue];
    
    NSString *zhongliangstr=[NSString stringWithFormat:@"%d",zhongliang];
    
    NSLog(@"%@",zhongliangstr);
    
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <insertreworklist xmlns='http://tempuri.org/'><WORKORDER>%@</WORKORDER> <BOXNO>%@</BOXNO><TARGETQTY>%@</TARGETQTY><REWORKQTY>%@</REWORKQTY></insertreworklist> </soap:Body></soap:Envelope>",_reworkno,self.xianghao,self.reworkmesage[1],zhongliangstr];
    
    NSLog(@"%@",str1);
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/insertreworklist" forHTTPHeaderField:@"Action"];

    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
            }
        else {
            
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

#pragma mark 删除内箱信息并插入历史记录
-(void)updateboxno:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/outstorebyboxno.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <insertbox xmlns='http://tempuri.org/'><userid>%@</userid><boxno>%@</boxno>  </insertbox> </soap:Body></soap:Envelope>",self.peoplemessage[2],self.xianghao];
    
    NSLog(@"%@",str1);
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/updatecaihe" forHTTPHeaderField:@"Action"];
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"请求数据出错!----%@",error.description);
            
            [self intenererror];
            
            }
        else {
            
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
    
    if ([_currentElementName isEqualToString:@"checkreworknoResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"checkboxnoResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"insertreworklistResult"]) {
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
    
    //檢查人員工號
    if ([_currentElementName isEqualToString:@"checkempResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.peoplemessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    //檢查箱号
    if ([_currentElementName isEqualToString:@"checkboxnoResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.boxnomessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    //檢查重工工單
    if ([_currentElementName isEqualToString:@"checkreworknoResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.reworkmesage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    //插入重工記錄表
    if ([_currentElementName isEqualToString:@"insertreworklistResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.insertreworkmessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    //更新入庫資料
    if ([_currentElementName isEqualToString:@"insertboxResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.updateboxmessage= [self.returnresult componentsSeparatedByString:@";"];
    }
   
  }

#pragma mark 把上部的信息存储到数据中
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}
#pragma mark 解析结束数据
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_httptype==0) {
            
            if ([self.peoplemessage[0] isEqualToString:@"OK"]) {
                
                NSLog(@"返回了人員信息");
                
                 AudioServicesPlaySystemSound(1002);
                
                self.empnolable.text=self.peoplemessage[1];
                
                _httptype=1;
                
                self.beginscantext.text=@"掃描重工工單";
                
            }else{
                
                [self tixing:self.peoplemessage[1]];
            }
            
        }
        //重工工單信息
        else if(_httptype==1||_httptype==5){
            
            if (_httptype==1) {
                
                NSLog(@"重工工單信息：%@",self.reworkmesage);
                
                if ([self.reworkmesage[0] isEqualToString:@"OK"]) {
                    
                    _httptype=2;
                    
                    self.gongdnashulianglable.text=[NSString stringWithFormat:@"%@/%@",self.reworkmesage[2],self.reworkmesage[1]];
                    
                    self.beginscantext.text=@"掃描箱號";
                    
                    self.zhongshuliang=self.reworkmesage[2];
                    
                    
                     AudioServicesPlaySystemSound(1002);
                    
                }else{
                    
                    _httptype=1;
                    
                    self.fanhuimessagelable.text=self.reworkmesage[1];
                    
                    [self tixing:self.reworkmesage[1]];
                    
                    self.beginscantext.text=@"掃描重工工單";
                    
                }

            }else{
                
                 int zhongliang=[self.boxnomessage[2]intValue]+[self.boxnomessage[3]intValue];
                
                  if ([self.reworkmesage[1] intValue]>([self.reworkmesage[2] intValue]+zhongliang)) {
                      
                      self.zhongshuliang=[NSString stringWithFormat:@"%d",[self.reworkmesage[2] intValue]+zhongliang];
                      
                        self.gongdnashulianglable.text=[NSString stringWithFormat:@"%@/%@",self.zhongshuliang,self.reworkmesage[1]];
                      
                          _httptype=3;
                      
                          [self insertreworklist:@"miracle_zhang"];
                      
                      //插入數據庫
                      }else{
                          
                          _httptype=2;
                          
                          self.zhongshuliang=[NSString stringWithFormat:@"%d",[self.reworkmesage[2] intValue]+zhongliang];
                          
                          self.gongdnashulianglable.text=[NSString stringWithFormat:@"%@/%@",self.zhongshuliang,self.reworkmesage[1]];
                          
                          self.beginscantext.text=@"掃描箱號";
                          
                          self.fanhuimessagelable.text=@"工單量已滿，無法出貨";
                          
                          [self tixing:@"工單量已滿，無法重工"];
                          
                      }
                
            }
            
            
        }
        //掃碼箱号
  else if(_httptype==2){
      
            NSLog(@"内箱信息：%@",self.boxnomessage);
      
     if ([self.boxnomessage[0] isEqualToString:@"OK"]) {

         _httptype=5;
         
         [self checkreturnworkno:self.reworknolable.text];
         
            }
     else{
                _httptype=2;
         
                self.fanhuimessagelable.text=self.boxnomessage[1];
         
                [self tixing:self.boxnomessage[1]];
         
                self.beginscantext.text=@"掃描箱號";
         
            }
        }
        //插入重工歷史記錄表并更新入库信息
        else if(_httptype==3){
            
                if([_insertreworkmessage[0] isEqualToString:@"OK"]){
                    
                    _httptype=4;
                    
                    [self updateboxno:@"dandan"];
                    
                    
                }
                else{
                    
                   self.fanhuimessagelable.text=self.insertreworkmessage[1];
                    
                   [self tixing:self.insertreworkmessage[1]];
                    
                    _httptype=2;
                    
                    self.beginscantext.text=@"掃描箱號";
                    
            }
        }
        //更新内箱數據記錄删除内向资料
        else if(_httptype==4){
            
            NSLog(@"更新彩盒數據記錄：%@",self.updateboxmessage);
            
            if([self.updateboxmessage[0] isEqualToString:@"OK"]){

                [self successremind:self.updateboxmessage[1]];
                
                self.fanhuimessagelable.text=self.updateboxmessage[1];
                
                  _httptype=2;
                
                  self.beginscantext.text=@"掃描箱號";
                
                }
            else{
                
                _httptype=2;
                
                self.fanhuimessagelable.text=self.updateboxmessage[1];
                
                [self tixing:self.updateboxmessage[1]];
                
                self.beginscantext.text=@"掃描箱號";
                
                }
        }
        
    });
    
    
}


#pragma mark 網絡錯誤提示界面
-(void)intenererror{
    
    [self endjuhua];
    
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
    
    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    
    [testActivityIndicator setFrame :CGRectMake(100, 200, 100, 100)];//不建议这样设置，因为
    
    [self.view addSubview:testActivityIndicator];
    
    testActivityIndicator.color = [UIColor greenColor]; // 改变圈圈的颜色为红色； iOS5引入
    
    [testActivityIndicator startAnimating]; // 开始旋转
    
    self.testview=testActivityIndicator;
    
}
#pragma mark 结束并移除菊花界面
-(void)endjuhua{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_testview stopAnimating]; // 结束旋转
        
        [_testview removeFromSuperview]; //当旋转结束时移除
        
    });
}

#pragma mark  显示,标题栏显示设置为不隐藏
-(void)xianshi{
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
    
}

#pragma mark  成功返回数据
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
