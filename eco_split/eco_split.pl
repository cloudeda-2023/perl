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
  $fh_lookup{$sp[0]} = "FH$cnt";$cnt++:
  open("FH$cnt","<$sp[1].eco")||die("cannot open file $sp[1].eco\n");
}


my $save_str = "";
open(my TOP,">./TOP.eco");


open(FH1,"<$ARGV[0]");
while(<FH1>) {
	if (/^\s*current_instance\s*$/) {
		# check and split
		if ($save_str =~ /core\/u_top_sse710_r0_aontop\/u_pd_systop\/u_pd_clustop\/u_cpu_gic_socket\/cortexa53_inst_u_cortex_a53/) {
			print ARM $save_str;
			print ARM ;
		} elsif ($save_str =~/core\/i_rx/) {
			print RX $save_str;
			print RX ;
		} elsif ($save_str =~/core\/i_tx/) {
			print TX $save_str;
			print TX;
		} else {
			print TOP $save_str;
			print TOP;
		}
		$save_str = "";
	} else {
		$save_str = $save_str."$_";
	}
		
}

close FH1;
close TOP;
close ARM;
close TX;
close RX;

