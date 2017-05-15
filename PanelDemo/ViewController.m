//
//  ViewController.m
//  PanelDemo
//
//  Created by leimo on 2017/5/12.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "ViewController.h"
#import "PanelView.h"

@interface ViewController ()

/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic,assign)  NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    PanelView *view = [[PanelView alloc] initWithFrame:CGRectMake(40, 100, self.view.frame.size.width - 80, self.view.frame.size.width - 80)];
    [self.view addSubview:view];
    
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    _count = 0;
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);
        
        _count ++;
        CGFloat angle = (M_PI * 2 * 0.75 / 30);

        [UIView animateWithDuration:1 animations:^{
            
            view.pointerImgView.transform = CGAffineTransformMakeRotation(_count * angle );
            
            
        }];
        
        
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
    
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
