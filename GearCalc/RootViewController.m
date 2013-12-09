#import "RootViewController.h"

#define MAX_RPM 6500
#define MAX_SPD 240

@interface RootViewController ()
#include "root.property.h"
@property (nonatomic, strong) NSArray * gs;
@property (nonatomic, assign) CGFloat g;
@property (nonatomic, assign) CGFloat f;
@property (nonatomic, assign) CGFloat c;
@property (nonatomic, assign) CGFloat l;
@property (nonatomic, assign) CGFloat d;
@property (nonatomic, assign) CGFloat e;
@property (nonatomic, assign) CGFloat unit;
@property (nonatomic, assign) CGFloat pi;
@end

@implementation RootViewController
#include "root.synthesize.h"
@synthesize gs,g,f,c,l,d,e,unit,pi;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    gs = @[@3.42, @2.14, @1.45, @1.03, @0.81];
    g = [[gs objectAtIndex:0] floatValue];
    f = 4.07;
    c = 55;
    l = 205;
    d = 16;
    e = 0.057;
    unit = 3.6;
    pi = 3.1415926535;
    #include "root.view-did-load.h"
    [gears addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    [speedmeter addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [tachometer addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    #include "root.view-will-appear.h"
    [self displayValue];
}

- (void)viewWillLayoutSubviews {
    #include "root.view-will-layout-subviews.h"
}

- (void)segmentedValueChanged:(UISegmentedControl *)sender {
    g = [[gs objectAtIndex:[sender selectedSegmentIndex]] floatValue];
    [self updateTacho];
    [self displayValue];
}

- (void)sliderValueChanged:(UISlider *)sender {
    if (speedmeter == sender) {
        [self updateTacho];
    } else {
        [self updateSpeed];
    }
    [self displayValue];
}

- (void)updateSpeed {
    CGFloat v = [self calcSpeed:tachometer.value];
    if (v > MAX_SPD) {
        speedmeter.value = MAX_SPD;
        tachometer.value = [self calcTacho:MAX_SPD];
    } else {
        speedmeter.value = v;
    }
}

- (void)updateTacho {
    CGFloat r = [self calcTacho:speedmeter.value];
    if (r > MAX_RPM) {
        tachometer.value = MAX_RPM;
        speedmeter.value = [self calcSpeed:MAX_RPM];
    } else {
        tachometer.value = r;
    }
}

- (void)displayValue {
    tacholabel.text = [NSString stringWithFormat:@"%0.0f rpm", tachometer.value];
    speedlabel.text = [NSString stringWithFormat:@"%0.2f km/h", speedmeter.value];
}

- (CGFloat)calcSpeed:(CGFloat)r {
    CGFloat v = pi * (2 * c * l / 100000 + 0.0254 * d) * r / (60 * f * g) * unit;
    return v * (1 + e);
}

- (CGFloat)calcTacho:(CGFloat)v {
    return (60 * f * g) * v / (1 + e) / unit / pi / (2 * c * l / 100000 + 0.0254 * d);
}
@end
