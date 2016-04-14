#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;


if( scalar @ARGV != 1) 
{
	print "\n Usage: \n";
	print "   upload_parameters <config filename> \n";
 	print "   A file named <paramenters.txt> must be present. \n\n";
  
}


my $config_file = $ARGV[0];


my %configuration = load_configuration($config_file); 

upload_parameters(%configuration);



