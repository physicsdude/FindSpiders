#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Long;

=head1 NAME 

find_spiders.pl - A script to find spiders from apache web logs and report on them.

=head1 DESCRIPTION

This is old code but has tended to work like a charm for me.
You can put this in a cron and get daily emails about who's hammering your site.
It's also helpful for forensic analysis after some jerk crawler takes your server down.
One nice feature is that it does hostname lookups on the bots IPs (once-per-ip), 
so it's easier to tell if it's a bot that's actually from google or another legit search engine.

=head1 USAGE

=head2 EXAMPLE

Analyze and report on the last 1000 lines of your domain's apache log.

./find_spiders.pl -f /home/domlogs/YOURDOMAIN.com  -l 1000

=head1 LICENSE 

GPL v2 https://www.gnu.org/licenses/gpl-2.0.html

=head1 AUTHOR

Bryan Gmyrek <bryangmyrek@gmail.com>

=cut


my $ntld = 20;
my $nips = 100; # number of ips to look at in detail
my $nlines = 10000000000; # number of lines to look at for log file
my $dir = "";
my $file = "";

my $result = GetOptions (
	"ntld|t=i"    => \$ntld,
	"nips|i=i"    => \$nips,
	"nlines|l=i"  => \$nlines,
	"dir|d=s"     => \$dir,
	"file|f=s"    => \$file,
) or die("Error in command line arguments\n");
if (!$dir && !$file) {
	die "Please supply a file with -f (also, read the perldoc :p)\n";
}

# get list of good tlds
my $good_tlds_list = $dir."/allowed_domains.txt";
my %good_tlds = get_good_tlds($good_tlds_list);

my @logs;
push @logs, $file;
if ($dir) {
	opendir(INDIR, $dir) or die "Directory $dir Not Found";
	my @dir_contents = readdir(INDIR);
	closedir(INDIR); 

	foreach my $file (@dir_contents) {
	  # You might want to change this to fit your needs...
	  if($file =~ /^[-\w]+?\.(com|net|org|info|biz|us)$/){
		push(@logs,$file);
		print $file, "\n";
	  }
	}
}

my %ip_times;
my %ip_ua;
my %ip_host;
my %host_spider;
my %tld_times;

my $date = `date '+%e/%b/%Y'`;
foreach my $log (@logs){
	print "Working on $log\n\n";
	my @loglines = split(/\n/,`tail -n$nlines $log`);
	foreach my $line (@loglines){
		my %li = parse_line($line);
		$ip_times{$li{ip}}++;
		$ip_ua{$li{ip}}=$li{ua};
	}
}

my $count=0;
print "------------------\n";
print "Top Hitters Report\n";
print "------------------\n";
print "Hits,Approved,TLD,Host,IP,UA\n";
foreach my $ip (sort {$ip_times{$b} <=> $ip_times{$a}} keys %ip_times){
	unless($ip =~ /\w+\.\w+\.\w+\.\w+/) { next; }
	my $host = get_host_from_ip($ip);	
	$host =~ /([-\w]+\.\w+)$/;
	my $tld = $1 || "No TLD";
	$tld_times{$tld}+=$ip_times{$ip};
	my $approved=0;
	if(exists $good_tlds{$tld}){
		if($good_tlds{$tld} eq "1"){
			$approved=1;
		}
	}
	print "$ip_times{$ip},$approved,$tld,$host,$ip,$ip_ua{$ip}\n";
	if($count>$nips){ last; }
	$count++;
}
print "------------------\n";

print "----------------\n";
print "Major TLD Report\n";
print "----------------\n";
print "Hits,TLD\n";
$count=0;
foreach my $t (sort {$tld_times{$b} <=> $tld_times{$a}} keys %tld_times){
	print "$tld_times{$t},$t\n";
	if($count>$ntld){ last; }
	$count++;
}
print "----------------\n";

sub get_host_from_ip{
	my $ip = shift;
	my $host = `host $ip`;
	$host =~ /domain name pointer (.*?)\.\n$/i;
	$host = $1;
	if($host =~ /\./){
		return $host;
	} else {
		return "No host found";
	}
}

sub parse_line{
	my $line=shift;
	$line=~/^(.*?) (".*?"|-) (".*?"|-) \[(.*?)\] (".*?"|-) (\w+?|-) (\w+|-) (".*?"|-) (".*?"|-)$/;
	my %ret;
	$ret{ip}=$1;
	$ret{logname}=$2;	
	$ret{uname}=$3;
	$ret{date}=$4;	
	$ret{request}=$5;	
	$ret{status}=$6;	
	$ret{bytes}=$7;	
	$ret{referrer}=$8;	
	$ret{ua}=$9;	
	foreach my $l (keys %ret){
		if(exists $ret{$l}){
		  $ret{$l}=~s/^\s*"//;
		  $ret{$l}=~s/"\s*$//;
		}
	}
	return %ret;
}

sub get_good_tlds{
	my $file=shift;
	my %good_tlds;
	open(IN,$file);
	while(<IN>){
		my $line=$_;
		chomp($line);
		$line=~s/^\s+//;
		$line=~s/\s+$//;
		$good_tlds{$line}=1;
	}
	return %good_tlds;
}
