@import UIKit;

@interface UIView (APIFix)
- (UIViewController *)viewController;
@end

@implementation UIView (APIFix)

- (UIViewController *)viewController {
    if ([self.nextResponder isKindOfClass:UIViewController.class])
        return (UIViewController *)self.nextResponder;
    else
        return nil;
}
@end