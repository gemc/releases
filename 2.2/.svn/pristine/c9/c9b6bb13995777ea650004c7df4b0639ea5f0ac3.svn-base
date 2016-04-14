package materials;
require Exporter;

use lib ("$ENV{GEMC}/io");
use utils;
use 5.010;

@ISA = qw(Exporter);
@EXPORT = qw(init_mat print_mat);


# Initialize hash maps
sub init_mat
{
	my %mat = ();
	
	# The default value for identifier is "id"
	$mat{"description"} = "id";
	
	# The optical properties are defaulted to none
	# User can define a optical property with arrays of:
	#
	# - photon wavelength (mandatory)
	# - At least one of the following quantities arrays
	$mat{"photonEnergy"}      = "none";
	$mat{"indexOfRefraction"} = "none";
	$mat{"absorptionLength"}  = "none";
	$mat{"reflectivity"}      = "none";
	$mat{"efficiency"}        = "none";
	
	return %mat;
}


# Print material to TEXT file or upload it onto the DB
sub print_mat
{
	my %configuration = %{+shift};
	my %mats          = %{+shift};
	
	my $table   = $configuration{"detector_name"}."__materials";
	my $varia   = $configuration{"variation"};
	
	# converting the hash maps in local variables
	# (this is necessary to parse the MYSQL command)
	my $lname              = trim($mats{"name"});
	my $ldesc              = trim($mats{"description"});
	my $ldensity           = trim($mats{"density"});
	my $lncomponents       = trim($mats{"ncomponents"});
	my $lcomponents        = trim($mats{"components"});
	my $lphotonEnergy      = trim($mats{"photonEnergy"});
	my $lindexOfRefraction = trim($mats{"indexOfRefraction"});
	my $labsorptionLength  = trim($mats{"absorptionLength"});
	my $lreflectivity      = trim($mats{"reflectivity"});
	my $lefficiency        = trim($mats{"efficiency"});

	# after 5.10 once can use "state" to use a static variable`
	state $counter = 0;
	state $this_variation = "";
	
	# TEXT Factory
	if($configuration{"factory"} eq "TEXT")
	{
		my $file = $configuration{"detector_name"}."__materials_".$varia.".txt";
		
		if($counter == 0 || $this_variation ne  $varia)
		{
			`rm -f $file`;
			print "Overwriting if existing: ",  $file, "\n";
			$counter = 1;
			$this_variation = $varia;
		}
		
		open(INFO, ">>$file");
		printf INFO ("%20s  |",  $lname);
		printf INFO ("%30s  |",  $ldesc);
		printf INFO ("%10s  |",  $ldensity);
		printf INFO ("%10s  |",  $lncomponents);
		printf INFO ("%50s  |",  $lcomponents);
		
		
		
		if($lphotonEnergy eq "none")
		{
			printf INFO ("%5s  |",  $lphotonEnergy);
			printf INFO ("%5s  |",  $lindexOfRefraction);
			printf INFO ("%5s  |",  $labsorptionLength);
			printf INFO ("%5s  |",  $lreflectivity);
			printf INFO ("%5s  \n", $lefficiency);
		}
		else
		{
			printf INFO ("%s  |", $lphotonEnergy);
			
			# index of refraction
			if($lindexOfRefraction eq "none"){	printf INFO ("%5s |", $lindexOfRefraction);}
			else                             {	printf INFO ("%s  |", $lindexOfRefraction);}
			# absorption length
			if($labsorptionLength eq "none") {	printf INFO ("%5s |", $labsorptionLength);}
			else                             {  printf INFO ("%s  |", $labsorptionLength);}
			# reflectivity
			if($lreflectivity eq "none")     {  printf INFO ("%5s |", $lreflectivity);}
			else                             {	printf INFO ("%s  |", $lreflectivity);}
			# efficiency
			if($lefficiency eq "none")       {	printf INFO ("%5s\n", $lefficiency);}
			else                             {	printf INFO ("%s \n", $lefficiency);}
		}
		
		close(INFO);
	}
	
	# MYSQL Factory
	my $err;
	if($configuration{"factory"} eq "MYSQL")
	{
		my $dbh = open_db(%configuration);
		
		$dbh->do("insert into $table( \
			          name,     description,     density,    ncomponents,    components,    photonEnergy,    indexOfRefraction,    absorptionLength,    reflectivity,   efficiency,   variation) \
			values(      ?,               ?,           ?,              ?,             ?,               ?,                    ?,                   ?,               ?,            ?,           ?) ON DUPLICATE KEY UPDATE \
			        name=?,   description=?,   density=?,  ncomponents=?,  components=?,  photonEnergy=?,  indexOfRefraction=?,  absorptionLength=?,  reflectivity=?, efficiency=?, variation=?, \
			        time=CURRENT_TIMESTAMP",  undef,
			        $lname,          $ldesc,   $ldensity,  $lncomponents,  $lcomponents,  $lphotonEnergy,  $lindexOfRefraction,  $labsorptionLength,  $lreflectivity, $lefficiency,      $varia,
			        $lname,          $ldesc,   $ldensity,  $lncomponents,  $lcomponents,  $lphotonEnergy,  $lindexOfRefraction,  $labsorptionLength,  $lreflectivity, $lefficiency,      $varia)
			
			or die "SQL Error: $DBI::errstr\n";
		
		$dbh->disconnect();
	}
	
	if($configuration{"verbosity"} > 0)
	{
		print "  + Material $lname uploaded successfully for variation \"$varia\" \n";
	}
}


1;





