package OpenTracing;
# ABSTRACT: supporting for application process monitoring, as defined by opentracing.io

use strict;
use warnings;

our $VERSION = '0.003';

=encoding utf8

=head1 NAME

OpenTracing - support for L<https://opentracing.io> application tracing

=head1 DESCRIPTION

The OpenTracing standard provides a way to profile and monitor applications
across different components and services.

It's defined by the following specification:

L<https://github.com/opentracing/specification/blob/master/specification.md>

and has several "semantic conventions" which provide a common way to
include details for common components such as databases, caches and web
applications.

=head2 How to use this

There are 3 parts to this:

=over 4

=item * add tracing to your code

=item * set up an opentracing service

=item * have the top-level application(s) send traces to that service

=back

=head2 Tracing

Collecting trace data is similar to a logging module such as L<Log::Any>.

 use OpenTracing::Any qw($tracer);

This will give you an L<OpenTracing::Tracer> instance. You can then use this
to create L<spans|OpenTracing::Span>:

 my $span = $tracer->span(
  name => 'example'
 );

You can also use L<OpenTracing::DSL> for an alternative way to trace blocks of code:

 use OpenTracing::DSL qw(:v1);

 trace {
  print 'operation starts here';
  sleep 2;
  print 'end of operation';
 };

=head2 Integration

For some common modules and services there are integrations which automatically create
spans for operations. If you load L<OpenTracing::Integration::DBI>, for example, all
database queries will be traced as if you'd wrapped every C<prepare>/C<execute> method
with tracing code.

Most of those third-party integrations are in separate distributions, search for
C<OpenTracing::Integration::> on CPAN for available options.

=head2 Tracers

Once you have tracing in your code, you'll need a service to collect and present
the traces.

At the time of writing, there is an incomplete list here:

L<https://opentracing.io/docs/supported-tracers/>

=head2 Application

The top-level code (applications, dæmons, cron jobs, microservices, etc.) will need
to enable a tracer and configure it with the service details so that the collected
data has somewhere to go.

One such tracer is L<Net::Async::OpenTracing>, designed to work with code that uses
the L<IO::Async> event loop.

 use IO::Async::Loop;
 use Net::Async::OpenTracing;
 my $loop = IO::Async::Loop->new;
 $loop->add(
  my $tracer = Net::Async::OpenTracing->new(
   host => 'localhost',
   port => 6828,
   protocol => 'zipkin',
  )
 );
 OpenTracing->register_tracer($tracer);

See the module documentation for more details on the options.

If you're feeling lucky, you might also want to add this to your top-level application code:

 use OpenTracing::Integration qw(:all);

This will go through the list of all modules currently loaded and attempt to
enable any matching integrations - see L</Integration> and L<OpenTracing::Integration>
for more details.

In general, you'll want to create an L<OpenTracing::Batch>, then add one
or more L<OpenTracing::Span> instances to it. Those instances can have zero
or more L<OpenTracing::Log> entries.

See the following classes for more information:

=over 4

=item * L<OpenTracing::Tag>

=item * L<OpenTracing::Log>

=item * L<OpenTracing::Span>

=item * L<OpenTracing::SpanProxy>

=item * L<OpenTracing::Process>

=item * L<OpenTracing::Batch>

=back

=cut

use OpenTracing::Tag;
use OpenTracing::Log;
use OpenTracing::Span;
use OpenTracing::SpanProxy;
use OpenTracing::Process;
use OpenTracing::Batch;

1;

__END__

=head1 SEE ALSO

=head2 Tools and specifications

=over 4

=item * L<https://opentracing.io> - documentation and best practices

=item * L<https://www.jaegertracing.io> - the Jæger framework

=item * L<https://www.datadoghq.com> - a commercial product with APM support

=back

=head2 Other modules

Some perl modules of relevance:

=over 4

=item * L<Net::Async::OpenTracing> - an async implementation for sending OpenTracing data
to servers via the binary Thrift protocol

=item * L<NewRelic::Agent> - support for NewRelic's APM system

=back

=head1 AUTHOR

Tom Molesworth <TEAM@cpan.org>

=head1 LICENSE

Copyright Tom Molesworth 2018-2019. Licensed under the same terms as Perl itself.

