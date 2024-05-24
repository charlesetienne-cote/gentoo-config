#!/usr/bin/perl
use strict;
# you need graphviz with USE=perl for the gv package:
use gv;

print "Collecting world package list\n";
my $packets = `emerge -qpe world|cut -f2 -d]|sed 's/^ //g'`;
my @packets = split("\n", $packets);

my $G = gv::digraph("World Dependency Graph");
my $i = 1;

print "Creating vertices and edges from package dependencies\n";
foreach my $packet (@packets) {
  # create node v for each packet
  print "$packet ($i/".scalar @packets.")\n";
  my $v = gv::node($G, $packet);

  # get packages depending on $packet
  my $deps = `equery -q depends $packet |egrep -i \[a-z\]`;
  my @deps = split("\n", $deps);
  # find or create node u for each depending packet and edge (u,v)
  foreach my $dep (@deps) {
    my $u = gv::node($G, $dep);
    gv::edge($u, $v);
  }
  $i++;
}

print "Writing graph to dot-file\n";
gv::write($G, "world-dependencies.dot");
`sed -i -e 's/ ";/";/g' world-dependencies.dot`;

print "Rendering dot-file as svg image\n";
`dot -o world-dependencies.svg -Tsvg -Grankdir=LR world-dependencies.dot`; 

# See emerge -pvc category/package for custom equery depends