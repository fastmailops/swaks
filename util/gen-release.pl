#!/usr/bin/perl

use Pod::Text;
use Pod::Html;

my $home = '/home/jetmore/dev/swaks/trunk';
my $release_d = "$home/RELEASE";
my $release = shift || die "Need release\n";

my $pod_blob = '';

print "Building $release_d/swaks... ";
open(O, ">$release_d/swaks") || die "can't write to $release_d/swaks: $!\n";
open(I, "<$home/swaks") || die "can't read from $home/swaks\n";
while (<I>) {
  s|DEVRELEASE|$release|g;
  print O;
}
close(I);
open(I, "<$home/doc/base.pod") ||
    die "can't read from $home/doc/base.pod: $!\n";
while (<I>) {
  s|DEVRELEASE|$release|g;
  $pod_blob .= $_;
  print O;
}
close(I);
print O "__END__\n";
close(O);
print "done\n";

print "Building ref.pod... ";
open(O, ">$release_d/doc/ref.pod") || die "Can't write to ref.pod: $!\n";
print O $pod_blob;
close(O);
print "done\n";

print "Building ref.txt... ";
my $pod2text = Pod::Text->new();
$pod2text->parse_from_file("$release_d/doc/ref.pod", "$release_d/doc/ref.txt");
print "done\n";

# ugh, the resulting html sucks, skip it
#print "Building ref.html... ";
#pod2html("--infile=$release_d/doc/ref.pod",
#         "--outfile=$release_d/doc/ref.html",
#         "--title=swaks reference, release $release");
#print "done\n";

print "\n",
	"UPDATE Changes.txt\n",
	"TAG RELEASE: svn copy http://svn.jetmore.org/swaks/trunk/RELEASE http://svn.jetmore.org/swaks/tags/r-$release\n";
