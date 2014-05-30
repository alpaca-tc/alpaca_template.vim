function! alpaca_template#load(...)
  let option = s:parse_option(a:000)
  call s:ask_environment(option)
  call alpaca_template#template#initialize(option)
endfunction

function! s:parse_option(option)
  let option = {}
  let option['template_name'] = a:option[0]

  return option
endfunction

function! s:ask_environment(option)
  let target_directory = ''

  while !isdirectory(target_directory)
    let target_directory = alpaca_template#util#input('Target directory: ', getcwd())
  endwhile

  let a:option['target_directory'] = target_directory
endfunction
