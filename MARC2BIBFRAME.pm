package NKC::Transform::MARC2BIBFRAME;

use strict;
use warnings;

use Class::Utils qw(set_params);
use Error::Pure qw(err);
use File::Spec::Functions qw(catfile);
use File::Share ':all';
use XML::LibXML;
use XML::LibXSLT;

our $VERSION = 0.02;

sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# XSLT transformation file.
	$self->{'xslt_transformation_file'} = dist_file('NKC-Transform-MARC2BIBFRAME',
		catfile('2.5.0', 'marc2bibframe2.xsl'));

	# Process parameters.
	set_params($self, @params);

	if (! -r $self->{'xslt_transformation_file'}) {
		err "Cannot read XSLT file.",
			'XSLT file', $self->{'xslt_transformation_file'},
		;
	}

	$self->{'_xml_parser'} = XML::LibXML->new;
	$self->{'_xslt'} = XML::LibXSLT->new;

	return $self;
}

sub version {
	my $self = shift;

	my $dom = $self->{'_xml_parser'}->load_xml(
		'location' => dist_file('NKC-Transform-MARC2BIBFRAME', catfile('2.5.0', 'variables.xsl')),
	);

	my $version = $dom->findvalue('//xsl:variable[@name="vCurrentVersion"]');
	$version =~ s/^v//ms;

	return $version;
}

sub transform {
	my ($self, $marc_xml) = @_;

	my $marc_xml_input = $self->{'_xml_parser'}->load_xml('string' => $marc_xml);
	my $style_doc = $self->{'_xml_parser'}->parse_file($self->{'xslt_transformation_file'});

	my $stylesheet = $self->{'_xslt'}->parse_stylesheet($style_doc);

	my $results = $stylesheet->transform($marc_xml_input);

	return $stylesheet->output_string($results);
}

1;
