use v6;
use Muse::Inline;

class Muse::Block {
}

class Muse::Block::HorizontalRule is Muse::Block {
}

class Muse::Block::Para is Muse::Block {
    has Muse::Inline @.contents;
}
