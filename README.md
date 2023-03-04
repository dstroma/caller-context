# NAME

Caller::Context -- A less cryptic replacement for perl's wantarray() function.

# SYNOPSIS

        use Caller::Context;
        sub mysub {
                return 'wants scalar' if context eq 'SCALAR'; # string compare
                return ('wants list') if context->is_list;    # object method
                say context;
        }

        my $x = mysub(); # returns 'wants scalar'
        my @x = mysub(); # returns ('wants list')
        mysub();         # says 'VOID'

# JUSTIFICATION

Not only is the wantarray() function incorrectly named for the reason that there
is no such thing as array context, but rather list context (even perldoc
says it should have been called wantlist() instead), but also for the reason
that it can actually tell you which context of three it's being called in:
list, scalar, or void. So it really should have been three functions:
wantlist(), wantscalar(), and wantvoid().

This module allows you to obtain this information in a more readable way. You
can use string comparisons, or call methods on the returned object, with the
latter probably being the most readable.

# EXPORTS

The only export is the context() function. If you would prefer to not import
this function into your namespace, you can

        use Caller::Context ();

and then call Caller::Context::context() instead.

# FUNCTIONS

- context()

    It takes no arguments and returns an instance of Caller::Context::VOID,
    Caller::Context::LIST, or Caller::Context::SCALAR (which all inherit from
    Caller::Context::Object), according to the context in which the currently
    executing subroutine is being called.

    You may call methods on this object, or take advantage of its string overloading
    and compare it to 'VOID', 'LIST', and 'SCALAR'.

# METHODS

The context() function returns an object that responds to the following methods:

- is\_void

    Returns a true value if the object is an instance of Caller::Context::VOID,
    otherwise returns false.

- is\_list

    Returns a true value if the object is an instance of Caller::Context::LIST,
    otherwise returns false.

- is\_scalar

    Returns a true value if the object is an instance of Caller::Context::SCALAR,
    otherwise returns false.

# AUTHOR

Dondi Michael Stroma, <dstroma@gmail.com>

# COPYRIGHT AND LICENSE

Copyright (C) 2023 by Dondi Michael Stroma

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
