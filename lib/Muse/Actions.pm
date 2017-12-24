use v6;
unit class Muse::Actions;
use Muse::Block;
use Muse::Inline;

method directive ($/) {
    make ($<directive_key>.Str => $<directive_value>.Str)
}
method directives ($/) {
    make (.made.key => .made.value for $<directive>);
}
method horizontal_rule ($/) {
    make Muse::Block::HorizontalRule.new();
}
method str ($/) {
    make Muse::Inline::Str.new(contents => $/.Str);
}
