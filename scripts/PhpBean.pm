#!/usr/bin/perl
package PhpBean;
use v5.18.0;
use Encode;

my $fieldTemplate='/**
 *{comment}
 */
private ${field};
';

my $getAndSetTemplate='/**
 *获取或设置{comment}
 * @param {field}
 */
public function {field}(${field}=null)
{
    if(isset(${field})){
      $this->{field}=${field};
      return $this;
    }
    return $this->{field};
}
';

Encode::_utf8_on($fieldTemplate);
Encode::_utf8_on($getAndSetTemplate);

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
		if(@matches&&$len>=2){
			my $field=camelStyle($matches[0]);
			my $method=pascalCaseStyle($matches[0]);
			say $method;
	    my $comment=$matches[1];
	    	
			if($choose eq 'get_set'){
				$tfield=$getAndSetTemplate;
			}
			
			$tfield=~s/{comment}/$comment/g;
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
		$result.= process($line,'get_set');
	}
	$fields.$result;
}

1;
