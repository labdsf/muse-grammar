use v6;
unit grammar Muse::Grammar;

token TOP  { <directives> }

token eol { "\n" || $$ }
token ws { " " || "\t" }

token directive_key { <[a..zA..Z0..9-]>+ }
token directive_value { \N+ }
token directive { '#' <directive_key> ' '+ <directive_value> <.eol> }
token directives { <directive>* }

token comment { ';' (' ' \N+)? <.eol> }
token horizontal_rule { '-' ** 4..* <.ws>* <.eol> }

token block { <comment> || <horizontal_rule> || <para> }
token blocks { <block>+ }

token blankline { <ws>* "\n" || <ws>+ $$ }

token note_number { <[1..9]> <[0..9]>* }
token primary_note_label { '[' <note_number> ']' }
token secondary_note_label { '{' <note_number> '}' }

token header_marker { ^^ '*' ** 1..5 }

token para { <inlines> <.blankline>* }

token inlines { [<!before eol> <inline>]+ <.eol>? }

proto token inline { * }
      token inline:sym<str> { <str> }
      token inline:sym<space> { <space> }
      token inline:sym<emph> { <emph> }
      token inline:sym<strong> { <strong> }
      token inline:sym<symbol> { <-[ \x[8] \x[20] ]> }
token str { \w+ }
token space { <.ws>* "\n" || <.ws>+ }
token emph { '*' <!after ws> [<!before '*'> <inline>]+ '*' }
token strong { '**' <!after ws> [<!before '*'> <inline>]+ '**' }
