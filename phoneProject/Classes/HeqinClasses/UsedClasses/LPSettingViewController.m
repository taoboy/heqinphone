//
//  LPSettingViewController.m
//  linphone
//
//  Created by heqin on 15/11/7.
//
//

#import "LPSettingViewController.h"
#import "LPSystemUser.h"
#import "LPSystemSetting.h"
#import "LPJoinMettingViewController.h"
#import "PhoneMainView.h"

@interface LPSettingViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;

@property (weak, nonatomic) IBOutlet UILabel *serverAddressLabel;

@property (weak, nonatomic) IBOutlet UISwitch *defaultSilentVoiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSilentMovieSwitch;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

#define kLogoutAlertTag 90902

@implementation LPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 初始化各个界面信息
    [self initControls];
}

- (void)initControls {
    if ([LPSystemUser sharedUser].hasLogin == YES) {
        self.nameField.text = [LPSystemUser sharedUser].loginUserName;
        self.accountField.text = @"个人帐号";
        self.companyField.text = @"企业信息";
        
        self.logoutBtn.enabled = YES;
    }else {
        self.nameField.text = @"未登录";
        self.accountField.text = @"";
        self.companyField.text = @"";
        
        self.logoutBtn.enabled = NO;
    }
    
    self.defaultSilentVoiceSwitch.on = [LPSystemSetting sharedSetting].defaultSilence;
    self.defaultSilentMovieSwitch.on = [LPSystemSetting sharedSetting].defaultNoVideo;
    
    self.nameField.enabled = NO;
    self.accountField.enabled = NO;
    self.companyField.enabled = NO;
    
    // 显示服务器地址
    self.serverAddressLabel.text = [LPSystemSetting sharedSetting].sipDomainStr;
    
    self.versionLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

- (void)bgTap:(UITapGestureRecognizer *)tapGesture {
    [self.nameField resignFirstResponder];
    [self.accountField resignFirstResponder];
    [self.companyField resignFirstResponder];
}

// 注销按钮
- (IBAction)logoutBtnClicked:(id)sender {
    LinphoneCore* lc = [LinphoneManager getLc];
    if ( linphone_core_get_default_proxy_config(lc) == NULL ) {
        return;
    }
    
    UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认要注销么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    tipAlert.tag = kLogoutAlertTag;
    [tipAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if (alertView.tag == kLogoutAlertTag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            LinphoneCore* lc = [LinphoneManager getLc];
            linphone_core_clear_proxy_config(lc);
            linphone_core_clear_all_auth_info(lc);
            
            [LPSystemUser sharedUser].hasLogin = NO;
            
            // 切回到登录首页
            [[PhoneMainView instance] changeCurrentView:[LPJoinMettingViewController compositeViewDescription]];
        }
    }
}

// 静音
- (IBAction)defaultVoiceSwitched:(id)sender {
    [LPSystemSetting sharedSetting].defaultSilence = ((UISwitch *)sender).on;
}

// 静画
- (IBAction)defaultMovieSwitched:(id)sender {
    [LPSystemSetting sharedSetting].defaultNoVideo = ((UISwitch *)sender).on;
}

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if(compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:@"Setting"
                                                                content:@"LPSettingViewController"
                                                               stateBar:nil
                                                        stateBarEnabled:false
                                                                 tabBar:@"LPJoinBarViewController"
                                                          tabBarEnabled:true
                                                             fullscreen:false
                                                          landscapeMode:[LinphoneManager runningOnIpad]
                                                           portraitMode:true];
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}

@end
