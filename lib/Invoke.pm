#!usr/bin/perl -w
package Invoke;
use v5.18.0;
use Path::Class;

sub new{
	my $class=shift;
	my $self={
		_path=>shift,
		_filename=>shift
	};
	bless $self,$class;
	$self;
}

sub execute{
	my $self=shift;
	
	my $from_text=shift;
	my $to_result='';

	unless(-f $self->{_path}){
		return '';
	}
	
	require "$self->{_path}";
	
	$to_result=eval( "$self->{_filename}::main('$from_text')");

	#my $content=$file->slurp;
	#my $file=file($self->{_path});
	#eval $content;

	$to_result;
}


1;
