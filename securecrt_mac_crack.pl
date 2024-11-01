#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

sub license {
    print "\n".
    "License:\n\n".
    "\tName:\t\tygeR\n".
    "\tCompany:\tTEAM ZWT\n".
    "\tSerial Number:\t03-22-041067\n".
    "\tLicense Key:\tAANPMG 4SSFZ5 NAZCNC S56A18 AAGKET ZRSVMG 262CZU TB3KJW\n".
    "\tIssue Date:\t08-19-2021\n\n\n";
}

sub usage {
    print "\n".
    "help:\n\n".
    "\tperl securecrt_mac_crack.pl <file>\n\n\n".
    "\tperl securecrt_mac_crack.pl /usr/bin/SecureCRT\n\n\n".
    "\n";
    
    &license;

    exit;
}

# Only call usage() if @ARGV is empty
&usage() if !@ARGV;

my $file = $ARGV[0];

open FP, $file or die 'cannot open file $!';
binmode FP;

open TMPFP, '>', '/tmp/.securecrt.tmp' or die 'cannot open file $!';

my $buffer;
my $unpack_data;
my $crack = 0;

while (read(FP, $buffer, 1024)) {
    $unpack_data = unpack('H*', $buffer);
    if ($unpack_data =~ m/785782391ad0b9169f17415dd35f002790175204e3aa65ea10cff20818/) {
        $crack = 1;
        last;
    }
    if ($unpack_data =~ s/6e533e406a45f0b6372f3ea10717000c7120127cd915cef8ed1a3f2c5b/785782391ad0b9169f17415dd35f002790175204e3aa65ea10cff20818/) {
        $buffer = pack('H*', $unpack_data);
        $crack = 2;
    }
    syswrite(TMPFP, $buffer, length($buffer));
}

close(FP);
close(TMPFP);

# Replace given/when with if/elsif structure
if ($crack == 1) {
    unlink '/tmp/.securecrt.tmp' or die 'cannot delete files $!';
    say "It has been cracked";
    &license;
    exit 1;
} elsif ($crack == 2) {
    rename '/tmp/.securecrt.tmp', $file or die 'Insufficient privileges, please switch to the root account.';
    chmod 0755, $file or die 'Insufficient privileges, please switch to the root account.';
    say 'crack successful';
    &license;
} else {
    die 'error';
}
