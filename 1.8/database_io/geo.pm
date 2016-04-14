package geo;
require Exporter;
require DBD::mysql;

@ISA = qw(Exporter);
@EXPORT = qw($pi $inches asind phi theta cnumber print_det rad trim load_configuration upload_parameters  print_parameters download_parameters upload_elements upload_materials print_materials upload_opt_properties print_opt_properties);
#@EXPORT = qw($pi asin phi theta cnumber print_det rad load_configuration tan  atan  asind acos rad2deg);

$pi     = 3.141592653589793238;
$inches = 2.54;
use Math::Trig;

sub asind {asin($_[0])*180/$pi}


sub phi
{
	my $x = $_[0];
	my $y = $_[1];
	my $z = $_[2];
	
	my $phi = 0.0;
	if($y > 0.0)
	{
		$phi = acos($x/sqrt($x*$x+$y*$y));
	}
	if($y < 0.0)
	{
    $phi =  2*3.141592654 - acos($x/sqrt($x*$x+$y*$y));
	}
	if($y == 0.0 && $x<0)
	{
    $phi =  2*3.141592654;
	}
	return $phi;
}

sub theta
{
	my $x = $_[0];
	my $y = $_[1];
	my $z = $_[2];
	
	my $theta = 0.0;
	
	if($x*$x+$y*$y+$z*$z)
	{
		$theta =  acos($z/sqrt($x*$x+$y*$y+$z*$z));
	}
	
	return $theta;
}


sub cnumber
{
	my $s   = shift;
	my $max = shift;
	
	my $zeros = "";
	if($s < 9 && $max == 10)  { $zeros =  "0"; }
	if($s < 9 && $max == 100) { $zeros = "00"; }
	
	if($max == 100 && $s > 9) { $zeros =  "0"; }
	
	
	my $segment_n = $s + 1;
	return "$zeros$segment_n";
}

sub print_det
{
	my (%det)  = %{$_[0]};
	my $file   = $_[1];
	
	open(INFO, ">>$file");
	
	print INFO $det{"name"}."\t";
	print INFO $det{"mother"}."\t";
	print INFO $det{"description"}."\t";
	print INFO $det{"pos"}."\t";
	print INFO $det{"rotation"}."\t";
	print INFO $det{"color"}."\t";
	print INFO $det{"type"}."\t";
	print INFO $det{"dimensions"}."\t";
	print INFO $det{"material"}."\t";
	print INFO $det{"mfield"}."\t";
	print INFO $det{"ncopy"}."\t";
	print INFO $det{"pMany"}."\t";
	print INFO $det{"exist"}."\t";
	print INFO $det{"visible"}."\t";
	print INFO $det{"style"}."\t";
	print INFO $det{"sensitivity"}."\t";
	print INFO $det{"hit_type"}."\t";
	print INFO $det{"identifiers"}."\t";
	print INFO $det{"rmin"}."\t";
	print INFO $det{"rmax"}."\n";
	
	close(INFO);
}

sub rad
{
	my $angle     = $_[0];
	my $angle_rad = $_[0]*$pi/180;
}

# Remove whitespaces from a string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

# Load configuration file
sub load_configuration
{
	my $file   = $_[0];
	my %configuration = (); 
	
	open (CONFIG, "$file") or die("Open failed on $file :$!");
	
	while (<CONFIG>) 
	{
	  s/#.*//;            # ignore comments by erasing them
		next if /^(\s)*$/;  # skip blank lines
		
		chomp;              # remove trailing newline characters
		push @lines, $_;    # push the data line onto the array
	
		my ($key, $val) = split /:/;
		$configuration{trim($key)} = trim($val);
	
	}

	# Printing out the configuration is a way to double check 
	# That all mandatory values exist
	if($configuration{"verbosity"} > 0)
	{
		print "\n >> Loading configuration from ", $file , ":\n";
		print "  > Geo Table:    ", $configuration{"geometry_table"}, "\n";
		print "  > Author:       ", $configuration{"author"},         "\n";
		print "  > Author email: ", $configuration{"author_email"},   "\n";
		print "  > DB Server:    ", $configuration{"dbhost"},         "\n";
		print "  > DB Name:      ", $configuration{"dbname"},         "\n";
		print "  > DB User:      ", $configuration{"dbuser"},         "\n";
		print "  > DB Password:  ", $configuration{"dbpass"},         "\n";
		print "  > Run Min:      ", $configuration{"run_min"},        "\n";
		print "  > Run Max:      ", $configuration{"run_max"},        "\n";
		print "  > Verbosity:    ", $configuration{"verbosity"},      "\n";
		print "\n";
	}
	return %configuration;
}


sub upload_parameters
{
	my (%configuration)   = @_;

	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);

	my $table = $configuration{"geometry_table"}."__parameters";
	

	# Drop the table if it exists
	if($configuration{"verbosity"} > 0)
	{
		print " > Replacing table ", $table, "\n\n";
	}
	$dbh->do("drop table if exists $table");

	# Createx new table	
	$dbh->do("create table $table (            \
		name              VARCHAR(250) UNIQUE,   \
		value             FLOAT,                 \
		units             VARCHAR(50),           \
		description       VARCHAR(250),          \
		author            VARCHAR(250),          \
		author_email      VARCHAR(250),          \
		pdf_drawing_link  VARCHAR(250),          \
		drawing_varname   VARCHAR(250),          \
		drawing_authors   VARCHAR(250),          \
		drawing_date      VARCHAR(250),          \
		upload_date       TIMESTAMP
	)");
	
	# Loading parameters into table
	$dbh->do("LOAD DATA LOCAL INFILE 'parameters.txt' \ 
		INTO TABLE $table                               \ 
		FIELDS TERMINATED BY '|'                        \
		LINES TERMINATED BY '\n'                        \ 
		(name, value, units, description, author, author_email, pdf_drawing_link, drawing_varname, drawing_authors, drawing_date)");
	
	if($configuration{"verbosity"} > 1)
	{
		print " * Complete List of Parameters uploaded in database: \n";
		print_parameters(%configuration);
		print " \n";
	}
}




sub print_parameters
{
	my (%configuration)   = @_;
	
	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
	
	my $table = $configuration{"geometry_table"}."__parameters";

	$query = $dbh->prepare("SELECT * from $table");
	$query->execute();
	
	while (@data = $query->fetchrow_array()) 
	{
		my $pnam = $data[0];
		my $pval = $data[1];
		my $puni = $data[2];
		my $pdes = $data[3];
		my $paut = $data[4];
		my $pema = $data[5];
		my $plin = $data[6];
		my $pdna = $data[7];
		my $pdau = $data[8];
		my $pdda = $data[9];
		print " * Parameter: $pnam \n";
		print " * Value: $pval $puni \n";
		print " * Description: $pdes \n";
		print " * Author: $paut   email:  $pema \n";
		print " * Link to Drawing or Document: $plin \n";
		print " * Variable name on the drawing: $pdna \n";
		print " * Drawing Author: $pdau. Date: $pdda \n\n";
	}

}

sub download_parameters
{
	my (%configuration)   = @_;
	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
	
	my $table = $configuration{"geometry_table"}."__parameters";
	my %parameters = (); 
	
	$query = $dbh->prepare("SELECT * from $table ");
	$query->execute();
	

	while (@data = $query->fetchrow_array()) 
	{
		my $pnam = $data[0];
		my $pval = $data[1];
		my $puni = $data[2];
		
		$parameters{trim($pnam)} = trim($pval);

		if($configuration{"verbosity"} > 0)
		{
			print " * Parameter $pnam loaded with value: $pval $puni \n";
		}
	}
	print "\n";
	return %parameters;
}


sub upload_elements
{
	my (%configuration)   = @_;
  
	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
  
	my $table = "materials__elements";
	
  
	# Drop the table if it exists
	if($configuration{"verbosity"} > 0)
	{
		print " > Replacing table ", $table, "\n\n";
	}
	$dbh->do("drop table if exists $table");
  
	# Createx new table	
	$dbh->do("create table $table (            \
		name              VARCHAR(250) UNIQUE,   \
		symbol            VARCHAR(10),           \
		atomic_number     INT,                   \
  	molar_mass        FLOAT,                 \
		upload_date       TIMESTAMP
    )");
    
  # Loading parameters into table
	$dbh->do("LOAD DATA LOCAL INFILE 'elements.txt'           \ 
            INTO TABLE $table                               \ 
            FIELDS TERMINATED BY '|'                        \
            LINES TERMINATED BY '\n'                        \ 
            (name, symbol, atomic_number, molar_mass)");
      
  if($configuration{"verbosity"} > 1)
	{
		print " * Complete List of elements uploaded in database: \n";
		print_elements(%configuration);
		print " \n";
	}
}




sub print_elements
{
	my (%configuration)   = @_;
	
	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
	
	my $table = materials__elements;
  
	$query = $dbh->prepare("SELECT * from $table");
	$query->execute();
	
	while (@data = $query->fetchrow_array()) 
	{
		my $enam = $data[0];
		my $esym = $data[1];
		my $eatn = $data[2];
		my $emom = $data[3];
		print " * Element: $enam \n";
		print " * Symbol: $esym \n";
		print " * Atomic Mass: $eatn \n";
		print " * Molar Mass (g/mol): $emom \n\n";
	}
  
}


sub upload_materials
{
	my (%configuration)   = @_;
  
	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
  
	my $table = $configuration{"geometry_table"}."__materials";
	
  
	# Drop the table if it exists
	if($configuration{"verbosity"} > 0)
	{
		print " > Replacing table ", $table, "\n\n";
	}
	$dbh->do("drop table if exists $table");
  
	# Createx new table	
	$dbh->do("create table $table (          \
		name            VARCHAR(100) UNIQUE,   \
		density         FLOAT,                 \
		nelements       INT,                   \
		elements        VARCHAR(250),          \
		upload_date     TIMESTAMP
    )");
    
  # Loading parameters into table
  $dbh->do("LOAD DATA LOCAL INFILE 'materials.txt'  \ 
    INTO TABLE $table                               \ 
    FIELDS TERMINATED BY '|'                        \
    LINES TERMINATED BY '\n'                        \ 
    (name, density, nelements, elements)");
      
  if($configuration{"verbosity"} > 1)
	{
		print " * Complete List of Materials uploaded in database: \n";
		print_materials(%configuration);
		print " \n";
	}
}



sub print_materials
{
	my (%configuration)   = @_;
	
	my $db    = $configuration{"dbname"};
	my $host  = $configuration{"dbhost"};
	my $user  = $configuration{"dbuser"};
	my $pass  = $configuration{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
	
	my $table = $configuration{"geometry_table"}."__materials";
  
	$query = $dbh->prepare("SELECT * from $table");
	$query->execute();
	
	while (@data = $query->fetchrow_array()) 
	{
		my $mnam = $data[0];
		my $mden = $data[1];
		my $nele = $data[2];
    
    my @elem = split(/ /, $data[3]);
    
		print " * Material: $mnam \n";
		print " * Density (mg/cm3): $mden \n";
		print " * Number of Components: $nele \n";
    
    for(my $i=0; $i<$nele; $i++)
    {
    	print "   > Component (", ($i+1), ") : $elem[$i*2+1],  Percentage: $elem[$i*2+2] \n";
    }
    
	}
}



sub upload_opt_properties
{
	my (%conf_opt_properties)   = @_;
  
	my $db    = $conf_opt_properties{"dbname"};
	my $host  = $conf_opt_properties{"dbhost"};
	my $user  = $conf_opt_properties{"dbuser"};
	my $pass  = $conf_opt_properties{"dbpass"};
	
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
  
	my $mat_name = $conf_opt_properties{"mat_name"};
	my $table = $conf_opt_properties{"geometry_table"}."__opt_properties";
  
	# Createx new table	if it does not exists
	$dbh->do("create table IF NOT EXISTS $table ( \
		property        VARCHAR(50),                \
		mat_name        VARCHAR(100),               \
		plist           VARCHAR(2500),              \
		upload_date     TIMESTAMP
    )");

	# Drop the material entry if it exists
	if($conf_opt_properties{"verbosity"} > 0)
	{
		print " > Inserting $mat_name into table table: ", $table, "\n\n";
	}
	$dbh->do("delete from $table where mat_name='$mat_name'");

  
  # Uploadable values:
  # - PhotonEnergy (mandatory)
  # - IndexOfRefraction
  # - AbsorptionLength
  # - Efficiency

  
  # Insert data into table
  # Photon Energies: not checking if it exists cause it MUST exists
  my $penergy = $conf_opt_properties{"PhotonEnergy"};
  $dbh->do("insert into $table values ('PhotonEnergy', '$mat_name', '$penergy', CURDATE())");
  
  # IndexOfRefraction
  my $rindex = $conf_opt_properties{"IndexOfRefraction"};
  if(defined($rindex))
  {
    $dbh->do("insert into $table values ('IndexOfRefraction', '$mat_name', '$rindex', CURDATE())");
  }
  
  # AbsorptionLength
  my $alength = $conf_opt_properties{"AbsorptionLength"};
  if(defined($alength))
  {
    $dbh->do("insert into $table values ('AbsorptionLength', '$mat_name', '$alength', CURDATE())");
  }
    
  # Reflectivity
  my $reflectivity = $conf_opt_properties{"Reflectivity"};
  if(defined($reflectivity))
  {
    $dbh->do("insert into $table values ('Reflectivity', '$mat_name', '$reflectivity', CURDATE())");
  }

  # Efficiency
  my $efficiency = $conf_opt_properties{"Efficiency"};
  if(defined($efficiency))
  {
    $dbh->do("insert into $table values ('Efficiency', '$mat_name', '$efficiency', CURDATE())");
  }


  if($conf_opt_properties{"verbosity"} > 1)
	{
		print " * Complete List of Optical Properties uploaded in database: \n";
		print_opt_properties(%conf_opt_properties);
		print " \n";
	}
}

sub print_opt_properties
{
	my (%conf_opt_properties)   = @_;
	
	my $db    = $conf_opt_properties{"dbname"};
	my $host  = $conf_opt_properties{"dbhost"};
	my $user  = $conf_opt_properties{"dbuser"};
	my $pass  = $conf_opt_properties{"dbpass"};
	
	my $mat_name = $conf_opt_properties{"mat_name"};
  
	$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
	
	my $table = $conf_opt_properties{"geometry_table"}."__opt_properties";
  
	$query = $dbh->prepare("SELECT * from $table where mat_name='$mat_name'");
	$query->execute();
	
	while (@data = $query->fetchrow_array()) 
	{
		my $property = $data[0];
		my $mat_name = $data[1];
		my $plist    = $data[2];
    
    
		print " * Property: $property for $mat_name :\n";
		print " $plist \n";
        
	}

}

1;





