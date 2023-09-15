##########################################################################################################################
## Description : Update $str to match your design inputs and the script split will top level eco file to per tile eco
## Usage : perl eco_split.pl eda_tool.eco 
## This program is dedicated to the public domain under the CC0 license.
##                                            Cloud EDA 2023
##########################################################################################################################


# instance_name nickname ref_name
my $str="ddr_inst DDR DRR_TOP
ADC_0 ADC0 ADC_TOP
DAC_0 DAC0 DAC_TOP";

my @sp;
my %lookup;
my %fh_lookup;
my $_tmp;
my $cnt=0;
foreach my $entry (split("\n",$str)) {
	@sp = split('\s+',$entry);
	$lookup{$sp[0]} = $sp[1];
  	$fh_lookup{$sp[0]} = "FH$cnt";
	$_tmp = "FH$cnt";
 	open($_tmp,">$sp[1].eco")||die("cannot open file $sp[1].eco\n");
  	$cnt++;
}


my $save_str = "";
open(TOP,">./TOP.eco");

open(IN,"<$ARGV[0]");
while(<IN>) {
	if (/^\s*current_instance\s*$/) {
		# check and split
  		my $binned = 0;
  		foreach my $inst ( keys %lookup ) {
    			if ( $save_str =~ /$inst/ ) {
				$_tmp = $fh_lookup{$inst};
				$save_str =~ s/ $inst\/?/ /g;	
       				print $_tmp $save_str;
	   			$binned = 1;
			}
		}
		if ( $binned == 0 )  {
  			print TOP $save_str;
		}
		$save_str = "";
	} else {
		$save_str = $save_str."$_";
	}
		
}

close IN;
close TOP;
foreach my $inst ( keys %lookup ) {
	$_tmp =  $fh_lookup{$inst};
	close $_tmp;
}


