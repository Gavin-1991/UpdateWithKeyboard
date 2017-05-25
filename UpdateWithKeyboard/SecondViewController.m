//
//  SecondViewController.m
//  UpdateWithKeyboard
//
//  Created by liukai on 25/05/2017.
//  Copyright © 2017 com.liukai.updateWithKeyboard. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstrait;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.textView.inputAccessoryView = numberToolbar;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)doneWithNumberPad
{
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"9908");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
