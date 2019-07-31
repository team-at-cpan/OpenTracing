package OpenTracing::Any;

use strict;
use warnings;

=head1 NAME

OpenTracing::Any - application tracing

=head1 SYNOPSIS

 use OpenTracing::Any qw($tracer);
 {
  my $span = $tracer->span(operation_name => 'whatever');
  $span->add_tag(xyz => 'abc');
  sleep 3;
 }
 # at this point the span will be finished and have an approximate timing of ~3s

=head1 DESCRIPTION

See also: L<Log::Any>.

=cut

sub import {
    my ($class, @args) = @_;
    die 'too many parameters when loading OpenTracing::Any - expects a single variable name'
        if @args > 1;

    # Normally we'd expect the caller to provide a variable name - but if they don't,
    # '$tracer' seems as good a default as any
    my ($injected_variable) = (@args, '$tracer');
    my ($bare_name) = $injected_variable =~ /^\Q$\E\w+$/
        or die 'invalid injected variable name ' . $injected_variable;

    my ($pkg) = caller;
    my $fully_qualified = $pkg . '::' . $bare_name;
    {
        no strict 'refs';
        die $pkg . ' already has a variable called ' . $injected_variable if *{$fully_qualified}{SCALAR};
        *{$fully_qualified} = \$OpenTracing::TRACER;
    }
}

1;

