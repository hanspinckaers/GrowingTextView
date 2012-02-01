//
//  HPTextViewInternal.m
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "HPTextViewInternal.h"


@implementation HPTextViewInternal

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

-(void)setContentOffset:(CGPoint)s
{
	if(self.tracking || self.decelerating){
		//initiated by user...
        
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
        
	} else {

		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomOffset && self.scrollEnabled){            
            UIEdgeInsets insets = self.contentInset;
            insets.bottom = 8;
            insets.top = 0;
            self.contentInset = insets;            
        }
	}
    	
	[super setContentOffset:s];
}

-(void)setContentInset:(UIEdgeInsets)s
{
	UIEdgeInsets insets = s;
	
	if(s.bottom>8) insets.bottom = 0;
	insets.top = 0;

	[super setContentInset:insets];
}

-(void)setContentSize:(CGSize)contentSize
{
    // is this an iOS5 bug? Need testing!
    if(self.contentSize.height > contentSize.height)
    {
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
    }
    
    [super setContentSize:contentSize];
}


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [placeHolderLabel release]; placeHolderLabel = nil;
  [placeholderColor release]; placeholderColor = nil;
  [placeholder release]; placeholder = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self setPlaceholder:@""];
  [self setPlaceholderColor:[UIColor lightGrayColor]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
  if( (self = [super initWithFrame:frame]) )
  {
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
  }
  return self;
}

- (void)textChanged:(NSNotification *)notification
{
  if([[self placeholder] length] == 0)
  {
    return;
  }
  
  if([[self text] length] == 0)
  {
    [[self viewWithTag:999] setAlpha:1];
  }
  else
  {
    [[self viewWithTag:999] setAlpha:0];
  }
}

- (void)setText:(NSString *)text {
  [super setText:text];
  [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
  if( [[self placeholder] length] > 0 )
  {
    if ( placeHolderLabel == nil )
    {
      placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
      placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
      placeHolderLabel.numberOfLines = 0;
      placeHolderLabel.font = self.font;
      placeHolderLabel.backgroundColor = [UIColor clearColor];
      placeHolderLabel.textColor = self.placeholderColor;
      placeHolderLabel.alpha = 0;
      placeHolderLabel.tag = 999;
      [self addSubview:placeHolderLabel];
    }
    
    placeHolderLabel.text = self.placeholder;
    [placeHolderLabel sizeToFit];
    [self sendSubviewToBack:placeHolderLabel];
  }
  
  if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
  {
    [[self viewWithTag:999] setAlpha:1];
  }
  
  [super drawRect:rect];
}

@end
