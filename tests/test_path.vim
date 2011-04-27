UTSuite Tests for the path addon.

let s:vals = {}
function! s:vals.True()
  return 1
endfunction
function! s:vals.False()
  return 0
endfunction

function! s:TestMakeVimPathsWin()
  Comment 'Test creation of comma-delimited paths'
        \ .' from `;`-delimited system paths.'
  let path = copy(g:path#path)
  let path.UseWindowsPaths = s:vals.True
  call path.Init()

  PrettyPrint path

  Assert path.MakeVimPath('one') == 'one'
  Assert path.MakeVimPath('one;two;three') == 'one,two,three'
  Assert path.MakeVimPath('o,n,e;two;three') == 'o\,n\,e,two,three'
endfunction

function! s:TestMakeVimPathsNonWin()
  Comment 'Test creation of comma-delimited paths'
        \ .' from `:`-delimited system paths.'
  let path = copy(g:path#path)
  let path.UseWindowsPaths = s:vals.False
  call path.Init()

  Assert path.MakeVimPath('one') == 'one'
  Assert path.MakeVimPath('one:two:three') == 'one,two,three'
  Assert path.MakeVimPath('o\:n\:e:two') == 'o:n:e,two'
  Assert path.MakeVimPath('o,n,e:two:three') == 'o\,n\,e,two,three'
endfunction
