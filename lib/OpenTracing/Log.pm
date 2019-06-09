package OpenTracing::Log;

use strict;
use warnings;

# VERSION

use parent qw(OpenTracing::Common);

sub timestamp { shift->{timestamp} }
sub tags { shift->{tags} }
sub tag_list { (shift->{tags} //= [])->@* }

1;

