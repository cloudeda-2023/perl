use strict ;
use warnings;

my $GOLDEN_DEF = $ARGV[0];
my $REFERENCE_DEF = $ARGV[1];

my $parse = 0;
open(FH1,"<$GOLDEN_DEF")||die("cannot open file $GOLDEN_FILE");
while(<FH1>) {
  if ( /^COMPONENTS/ ) {    $parse = 1;  } 
  if ( $parse == 1  && /^\s*END COMPONENTS/) {    $parse = 0;    last;   }

  if ( $parse == 1 ) {
    @_data = split('\s+',$_);
    $save_data{$_data[1]} = "$_data[6] $_data[7] $_data[9]";
  }
  
}
close FH1;

open(FH1,"<$REFERENCE_DEF")||die("cannot open file $REFERENCE_DEF");
while(<FH1>) {
  if ( /^COMPONENTS/ ) {    $parse = 1;  } 
  if ( $parse == 1  && /^\s*END COMPONENTS/) {    $parse = 0;    last;   }

  if ( $parse == 1 ) {
    @_data = split('\s+',$_);
    $_tmp = "$_data[6] $_data[7] $_data[9]";
    if ( ! defined($save_data{$_data[1]}) ) {
      print "ERROR: $_data[1] is present in $REFERENCE_DEF but not in $GOLDEN_DEF \n";
    } else {
      if ( $save_data{$_data[1]} ne $_tmp ) {
        print "ERROR : $_data[1] location or orientation is different between $REFERENCE_DEF and $GOLDEN_DEF \n";
        delete $save_data{$_data[1]} ;
      }
    }
  }
  
}
close FH1;

foreach $_inst ( keys %save_data ) {
  print "ERROR : $_inst present in $GOLDEN_DEF but not in $REFERENCE_DEF \n";
}
