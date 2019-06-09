package OpenTracing::Tag;

use strict;
use warnings;

# VERSION

use parent qw(OpenTracing::Common);

sub key { shift->{key} }
sub value { shift->{value} }

1;
