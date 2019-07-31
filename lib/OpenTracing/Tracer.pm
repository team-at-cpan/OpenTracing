package OpenTracing::Tracer;

use strict;
use warnings;

# VERSION

=encoding utf8

=head1 NAME

OpenTracing::Tracer - application tracing

=head1 DESCRIPTION

This provides the interface between the OpenTracing API and the tracing service(s)
for an application.

Typically a single process would have one tracer instance.

=cut

sub new {
    my ($class, %args) = @_;
    bless \%args, $class
}

=head2 process

Returns the current L<OpenTracing::Process>.

=cut

sub process {
    shift->{process} //= OpenTracing::Process->new(
        pid => $$
    )
}

sub is_enabled { shift->{is_enabled} }

1;

__END__

=head1 AUTHOR

Tom Molesworth <TEAM@cpan.org>

=head1 LICENSE

Copyright Tom Molesworth 2018-2019. Licensed under the same terms as Perl itself.

