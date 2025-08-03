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

	# Version of transformation.
	$self->{'version'} = '2.5.0';

	# XSLT transformation file.
	$self->{'xslt_transformation_file'} = undef;

	# Process parameters.
	set_params($self, @params);

	if (! defined $self->{'xslt_transformation_file'}) {
		if (! defined $self->{'version'}) {
			err "Parameter 'version' is undefined.";
		}
		$self->{'xslt_transformation_file'} = dist_file('NKC-Transform-MARC2BIBFRAME',
			catfile($self->{'version'}, 'marc2bibframe2.xsl'));
	}

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

=pod

=encoding utf8

=head1 NAME

NKC::Transform::MARC2BIBFRAME - marc2bibframe transformation class.

=cut
