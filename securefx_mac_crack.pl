#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

sub license {
    print "\n".
    "License:\n\n".
    "\tName:\t\tygeR\n".
    "\tCompany:\tTEAM ZWT\n".
    "\tSerial Number:\t06-67-004017\n".
    "\tLicense Key:\tACUYJV Q1V2QU 1YWRCN NBYCYK AD8J8U 8U2MRY U9BJNQ 41KZDH\n".
    "\tIssue Date:\t08-19-2021\n\n\n";
}

sub usage {
    print "\n".
    "help:\n\n".
    "\tperl securefx_mac_crack.pl <file>\n\n\n".
    "\tperl securefx_mac_crack.pl /Applications/SecureFX.app/Contents/MacOS/SecureFX\n\n\n".
    "\n";
    
    &license;

    exit;
}

# Only call usage() if @ARGV is empty
&usage() if !@ARGV;

my $file = $ARGV[0];

open FP, $file or die 'cannot open file $!';
binmode FP;

open TMPFP, '>', '/tmp/.securefx.tmp' or die 'cannot open file $!';

my $buffer;
my $unpack_data;
my $crack = 0;

while (read(FP, $buffer, 1024)) {
    $unpack_data = unpack('H*', $buffer);
    if ($unpack_data =~ m/e02954a71cca592c855c91ecd4170001d6c606d38319cbb0deabebb05126/) {
        $crack = 1;
        last;
    }
    if ($unpack_data =~ s/c847abca184a6c5dfa47dc8efcd700019dc9df3743c640f50be307334fea/e02954a71cca592c855c91ecd4170001d6c606d38319cbb0deabebb05126/) {
        $buffer = pack('H*', $unpack_data);
        $crack = 2;
    }
    syswrite(TMPFP, $buffer, length($buffer));
}

close(FP);
close(TMPFP);

# Replace given/when with if/elsif structure
if ($crack == 1) {
    unlink '/tmp/.securefx.tmp' or die 'cannot delete files $!';
    say "It has been cracked";
    &license;
    exit 1;
} elsif ($crack == 2) {
    rename '/tmp/.securefx.tmp', $file or die 'Insufficient privileges, please switch to the root account.';
    chmod 0755, $file or die 'Insufficient privileges, please switch to the root account.';
    say 'crack successful';
    &license;
} else {
    die 'error';
}
