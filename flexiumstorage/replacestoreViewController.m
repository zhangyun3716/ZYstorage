//
//  replacestoreViewController.m
//  flexiumstorage
//
//  Created by flexium on 2017/4/28.
//  Copyright © 2017年 FLEXium. All rights reserved.
//

#import "replacestoreViewController.h"
#import "ZYScannerView.h"

@interface replacestoreViewController ()<NSXMLParserDelegate>

@property (nonatomic, copy) NSString *currentElement;/**< 标签,xml解析 */

@property (nonatomic,strong)NSString *currentElementName;/**< 定义名称 */

@property (nonatomic,assign)BOOL isCheck;/**<  确定是否符号*/

@property (nonatomic,strong)NSString *returnresult;/**< 返回结果 */

@property (nonatomic, strong) NSXMLParser *parser;/**< xml解析代理 */

@property (strong,nonatomic)UIActivityIndicatorView *testview;/**< 菊花界面 */

@property (nonatomic, strong) NSArray *peoplemessage;/**< 人员array */

@property (nonatomic, strong) NSArray *boxmessage;/**< 箱号信息array */

@property (nonatomic, strong) NSArray *storagemessage;/**<储位信息array  */

@property (nonatomic, assign) int httptype;/**< 网络请求类型 */

- (IBAction)beginscan:(id)sender;/**< 开始扫描吧 */

@property (strong, nonatomic) IBOutlet UILabel *scanlabletext;/**< 扫描文字的lable */

@property (strong, nonatomic) IBOutlet UILabel *empno;/**< 工卡lable */

@property (strong, nonatomic) IBOutlet UILabel *inboxno;/**< 内箱信息lable */

@property (strong, nonatomic) IBOutlet UILabel *storage;/**< 储位信息lable */

@property (strong, nonatomic) IBOutlet UILabel *fanhuimessage;/**< 返回信息lable */

@end

@implementation replacestoreViewController

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
    
    self.title=@"更換儲位";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xianshi) name:@"PassValueWithNotification" object:nil ];//设置观察者
    
}

#pragma mark 清除内存
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark 开始扫描
- (IBAction)beginscan:(id)sender {
    
       self.navigationController.navigationBarHidden=YES;//上方标题栏设置为不隐藏
    
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
    //掃描箱號
    else if(_httptype==1){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描箱號" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            [self checkboxno:str];
            
            self.inboxno.text=str;
            
            self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
            
        }];
        
        
    }
    //檢查儲位
    else if(_httptype==2){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"掃描新儲位" forKey: @"textlable"];
        
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            
            [self storage:str];
            
            self.storage.text=str;
            
            self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
            
        }];
        
    }
    
}

#pragma mark 清空数据
-(void)qingkongshuju{
    
    self.inboxno.text=nil;
    
    self.empno.text=nil;
    
    self.fanhuimessage.text=nil;
    
    self.storage.text=nil;
    
    
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

#pragma mark檢查箱號
-(void)checkboxno:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/changestorages.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <checkboxno xmlns='http://tempuri.org/'> <boxno>%@</boxno> </checkboxno></soap:Body></soap:Envelope>",message];
    
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

#pragma mark檢查儲位
-(void)storage:(NSString *)message{
    
    NSString *urlStr = @"http://portal.flexium.com.cn:81/changestorages.asmx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <checknewstorage xmlns='http://tempuri.org/'><storageno>%@</storageno><boxno>%@</boxno><partno>%@</partno><userid>%@</userid> </checknewstorage></soap:Body></soap:Envelope>",message,self.boxmessage[3],self.boxmessage[2],self.peoplemessage[2]];

    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"http://tempuri.org/checknewstorage" forHTTPHeaderField:@"Action"];
    
    
    
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

            //这一步不能少！
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
    
    if ([_currentElementName isEqualToString:@"checkboxnoResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    
    if ([_currentElementName isEqualToString:@"checknewstorageResult"]) {
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
        self.boxmessage= [self.returnresult componentsSeparatedByString:@";"];
    }
    
    if ([_currentElementName isEqualToString:@"checknewstorageResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.storagemessage= [self.returnresult componentsSeparatedByString:@";"];
    }

}

#pragma mark 把上部的信息存储到数据中
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    {
    
    }

#pragma mark 解析结束数据
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //扫描工号
        if (_httptype==0) {
            
            if ([self.peoplemessage[0] isEqualToString:@"OK"]) {
                
                NSLog(@"返回了人員信息");
                
                self.empno.text=self.peoplemessage[1];
                
                _httptype=1;
                
                AudioServicesPlaySystemSound(1002);//1002

                self.scanlabletext.text=@"掃描箱號";
                
                }
            else{
                
                [self tixing:self.peoplemessage[1]];
                
            }
            
        }
        
        //扫描箱号
        else if(_httptype==1){
            
            NSLog(@"%@",self.boxmessage);
            
            if ([self.boxmessage[0] isEqualToString:@"OK"]) {
                
                _httptype=2;
                
                AudioServicesPlaySystemSound(1002);//1002

                self.scanlabletext.text=@"掃描新儲位";
                
                }
            else{
                
                _httptype=0;
                
                self.fanhuimessage.text=self.boxmessage[1];
                
                [self tixing:self.boxmessage[1]];
                
                self.scanlabletext.text=@"掃描工號";
                
            }
        }
        //扫描储位号
        else if(_httptype==2){
            
            NSLog(@"%@",self.boxmessage);
            
            if ([self.storagemessage[0] isEqualToString:@"OK"]) {
                
                _httptype=0;
                
                AudioServicesPlaySystemSound(1002);//1002

                self.fanhuimessage.text=self.storagemessage[1];
 
                [self successremind:self.storagemessage[1]];
                
                self.scanlabletext.text=@"掃描工號";
                
                }
            else{
                
                _httptype=0;
                
                self.fanhuimessage.text=self.storagemessage[1];
                
                [self tixing:self.storagemessage[1]];
                
                self.scanlabletext.text=@"掃描工號";
                
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
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"網絡錯誤"];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
    
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
        
        [_testview stopAnimating];      //  结束旋转
        
        [_testview removeFromSuperview]; //  移除旋转view
        
    });
    
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

#pragma mark  标题栏显示
-(void)xianshi{
    
    self.navigationController.navigationBarHidden=NO;//上方标题栏设置为不隐藏
    
}

#pragma mark  成功返回
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
