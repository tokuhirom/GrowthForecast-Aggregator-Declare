package GrowthForecast::Aggregator::Declare;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';

use parent qw(Exporter);

use GrowthForecast::Aggregator::DB;
use GrowthForecast::Aggregator::DBMulti;

our @EXPORT = qw(gf section db db_multi);

our $_SECTION;
our @_QUERIES;

sub gf(&) {
    local @_QUERIES;
    $_[0]->();
    return @_QUERIES;
}

sub section($&) {
    local $_SECTION = shift;
    $_[0]->();
}

sub db {
    push @_QUERIES, GrowthForecast::Aggregator::DB->new(
        section => $_SECTION,
        @_,
    );
}

sub db_multi {
    push @_QUERIES, GrowthForecast::Aggregator::DBMulti->new(
        section => $_SECTION,
        @_,
    );
}


1;
__END__

=encoding utf8

=head1 NAME

GrowthForecast::Aggregator::Declare - Declaretive interface for GrowthForecast client

=head1 SYNOPSIS

    use GrowthForecast::Aggregator::Declare;

    my @queries = gf {
        section member => sub {
            # post to member/count
            db(
                name => 'count',
                description => 'The number of members',
                query => 'SELECT COUNT(*) FROM member',
            );
        };

        section entry => sub {
            # post to entry/count, entry/count_unique
            db_multi(
                names        => ['count',                'count_unique'],
                descriptions => ['Total count of posts', 'Posted bloggers'],
                query => 'SELECT COUNT(*), COUNT(DISTINCT member_id) FROM entry',
            );
        };
    };

=head1 DESCRIPTION

GrowthForecast::Aggregator::Declare is a declaretive client library for L<GrowthForecast>

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>

=head1 SEE ALSO

This library is client for L<GrowthForecast>.

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
