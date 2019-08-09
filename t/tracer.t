use strict;
use warnings;

use Test::More;

use OpenTracing::Tracer;

my $tracer = new_ok('OpenTracing::Tracer');
isa_ok($tracer->process, 'OpenTracing::Process');
isa_ok(my $span = $tracer->span, 'OpenTracing::SpanProxy');
is($span->duration, undef, 'no duration yet');
Time::HiRes::sleep(0.2);
is($span->duration, undef, 'still no duration yet');
$span->finish;
cmp_ok($span->duration, '>=', 0.1, 'span duration is realistic');

done_testing;

