" path.vim
" Author: Ted Tibbetts
" License: Licensed under the same terms as Vim itself.
" General-purpose routines for path manipulation.
" The author has attempted to provide cross-platform compatibility,
" but the addon has not been tested on systems other than linux.

" Platform-specific path functionality.
" This is kept in an object to facilitate testing.
let path#path = {}
let s:path = path#path

  " This is (roughly) how it's done by vim
  " in `src/ex_getln.c`, function `expand_shellcmd`.
  function! s:path.UseWindowsPaths()
    return has('os2') || has('dos32') || has('dos16') ||
          \ has('gui_win32') || has('gui_win32s')
  endfunction

  " Figure out whether ':' or ';' is the path delimiter.
  " Also define the path separator as '/' or '\'
  " and declare a function to test whether or not a path is absolute.
  " TODO: Find out if there's a better way to do this.
  "       Ideally it would be possible to use vim's internal C functions.
  function! s:path.Init()
    if self.UseWindowsPaths()
      let self.pathdelim = ';'
      let self.pathsep = '\'
      function! self.IsAbsPath(path)
        return a:path =~ '^\a:[/\\]' || a:path =~ '^[/\\]\{2}'
      endfunction
    else
      let self.pathdelim = ':'
      let self.pathsep = '/'
      function! self.IsAbsPath(path)
        return a:path[0] == '/'
      endfunction
    endif
  endfunction

  function! s:path.IsRelPath(path)
    return a:path =~ '^\.\{1,2}\V' . escape(s:path.pathsep, '\')
  endfunction

  " Makes a comma-delimited path from a system path.
  function! s:path.MakeVimPath(syspath)
    let paths = escape#SplitOnUnescaped(a:syspath,
          \                                     self.pathdelim)
    let paths = map(paths, 'escape#Unescape(v:val, self.pathdelim)')
    let paths = map(paths, 'escape(v:val, '','')')
    return join(paths, ',')
  endfunction

  " Joins the directory a:parts with the path separator.
  function! s:path.Join(parts)
    return join(a:parts, self.pathsep)
  endfunction

  function! s:path.Rmdir(dirname)
    call system('rmdir ' . shellescape(a:dirname))
  endfunction

call s:path.Init()

