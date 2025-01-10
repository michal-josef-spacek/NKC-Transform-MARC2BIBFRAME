use strict;
use warnings;

use File::Object;
use NKC::Transform::MARC2BIBFRAME;
use Perl6::Slurp qw(slurp);
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Data dir.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = NKC::Transform::MARC2BIBFRAME->new;
my $ex1 = slurp($data_dir->file('ex1.xml')->s);
my $ret = $obj->transform($ex1);
ok($ret, 'Generated BIBFRAME file.');
