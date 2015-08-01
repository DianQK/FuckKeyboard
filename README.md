# 在 AutoLayout 布局下处理键盘挡住视图问题    

很简短的一篇文章，记录一个在实习期间 Get 的机智方案，制作一个登录界面的时候遇到这样一个问题，当把 **UITextField** 放在下面的时候，弹出的键盘会挡住该 **UITextField** 视图， GitHub 上有很多开源项目来解决这个问题，比如 [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) 和 [IHKeyboardAvoiding](https://github.com/IdleHandsApps/IHKeyboardAvoiding) ，用起来便捷、效果也不错，适应性很强。    
但是并没有很好的满足我的需求，不同的 **UIView** 有不同的效果，最好不要是将整个视图都向上移动，这样我感觉怪怪的。 以及 **QKeyboardManager** 还会出现点击不同 **UITextField** 视图再次移动的怪怪效果。  
> 用户的感受可能是：   
> 我勒个去，我就输个信息登录一下，整个屏幕都要移过去。（我猜的～）   

所以！我们来亲自用一种相对简洁的方式来处理键盘这个坑。实际业务开发中，大多视图的搭建都是在 SB 或者 xib 中，布局多是使用 **AutoLayout** 。那么进行视图的移动总是一种麻烦的事情，其实不然，在 AutoLayout 中处理动画可能会更方便一些。不需要过多的计算视图的大小、位置。    
先来推荐本书 **[《iOS Auto Layout开发秘籍（第2版）》](http://item.jd.com/11600193.html)** ，本书中写了很多 AutoLayout 的处理方案，也写出一套类别可以用来便捷处理 AutoLayout 。    
先上个 Demo **[FuckKeyboard](https://github.com/DianQK/FuckKeyboard)** ，方法很简单，关键点来源于前面推荐的书提到了布局当中可以对一个视图添加四个以上的约束，并更改对应约束的 **Priority** 。这样当添加一个视图在出现冲突时，会去满足优先级高的约束，而去高优先级的约束又不会因为约束条件不足出现视图丢失。    
先上效果（图片还是略大 7.4 MB）：    

<center>
![](https://raw.githubusercontent.com/DianQK/FuckKeyboard/master/Screenshots/FuckKeyboardScreenshots.gif)
</center>       

看起来还是凑合的哈～（没有考虑 5s 等设备，运行时请尽量选择 iPhone 6 ）。本动态图中的需求是登录按钮和输入框都向上移动，头像变小。以登录按钮和输入框举例，设置约束如图：   

<center>
![](http://ww2.sinaimg.cn/mw690/89f500a9jw1eung362hizj20930gqq42.jpg)
</center>       

虚线是什么？低优先级的约束。这里的布局大概是这样的： Login 按钮距底部为30，输入框距离按钮为10，这样设置的好处是什么呢？键盘弹出的时候只去打破虚线的约束，其他不变，然而这些位置都是基于按钮的位置的，所以只要去更改按钮距底部的约束就好啦。现在要做的就只是添加一个高优先级约束，键盘收起来的时候删除这个约束。代码如下：  
 
```Objective-C
- (void)updateViewConstraintsForKeyboardHeight:(CGFloat)keyboardHeight {
    if (_bottomConstraint) {
        [self.view removeConstraint:_bottomConstraint];
        _bottomConstraint = nil;
    }
    if (keyboardHeight) {
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.loginButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:keyboardHeight + 10];
        [self.view addConstraint:_bottomConstraint];
    }
    [self.view layoutIfNeeded];
}
```    
注意不需要去设置优先级，默认就是1000，效果还不错哈～     
> PS:     
> 最近在实习，积累开发经验，做些总结，上面这个键盘问题只是一个小 Tip 。     
> 有帅哥、有美女、嗯，好。
