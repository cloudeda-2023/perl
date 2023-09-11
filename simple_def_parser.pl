# This program is dedicated to the public domain under the CC0 license.
# Cloud EDA 2023

use strict ;
use warnings;

# input files from command line
my $GOLDEN_DEF = $ARGV[0];
my $REFERENCE_DEF = $ARGV[1];

# variable to know the state of parsing
my $parse = 0;
open(FH1,"<$GOLDEN_DEF")||die("cannot open file $GOLDEN_FILE");
while(<FH1>) {
  # go into parsing state 
  if ( /^\s*COMPONENTS/ ) {    $parse = 1;  } 
  # exit the parsing state , in this case we are not parsing multiple sections of DEF . So we can stop reading from file 
  if ( $parse == 1  && /^\s*END COMPONENTS/) {    $parse = 0;    last;   }

  if ( $parse == 1 ) {
    # based on the DEF format , capture necessary attributes .
    # this is not generic code and needs to change if the format changes

    # split string or processing , regular expression can also be used 
    @_data = split('\s+',$_);
    
    # key value pairs , key is instance name and values is a string of X Y ORIENTATION of that instance
    $save_data{$_data[1]} = "$_data[6] $_data[7] $_data[9]";
  }
  
}
close FH1;
# done loading one DEF into memory now , process second file ;

open(FH1,"<$REFERENCE_DEF")||die("cannot open file $REFERENCE_DEF");
while(<FH1>) {
  # same as above 
  if ( /^COMPONENTS/ ) {    $parse = 1;  } 
  if ( $parse == 1  && /^\s*END COMPONENTS/) {    $parse = 0;    last;   }

  if ( $parse == 1 ) {
    @_data = split('\s+',$_);
    # save current value into a temporary variable for comparing 
    $_tmp = "$_data[6] $_data[7] $_data[9]";
    if ( ! defined($save_data{$_data[1]}) ) {
      # REF file has instance which is not present in GOLDEN , 
      # because current instance is not in the keys list of %save_data
      print "ERROR: $_data[1] is present in $REFERENCE_DEF but not in $GOLDEN_DEF \n";
    } else {
      # current instance is present in the keys list of %save_data
      # now compare if the values are the same , i.e did the location or orientation change ?
      if ( $save_data{$_data[1]} ne $_tmp ) {
        print "ERROR : $_data[1] location or orientation is different between $REFERENCE_DEF and $GOLDEN_DEF \n";
      } else {
        print "INFO : no change in $_data[1] location or orientation \n";
      }

      # unload current instance from memory 
      delete $save_data{$_data[1]} ;
    }
  }
  
}
close FH1;

# this is the reason why we unloaded data after processing 
# are there any instances in GOLDEN which are not present in REF ?
# any key which is not deleted in REF file parising loop is the answer 
foreach $_inst ( keys %save_data ) {
  print "ERROR : $_inst present in $GOLDEN_DEF but not in $REFERENCE_DEF \n";
}

