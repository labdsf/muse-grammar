use v6;

class Muse::Inline {
}

class Muse::Inline::Str is Muse::Inline {
    has Str $.contents;
}

class Muse::Inline::Emph is Muse::Inline {
    has Muse::Inline @.contents;
}

class Muse::Inline::Strong is Muse::Inline {
    has Muse::Inline @.contents;
}
