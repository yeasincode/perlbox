#!/usr/bin/perl
package JavaField;
use v5.18.0;
use Encode;

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
  

sub main{
	my $text=shift;
	Encode::_utf8_on($text);
	my @lines=split /\r|\n|,/, $text;
	my $fields='';
	
	foreach my $line (@lines){
    $line =~ s/^\s+|\s+$//g;
	  $fields.=camelStyle($line)."\n";
	}
	$fields;
}

1;
