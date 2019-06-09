package OpenTracing::Process;

use strict;
use warnings;

# VERSION

use parent qw(OpenTracing::Common);

sub name { shift->{name} }
sub tags { shift->{tags} }
sub tag_list {
    # OpenTracing::Tag->new(key => 'example_process_tag', value => 'process_value')
    (shift->{tags} //= [])->@*
}

1;

