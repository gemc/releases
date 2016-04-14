#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;


my %configuration = (); 


# Will require password later on 
$configuration{"dbhost"}    = $ARGV[0];
$configuration{"dbname"}    = $ARGV[1];
$configuration{"dbuser"}    = $ARGV[2];
$configuration{"dbpass"}    = "";
$configuration{"verbosity"} = $ARGV[3];


if( scalar @ARGV != 4) 
{
	print "\n Usage: \n";
	print "   upload_elements <dbhost> <dbname> <dbuser> <verbosity>\n";
 	print "   A file named <elements.txt> must be present. \n\n";
   
}
else
{
	upload_elements(%configuration);
}


