//
//  ViewController.m
//  MotionManager
//
//  Created by MAEDA HAJIME on 2014/03/28.
//  Copyright (c) 2014年 MAEDA HAJIME. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"

// ラベル背景色
#define COLOR_PLUS(vw) vw.textColor = [UIColor yellowColor];
#define COLOR_MINUS(vw) vw.textColor = [UIColor redColor];

@interface ViewController () {
    
    // MotionManagerオブジェクト
    CMMotionManager *_cmm;

}

@property (weak, nonatomic) IBOutlet UIImageView *ivTaget;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbJiku;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 準備処理
    [self doReady];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 準備処理
- (void)doReady {
    
    // MotionManagerオブジェクト生成
    _cmm = [CMMotionManager new];
//  _cmm = [[CMMotionManager alloc] init];
    
    // 設定（加速度センサー値取得間隔（秒））
    _cmm.accelerometerUpdateInterval = 0.05;
    
    // 加速度センサー受信開始
    NSOperationQueue *que = [NSOperationQueue currentQueue];
    
    // 加速度センサー受信処理
    CMAccelerometerHandler hnd =
    ^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        // センサー値の取得
        CMAcceleration ca = accelerometerData.acceleration;
        
        // 加速度センサー値の表示
        [self showAccelerometerValue:ca];
        // ターゲット画像の移動処理
        [self moveTarget:ca];
        
    };
    
    [_cmm startAccelerometerUpdatesToQueue:que
                               withHandler:hnd];
}

// 加速度センサー値の表示
- (void)showAccelerometerValue:(CMAcceleration)accelerometerData {
    
    // X軸
    UILabel *lablx = (UILabel *) self.lbJiku[0];
    lablx.text = [NSString stringWithFormat:@"X軸：%2f", accelerometerData.x];
    
    if ( accelerometerData.x >= 0.0 ) {
        COLOR_PLUS(lablx);
    } else {
        COLOR_MINUS(lablx);
    }
    
    // Y軸
    UILabel *lably = (UILabel *) self.lbJiku[1];
    lably.text = [NSString stringWithFormat:@"Y軸：%2f", accelerometerData.y];
    
    if ( accelerometerData.y >= 0.0 ) {
        COLOR_PLUS(lably);
    } else {
        COLOR_MINUS(lably);
    }
    
    // Z軸
    UILabel *lablz = (UILabel *) self.lbJiku[2];
    lablz.text = [NSString stringWithFormat:@"Z軸：%2f", accelerometerData.z];
    
    if ( accelerometerData.z >= 0.0 ) {
        COLOR_PLUS(lablz);
    } else {
        COLOR_MINUS(lablz);
    }

}

// ターゲット画像の移動処理
- (void)moveTarget:(CMAcceleration)accelerometerData {
    
    // 移動座標の設定
    CGFloat posX = self.ivTaget.center.x +
                        (accelerometerData.x * 50.0);
    CGFloat posY = self.ivTaget.center.y -
                        (accelerometerData.y * 50.0);
    
    // 移動座標の修正
    {
        // 画面サイズ取得
        CGSize scr = [UIScreen mainScreen].bounds.size;
        //NSLog(@"1.%@", NSStringFromCGSize(scr));
        
        // ターゲット画像（スータートレックの半分のサイズを取得
        CGFloat halfX = self.ivTaget.frame.size.width / 2;
        CGFloat halfY = self.ivTaget.frame.size.height / 2;
        
        // 移動座標の閾値（しきいち）の設定
        CGFloat minX = 0.0f + halfX;
        CGFloat minY = 0.0f + halfY;
        CGFloat maxX = scr.width - halfX;
        CGFloat maxY = scr.height - halfY;
        
        // 座標の修正
        if (posX < minX) posX = minX;
        if (posY < minY) posY = minY;
        if (posX > maxX) posX = maxX;
        if (posY > maxY) posY = maxY;

    }
    
//      // 画面サイズ取得
//      CGSize scr2 = [UIScreen mainScreen].applicationFrame.size;
//      NSLog(@"2.%@", NSStringFromCGSize(scr2));
    
    
    // 位置の設定
    self.ivTaget.center = CGPointMake(posX, posY);
    
    // Z軸の判定
    if (accelerometerData.z < 0.0) {
        
        // 対象を全面配置
        [self.view bringSubviewToFront:self.ivTaget];
    } else {
        
        // 対象を後面配置
        [self.view sendSubviewToBack:self.ivTaget];

    }
    
}

@end
