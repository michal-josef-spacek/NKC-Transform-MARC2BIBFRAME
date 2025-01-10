use strict;
use warnings;

use NKC::Transform::MARC2BIBFRAME;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = NKC::Transform::MARC2BIBFRAME->new;
my $ret = $obj->version;
is($ret, '2.5.0', 'Get version (2.5.0).');
