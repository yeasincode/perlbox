#!/usr/bin/perl -w
package JsonPretty;
use v5.18.0;
use JSON;
use Encode;
sub main{
	my $json_text =shift;
	my $json = JSON->new->allow_nonref;
	my $perl_scalar = $json->decode( $json_text );
	my $pretty_printed = $json->pretty->encode( $perl_scalar );
	say $pretty_printed;
	return $pretty_printed;
}

1;
