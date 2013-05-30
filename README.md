HPGrowingTextView
=================

Multi-line/Autoresizing UITextView similar to SMS-app. The example project also even looks like Apple's version.

![Screenshot](http://f.cl.ly/items/270f2F3q3d3q142m140A/ss.png)

Properties
----------
* `int maxNumberOfLines;` – Stops growing at this amount of lines.
* `int minNumberOfLines;` – Starts growing at this amount of lines.
* `BOOL animateHeightChange;` – Animate the growing
* `NSTimeInterval animationDuration;` – Adjust the duration of the growth animation.

UITextView properties

	NSString *text;
	UIFont *font;
	UIColor *textColor;
	UITextAlignment textAlignment;
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;

Delegate methods
---------------

	-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
	-(BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;
 
	-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
	-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;
 
	-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange(NSRange)range replacementText:(NSString *)text;
	-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;
 
	Called WITHIN animation block!
	-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height;
 
	Called after animation
	-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;
 
	-(void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
	-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;

For more info, see blogpost: http://www.hanspinckaers.com/multi-line-uitextview-similar-to-sms
