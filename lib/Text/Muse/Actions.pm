use v6;
unit class Text::Muse::Actions;

method directive ($/) {
    make ($<directive_key>.Str => $<directive_value>.Str)
}
method directives ($/) {
    make (.made.key => .made.value for $<directive>);
}
