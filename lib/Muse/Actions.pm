use v6;
unit class Muse::Actions;
use Muse::Block;
use Muse::Inline;

method directive ($/) {
    make ($<directive_key>.Str => $<directive_value>.Str)
}
method directives ($/) {
    make $<directive>».made;
}
method horizontal_rule ($/) {
    make Muse::Block::HorizontalRule.new();
}
method str ($/) {
    make Muse::Inline::Str.new(contents => $/.Str);
}
method inline:sym<str> ($/) {
    make $<str>.made;
}
method emph ($/) {
    make Muse::Inline::Emph.new(contents => $<inline>».made);
}
method strong ($/) {
    make Muse::Inline::Strong.new(contents => $<inline>».made);
}
