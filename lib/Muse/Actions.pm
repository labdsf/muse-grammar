use v6;
unit class Muse::Actions;
use Muse::Inline;

method directive ($/) {
    make ($<directive_key>.Str => $<directive_value>.Str)
}
method directives ($/) {
    make (.made.key => .made.value for $<directive>);
}
method str ($/) {
    make Muse::Inline::Str.new(contents => $/.Str);
}
