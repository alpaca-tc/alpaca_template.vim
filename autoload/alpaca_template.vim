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

function! alpaca_template#get_template(name)
  return get(s:template_names(), name)
endfunction

function! s:template_names()
  if !exists('s:template_directories')
    let s:template_directories = {}
    let template_directories = join(g:alpaca_template#template_paths, ',')
    let paths = split(globpath(template_directories, '*'), '\n')
    call filter(paths, 'isdirectory(v:val)')

    for dir in paths
      let dirname = fnamemodify(dir, ':t')
      let s:template_directories[dirname] = dir
    endfor
  endif

  return s:template_directories
endfunction

function! alpaca_template#complete_template_names(arg_lead, cmd_line, cursor_pos)
  return filter(keys(s:template_names()), 'v:val =~ "^" . a:arg_lead')
endfunction
