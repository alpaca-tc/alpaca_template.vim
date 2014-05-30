"=============================================================================
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Modified:  alpaca-tc <alpaca-tc@alpaca.tc>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

function! alpaca_template#neosnippet#substitute(content)
  let snip_word = a:content

  if snip_word =~ '\\\@<!`.*\\\@<!`'
    let snip_word = s:eval_snippet(snip_word)
  endif

  " Substitute escaped `.
  let snip_word = substitute(snip_word, '\\`', '`', 'g')

  " Substitute markers.
  let snip_word = substitute(snip_word,
        \ '\\\@<!'.neosnippet#get_placeholder_marker_substitute_pattern(),
        \ '<`\1`>', 'g')
  let snip_word = substitute(snip_word,
        \ '\\\@<!'.neosnippet#get_mirror_placeholder_marker_substitute_pattern(),
        \ '<|\1|>', 'g')
  let snip_word = substitute(snip_word,
        \ '\\'.neosnippet#get_mirror_placeholder_marker_substitute_pattern().'\|'.
        \ '\\'.neosnippet#get_placeholder_marker_substitute_pattern(),
        \ '\=submatch(0)[1:]', 'g')

  return snip_word
endfunction

function! s:eval_snippet(snippet_text)
  let snip_word = ''
  let prev_match = 0
  let match = match(a:snippet_text, '\\\@<!`.\{-}\\\@<!`')

  while match >= 0
    if match - prev_match > 0
      let snip_word .= a:snippet_text[prev_match : match - 1]
    endif
    let prev_match = matchend(a:snippet_text,
          \ '\\\@<!`.\{-}\\\@<!`', match)
    let snip_word .= eval(
          \ a:snippet_text[match+1 : prev_match - 2])

    let match = match(a:snippet_text, '\\\@<!`.\{-}\\\@<!`', prev_match)
  endwhile
  if prev_match >= 0
    let snip_word .= a:snippet_text[prev_match :]
  endif

  return snip_word
endfunction
