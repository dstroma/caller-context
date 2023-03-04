#!perl
use warnings;
use strict;
use Benchmark 'cmpthese';

use Caller::Context;
use Want;

use constant ITERATIONS => 500_000;

sub get_context_str {
	no warnings;
	my $result = context;
	$result eq 'VOID';
	$result eq 'SCALAR';
	$result eq 'LIST';
}

sub get_context_str_nc {
	no warnings;
	context eq 'VOID';
	context eq 'SCALAR';
	context eq 'LIST';
}

sub get_context_oo {
	no warnings;
	my $result = context;
	$result->is_void;
	$result->is_scalar;
	$result->is_list;
}

sub get_context_oo_nc {
	no warnings;
	context->is_void;
	context->is_scalar;
	context->is_list;
}

sub get_wantarray {
	no warnings;
	my $result = wantarray;
	!defined $result;
	$result;
	!$result;
}

sub get_wantarray_nc {
	no warnings;
	!defined wantarray;
	wantarray;
	! wantarray;
}

sub get_cpan_want {
	no warnings;
	my $result = want;
	want('VOID');
	want('SCALAR');
	want('LIST');
}

my @tests = qw(context_str_nc context_oo wantarray_nc cpan_want);
my %tests;
foreach my $test_name (@tests) {
	my $sub_name = 'get_' . $test_name;
	$tests{$test_name} = eval "sub {	$sub_name; my \$x = $sub_name; my \@x = $sub_name; }";
}

cmpthese(ITERATIONS, \%tests);

=pod

=head1 NAME

Caller::Context benchmark.pl -- Benchmark Caller::Context against Want and the
wantarray built-in function.

=head1 SELECTED RESULTS

The slowest way of using Caller::Context (string comparison with no caching of
the result between comparisons) as well as the fastest way is checked against
the only method of using the Want module (caching result is not possible) and
the fastest way of using the wantarray function (without caching).

		               Rate cpan_want context_str_nc context_oo wantarray_nc
	cpan_want       10898/s        --           -75%       -91%         -99%
	context_str_nc  44092/s      305%             --       -64%         -96%
	context_oo     123457/s     1033%           180%         --         -88%
	wantarray_nc  1063830/s     9662%          2313%       762%           --

