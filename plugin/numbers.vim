""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:           numbers.vim
" Maintainer:     Mahdi Yusuf yusuf.mahdi@gmail.com
" Version:        0.1.0
" Description:    vim global plugin for better line numbers.
" Last Change: 2013 Jun 17
" License:        MIT License
" Location:       plugin/numbers.vim
" Website:        https://github.com/myusuf3/numbers.vim
"
" See numbers.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:numbers_version = '0.2.0'

"Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_numbers") && g:loaded_numbers
    finish
endif
let g:loaded_numbers = 1

if (!exists('g:enable_numbers'))
	let g:enable_numbers = 1
endif

if v:version < 703 || &cp
    echomsg "numbers.vim: you need at least Vim 7.3 and 'nocp' set"
    echomsg "Failed loading numbers.vim"
    finish
endif

let g:mode=0
let g:center=1

function! SetNumbers()
    let g:mode = 1
    call ResetNumbers()
endfunc

function! SetRelative()
    let g:mode = 0
    call ResetNumbers()
endfunc

function! NumbersToggle()
    if (g:mode == 1)
        let g:mode = 0
        setlocal relativenumber
    else
        let g:mode = 1
        setlocal number
    endif
endfunc

function! ResetNumbers()
    if(g:center == 0)
        setlocal number
    elseif(g:mode == 0)
        setlocal relativenumber
    else
        setlocal number
    end
endfunc

function! Center()
    let g:center = 1
    call ResetNumbers()
endfunc

function! Uncenter()
    let g:center = 0
    call ResetNumbers()
endfunc

function! SetWidth()
    let &numberwidth=len(line("$"))+1
endfunction


function! NumbersEnable()
    let g:enable_numbers = 1
    augroup NumbersAug
        au!
        autocmd InsertEnter * :call SetNumbers()
        autocmd InsertLeave * :call SetRelative()
        autocmd BufNewFile  * :call ResetNumbers()
        autocmd BufReadPost * :call ResetNumbers()
        autocmd BufReadPost * :call SetWidth()
        autocmd FocusLost   * :call Uncenter()
        autocmd FocusGained * :call Center()
        autocmd WinEnter    * :call SetRelative()
        autocmd WinLeave    * :call SetNumbers()
    augroup END
endfunc

function! NumbersDisable()
    let g:enable_numbers = 0
    augroup NumbersAug
        au!
    augroup END
endfunc

function! NumbersOnOff()
    if (g:enable_numbers == 1)
        call NumbersDisable()
    else
        call NumbersEnable()
    endif
endfunc

" Commands
command! -nargs=0 NumbersToggle call NumbersToggle()
command! -nargs=0 NumbersEnable call NumbersEnable()
command! -nargs=0 NumbersDisable call NumbersDisable()
command! -nargs=0 NumbersOnOff call NumbersOnOff()

" reset &cpo back to users setting
let &cpo = s:save_cpo

if (g:enable_numbers)
	call NumbersEnable()
endif
