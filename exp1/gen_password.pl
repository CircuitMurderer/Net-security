#!/usr/bin/perl

sub write_pwd {
    ($fmt, $o) = (@_[1], @_[2]);
    for (0..@_[0]) {
        $num = (sprintf $fmt, $_);
        print $o "admin$num\n";
    }
}

open out, ">password.txt" or die $!;
write_pwd 999, "%03d", out;
write_pwd 9999, "%04d", out;
write_pwd 99999, "%05d", out;

close out;