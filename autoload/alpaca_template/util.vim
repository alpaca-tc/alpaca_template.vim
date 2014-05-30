function! alpaca_template#util#input(message, ...)
  let default = len(a:000) > 0 ? a:1 : ''

  while 1
    let input = input(a:message, default)
    if !empty(input)
      return input
    endif
  endwhile
endfunction
