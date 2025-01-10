use strict;
use warnings;

use NKC::Transform::MARC2BIBFRAME;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = NKC::Transform::MARC2BIBFRAME->new;
isa_ok($obj, 'NKC::Transform::MARC2BIBFRAME');
