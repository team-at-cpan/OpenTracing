# NAME

OpenTracing - support for [https://opentracing.io](https://opentracing.io) application tracing

# DESCRIPTION

This is an early implementation, so the API may be subject to change.

In general, you'll want to create an [OpenTracing::Batch](https://metacpan.org/pod/OpenTracing::Batch), then add one
or more [OpenTracing::Span](https://metacpan.org/pod/OpenTracing::Span) instances to it. Those instances can have zero
or more [OpenTracing::Log](https://metacpan.org/pod/OpenTracing::Log) entries.

# SEE ALSO

## Tools and specifications

- [https://opentracing.io](https://opentracing.io) - documentation and best practices
- [https://www.jaegertracing.io](https://www.jaegertracing.io) - the Jæger framework
- [https://www.datadoghq.com](https://www.datadoghq.com) - a commercial product with APM support

## Other modules

Some perl modules of relevance:

- [Net::Async::OpenTracing](https://metacpan.org/pod/Net::Async::OpenTracing) - an async implementation for sending OpenTracing data
to servers via the binary Thrift protocol
- [NewRelic::Agent](https://metacpan.org/pod/NewRelic::Agent) - support for NewRelic's APM system

# AUTHOR

Tom Molesworth <TEAM@cpan.org>

# LICENSE

Copyright Tom Molesworth 2018-2019. Licensed under the same terms as Perl itself.
