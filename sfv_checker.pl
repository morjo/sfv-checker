#!/bin/perl
use 5.010;
use String::CRC32;
use Digest::CRC;
use Data::Dumper;
use encoding "iso 8859-1";

use strict;
use warnings;
use diagnostics;

my $crc32 = new Digest::CRC();


my @sfvfile = `find . -name *.sfv`;
foreach (@sfvfile) {
    my $sfv_file = $_;
    chomp $sfv_file;
    print "File: $sfv_file\n";
    my ($path) = $sfv_file =~ m/(.+)\//;

    open (FIL, "<", $sfv_file);

    while (<FIL>) {
        my $fil = $_;
        $fil =~ s/[\r\n]+//g;
        my ($file, $file_crc) = $fil =~ m/(.+?)\s(.+)/;
        my $checkfile = "$path/$file";
        &crccheck ($checkfile, $file_crc);
    }
    close FIL;
}


sub crccheck {
    my ($check_file) = shift;
    my ($checksum) = shift;
    if (open (my $fil, "<", $check_file)) {
        my $crc = crc32($fil);
        close ($fil);
        my $crc2 = sprintf("%08x", $crc);
        if ($crc2 eq $checksum) {
        }
        else {
            say "File $check_file is NOT ok. got crc: $crc2, should have been $checksum\n";
        }
    }
    else {
        say "File $check_file doesnt exists";
    }
}
