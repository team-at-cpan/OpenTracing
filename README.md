# NAME

OpenTracing - support for [https://opentracing.io](https://opentracing.io) application tracing

# DESCRIPTION

The OpenTracing standard provides a way to profile and monitor applications
across different components and services.

It's defined by the following specification:

[https://github.com/opentracing/specification/blob/master/specification.md](https://github.com/opentracing/specification/blob/master/specification.md)

and has several "semantic conventions" which provide a common way to
include details for common components such as databases, caches and web
applications.

This module currently implements **version 1.1** of the official specification.

## How to use this

There are 3 parts to this:

- [add tracing to your code](#tracing)
- [set up an opentracing service](#tracers)
- [have the top-level application(s) send traces to that service](#application)

## Tracing

Collecting trace data is similar to a logging module such as [Log::Any](https://metacpan.org/pod/Log%3A%3AAny).
Add this line to any module where you want to include tracing information:

    use OpenTracing::Any qw($tracer);

This will give you an [OpenTracing::Tracer](https://metacpan.org/pod/OpenTracing%3A%3ATracer) instance in the `$tracer`
package variable. You can then use this to create [spans](https://metacpan.org/pod/OpenTracing%3A%3ASpan):

    my $span = $tracer->span(
     name => 'example'
    );

You could also use [OpenTracing::DSL](https://metacpan.org/pod/OpenTracing%3A%3ADSL) for an alternative way to trace blocks of code:

    use OpenTracing::DSL qw(:v1);

    trace {
     print 'operation starts here';
     sleep 2;
     print 'end of operation';
    } name => 'example';

## Integration

For some common modules and services there are integrations which automatically create
spans for operations. If you load [OpenTracing::Integration::DBI](https://metacpan.org/pod/OpenTracing%3A%3AIntegration%3A%3ADBI), for example, all
database queries will be traced as if you'd wrapped every `prepare`/`execute` method
with tracing code.

Most of those third-party integrations are in separate distributions, search for
`OpenTracing::Integration::` on CPAN for available options.

## Tracers

Once you have tracing in your code, you'll need a service to collect and present
the traces.

At the time of writing, there is an incomplete list here:

[https://opentracing.io/docs/supported-tracers/](https://opentracing.io/docs/supported-tracers/)

## Application

The top-level code (applications, dæmons, cron jobs, microservices, etc.) will need
to register a tracer implementation and configure it with the service details, so
that the collected data has somewhere to go.

One such tracer implementation is [Net::Async::OpenTracing](https://metacpan.org/pod/Net%3A%3AAsync%3A%3AOpenTracing), designed to work with
code that uses the [IO::Async](https://metacpan.org/pod/IO%3A%3AAsync) event loop.

    use IO::Async::Loop;
    use Net::Async::OpenTracing;
    my $loop = IO::Async::Loop->new;
    $loop->add(
     my $target = Net::Async::OpenTracing->new(
      host     => 'localhost',
      port     => 6828,
      protocol => 'zipkin',
     )
    );
    OpenTracing->global_tracer->register($target);

See the [module documentation](https://metacpan.org/pod/Net%3A%3AAsync%3A%3AOpenTracing) for more details on the options.

If you're feeling lucky, you might also want to add this to your top-level application code:

    use OpenTracing::Integration qw(:all);

This will go through the list of all modules currently loaded and attempt to
enable any matching integrations - see ["Integration"](#integration) and [OpenTracing::Integration](https://metacpan.org/pod/OpenTracing%3A%3AIntegration)
for more details.

## More information

See the following classes for more information:

- [OpenTracing::Span](https://metacpan.org/pod/OpenTracing%3A%3ASpan)
- [OpenTracing::SpanProxy](https://metacpan.org/pod/OpenTracing%3A%3ASpanProxy)
- [OpenTracing::Log](https://metacpan.org/pod/OpenTracing%3A%3ALog)
- [OpenTracing::Process](https://metacpan.org/pod/OpenTracing%3A%3AProcess)

# METHODS

## global\_tracer

Returns the default tracer instance.

    my $span = OpenTracing->global_tracer->span(name => 'test');

This is the same instance used by [OpenTracing::Any](https://metacpan.org/pod/OpenTracing%3A%3AAny) and [OpenTracing::DSL](https://metacpan.org/pod/OpenTracing%3A%3ADSL).

## set\_global\_tracer

Replaces the current global tracer with the given one.

    OpenTracing->set_global_tracer($tracer);

Note that a typical application would only need a single instance, and the
default should normally be good enough.

**If you want to set up where the traces should go**, see
["register" in OpenTracing::Tracer](https://metacpan.org/pod/OpenTracing%3A%3ATracer#register) instead.

# SEE ALSO

## Tools and specifications

- [https://opentracing.io](https://opentracing.io) - documentation and best practices
- [https://www.jaegertracing.io](https://www.jaegertracing.io) - the Jæger framework
- [https://www.datadoghq.com](https://www.datadoghq.com) - a commercial product with APM support

## Other modules

Some perl modules of relevance:

- [OpenTracing::Manual](https://metacpan.org/pod/OpenTracing%3A%3AManual) - this is an independent Moo-based implementation, probably worth a look
if you're working mostly with synchronous code.
- [Net::Async::OpenTracing](https://metacpan.org/pod/Net%3A%3AAsync%3A%3AOpenTracing) - an async implementation for sending OpenTracing data
to servers via the binary Thrift protocol
- [NewRelic::Agent](https://metacpan.org/pod/NewRelic%3A%3AAgent) - support for NewRelic's APM system

# AUTHOR

Tom Molesworth <TEAM@cpan.org>

# LICENSE

Copyright Tom Molesworth 2018-2020. Licensed under the same terms as Perl itself.
