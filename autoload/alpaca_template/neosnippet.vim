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

  echo snip_word
  " " Insert snippets.
  " let next_line = getline('.')[a:col-1 :]
  " let snippet_lines = split(snip_word, '\n', 1)
  " if empty(snippet_lines)
  "   return
  " endif
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
