=pod

=head1 LICENSE

  Copyright (c) 1999-2013 The European Bioinformatics Institute and
  Genome Research Limited.  All rights reserved.

  This software is distributed under a modified Apache license.
  For license details, please see

  http://www.ensembl.org/info/about/code_licence.html

=head1 NAME

Bio::EnsEMBL::IO::Parser::Bed - A line-based parser devoted to BED format

=cut

package Bio::EnsEMBL::IO::Parser::Bed;

use strict;
use warnings;

use base qw/Bio::EnsEMBL::IO::TrackBasedParser/;

=head2 set_fields

    Description: Setter for list of fields used in this format - uses the
                  "public" (i.e. non-raw) names of getter methods
    Returntype : Void

=cut

sub set_fields {
  my $self = shift;
  $self->{'fields'} = [qw(seqname start end)];
}

## ----------- Mandatory fields -------------

=head2 get_raw_chrom

    Description: Getter for chrom field
    Returntype : String 

=cut

sub get_raw_chrom {
  my $self = shift;
  return $self->{'record'}[0];
}

=head2 get_seqname

    Description: Getter - wrapper around raw method 
                  (uses standard method name, not format-specific)
    Returntype : String 

=cut

sub get_seqname {
  my $self = shift;
  (my $chr = $self->get_raw_chrom()) =~ s/^chr//;
  return $chr;
}

=head2 munge_seqname

    Description: Converts Ensembl seq region name to standard BED format  
    Returntype : String 

=cut

sub munge_seqname {
  my ($self, $value) = @_;
  $value = "chr$value" unless $value =~ /^chr/;
  return $value;
}

=head2 get_raw_chromStart

    Description: Getter for chromStart field
    Returntype : Integer 

=cut

sub get_raw_chromStart {
  my $self = shift;
  return $self->{'record'}[1];
}

=head2 get_start

    Description: Getter - wrapper around raw_chromStart method, converting
                  semi-open coordinates to standard Ensembl ones
                  (uses standard method name, not format-specific)
    Returntype : Integer 

=cut

sub get_start {
  my $self = shift;
  return $self->get_raw_chromStart()+1;
}

=head2 munge_start

    Description: Converts Ensembl start coordinate to semi-open  
    Returntype : Integer 

=cut

sub munge_start {
  my ($self, $value) = @_;
  return $value - 1;
}

=head2 get_raw_chromEnd

    Description: Getter for chromEnd field
    Returntype : Integer

=cut

sub get_raw_chromEnd {
  my $self = shift;
  return $self->{'record'}[2];
}

=head2 get_end

    Description: Getter - wrapper around get_raw_chromEnd 
                  (uses standard method name, not format-specific)
    Returntype : String 

=cut

sub get_end {
  my $self = shift;
  return $self->get_raw_chromEnd();
}

## ----------- Optional fields -------------

=head2 get_raw_name

    Description: Getter for name field
    Returntype : String 

=cut

sub get_raw_name {
  my $self = shift;
  my $column = $self->get_metadata_value('type') eq 'bedGraph' ? undef : $self->{'record'}[3];
  return $column;
}

=head2 get_name

    Description: Getter - wrapper around get_raw_name 
    Returntype : String 

=cut

sub get_name {
  my $self = shift;
  return $self->get_raw_name();
}

=head2 get_raw_score

    Description: Getter for score field
    Returntype : Number (usually floating point) or String (period = no data)

=cut

sub get_raw_score {
  my $self = shift;
  my $column = $self->get_metadata_value('type') eq 'bedGraph' ? 3 : 4;
  return $self->{'record'}[$column];
}

=head2 get_score

    Description: Getter - wrapper around get_raw_score
    Returntype : Number (usually floating point) or undef

=cut

sub get_score {
  my $self = shift;
  my $val = $self->get_raw_score();
  if ($val =~ /^\.$/) {
    return undef;
  } else {
    return $val;
  }
}

=head2 get_raw_strand

    Description: Getter for strand field
    Returntype : String 

=cut

sub get_raw_strand {
  my $self = shift;
  return $self->{'record'}[5];
}

=head2 get_strand

    Description: Getter - wrapper around get_raw_strand
                  Converts text content into integer
    Returntype : Integer (1, 0 or -1)

=cut

sub get_strand {
  my $self = shift;
  return $self->{'strand_conversion'}{$self->get_raw_strand};
}

=head2 get_raw_thickStart

    Description: Getter for thickStart field (UCSC drawing code)
    Returntype : Integer 

=cut

sub get_raw_thickStart {
  my $self = shift;
  return $self->{'record'}[6];
}

=head2 get_thickStart

    Description: Getter - wrapper around get_raw_thickStart
    Returntype : Integer

=cut

sub get_thickStart {
  my $self = shift;
  return $self->get_raw_thickStart();
}

=head2 get_raw_thickEnd

    Description: Getter for thickEnd field (UCSC drawing code)
    Returntype : Integer

=cut

sub get_raw_thickEnd {
  my $self = shift;
  return $self->{'record'}[7];
}

=head2 get_thickEnd

    Description: Getter - wrapper around get_raw_thickEnd
    Returntype : Integer

=cut

sub get_thickEnd {
  my $self = shift;
  return $self->get_raw_thickEnd();
}

=head2 get_raw_itemRgb

    Description: Getter for itemRgb field
    Returntype : String (3 comma-separated values)

=cut

sub get_raw_itemRgb {
  my $self = shift;
  return $self->{'record'}[8];
}

=head2 get_itemRgb

    Description: Getter - wrapper around get_raw_itemRgb
    Returntype : String (3 comma-separated values)

=cut

sub get_itemRgb {
  my $self = shift;
  return $self->get_raw_itemRgb();
}

=head2 get_raw_blockCount

    Description: Getter for blockCount field (UCSC drawing code)
    Returntype : Integer

=cut

sub get_raw_blockCount {
  my $self = shift;
  return $self->{'record'}[9];
}

=head2 get_blockCount

    Description: Getter - wrapper around blockCount
    Returntype : Integer

=cut

sub get_blockCount {
  my $self = shift;
  return $self->get_raw_blockCount();
}

=head2 get_raw_blockSizes

    Description: Getter for blockSizes field (UCSC drawing code)
    Returntype : String (comma-separated values)

=cut

sub get_raw_blockSizes {
  my $self = shift;
  return $self->{'record'}[10];
}

=head2 get_blockSizes

    Description: Getter - wrapper around get_raw_blockSizes
    Returntype : Arrayref

=cut

sub get_blockSizes {
  my $self = shift;
  my @res = split ",", $self->get_raw_blockSizes();
  return \@res;
}

=head2 get_raw_blockStarts

    Description: Getter for blockStarts field  (UCSC drawing code)
    Returntype : String (comma-separated values)

=cut

sub get_raw_blockStarts {
  my $self = shift;
  return $self->{'record'}[11];
}

=head2 get_blockStarts

    Description: Getter - wrapper around get_raw_blockStarts
    Returntype : Arrayref

=cut

sub get_blockStarts {
  my $self = shift;
  my @res = split ",", $self->get_raw_blockStarts();
  return \@res;
}

1;