HPGrowingTextView
=================

Multi-line/Autoresizing UITextView similar as in the SMS-app. The example project mimicks the look of Apple's SMS-app.

![Screenshot](http://f.cl.ly/items/270f2F3q3d3q142m140A/ss.png)

Properties
----------

```objective-c
int maxNumberOfLines; // Stops growing at this amount of lines.
int minNumberOfLines; // Starts growing at this amount of lines.
int maxHeight; // Specify the maximum height in points instead of lines.
int minHeight; // Specify the minimum height in points instead of lines.
BOOL animateHeightChange; // Animate the growing
NSTimeInterval animationDuration; // Adjust the duration of the growth animation.
```

UITextView borrowed properties
----------------

```objective-c
NSString *text;
UIFont *font;
UIColor *textColor;
NSTextAlignment textAlignment;
NSRange selectedRange;
BOOL editable;
UIDataDetectorTypes dataDetectorTypes;
UIReturnKeyType returnKeyType;
```

If you want to set other UITextView properties, use .internalTextView 

Delegate methods
---------------

```objective-c
-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
-(BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;

-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;

-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;

// Called WITHIN animation block!
-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height;

// Called after animation
-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;

-(void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;
```

For more info, see blogpost: http://www.hanspinckaers.com/multi-line-uitextview-similar-to-sms
