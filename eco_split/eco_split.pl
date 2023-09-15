# This program is dedicated to the public domain under the CC0 license.
# Cloud EDA 2023

use strict ;
use warnings;

# instance_name nickname ref_name
my $str="ddr_inst DDR DRR_TOP
ADC_0 ADC0 ADC_TOP
DAC_0 DAC0 DAC_TOP;


my $cnt=0;
foreach my $entry (split("\n",$str)) {
	@sp = split('\s+',$entry);
	$lookup{$sp[0]} = $sp[1];
  	$fh_lookup{$sp[0]} = "FH$cnt";
 	open("FH$cnt","<$sp[1].eco")||die("cannot open file $sp[1].eco\n");
  	$cnt++;
}


my $save_str = "";
open(my TOP,">./TOP.eco");

open(FH1,"<$ARGV[0]");
while(<FH1>) {
	if (/^\s*current_instance\s*$/) {
		# check and split
  		my $binned = 0;
  		foreach my $inst ( keys %lookup ) {
    			if ( $save_str =~ /$inst/ ) {
       				print $fh_lookup{$inst} $save_str;
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

close FH1;
close TOP;
foreach my $inst ( keys %lookup ) {
	close $fh_lookup{$inst};
}

