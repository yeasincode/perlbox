#!/usr/bin/perl
package JavaBean;
use v5.18.0;
use Encode;

my $fieldTemplate='/**
 *{comment}
 */
private {type} {field};
';
my $getTemplate='/**
 * 获取{comment}
 * @return {field}
 */
public {type} get{method}()
{
    return {field};
}
';
my $setTemplate='/**
 *设置{comment}
 * @param {field}
 */
public void set{method}({type} {field})
{
    this.{field}={field};
}
';

Encode::_utf8_on($fieldTemplate);
Encode::_utf8_on($setTemplate);
Encode::_utf8_on($getTemplate);

sub camelStyle{
	my $word=shift;
	$word=~s/^(?:\_|\$)//;
	
	if($word=~/(?:[A-Z][a-z]+)+/){
    	$word=~s/^[A-Z]/\L$&/;
		return $word;
	}
	
  $word=lc($word);
  $word=~s/\_[a-z]/\U$&/g;
  $word=~s/\_//g;
  $word=~s/^[A-Z]/\U$&/;
  $word;
}
  
sub pascalCaseStyle{
	my $word=shift;
	$word=~s/^\_//;
	
	if($word=~/(?:[a-z]+[A-Z])+/){
    	$word=~s/^[a-z]/\U$&/;
		return $word;
	}
  $word=lc($word);
  $word=~s/\_[a-z]/\U$&/g;
  $word=~s/\_//g;
  $word=~s/^[a-z]/\U$&/;
  $word;
}
 
	
sub process{
	my ($text,$choose)=@_;	
	my $tfield= $fieldTemplate;
	chomp($text);
	if($text||defined $text){
		my @matches=($text=~/(\w+)\s?/g);
		my $len=@matches;
		if(@matches&&$len>=3){
			my $field=camelStyle($matches[0]);
			my $method=pascalCaseStyle($matches[0]);
			say $method;
			my $type=$matches[1];
	    	my $comment=$matches[2];
			if($choose eq 'get'){
				$tfield=$getTemplate;
			}
			elsif($choose eq 'set'){
				$tfield=$setTemplate;
			}
			$tfield=~s/{comment}/$comment/g;
			$tfield=~s/{type}/$type/g;
			$tfield=~s/{method}/$method/g;
			$tfield=~s/{field}/$field/g;
			return $tfield;
		}
	}
	'';
}


sub main{
	my $text=shift;
	Encode::_utf8_on($text);
	my @lines=split /\r|\n/, $text;
	my $result=''; 
	my $fields='';
	foreach my $line (@lines){
	  $fields.=process($line,'field');
		$result.= process($line,'set');
		$result.= process($line,'get');
	}
	$fields.$result;
}

1;
