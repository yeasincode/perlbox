#!/usr/bin/perl -w
package SqlPretty;
use v5.18.0;
use SQL::Beautify;
sub main{
	my $sql_text =shift;
	my $sql = SQL::Beautify->new;
	$sql->query($sql_text);
	my $nice_sql = $sql->beautify;
	say $nice_sql;
	return $nice_sql;
}

1;
