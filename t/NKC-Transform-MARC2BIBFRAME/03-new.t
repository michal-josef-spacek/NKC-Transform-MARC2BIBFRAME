use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean err_msg_hr);
use NKC::Transform::MARC2BIBFRAME;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $obj = NKC::Transform::MARC2BIBFRAME->new;
isa_ok($obj, 'NKC::Transform::MARC2BIBFRAME');

# Test.
eval {
	NKC::Transform::MARC2BIBFRAME->new(
		'xslt_transformation_file' => 'bad',
	);
};
is($EVAL_ERROR, "Cannot read XSLT file.\n",
	"Cannot read XSLT file.");
my $err_msg_hr = err_msg_hr(0);
is($err_msg_hr->{'XSLT file'}, 'bad', "Error 'XSLT file' parameter (bad)");
clean();
