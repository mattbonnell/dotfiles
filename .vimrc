" NVim Configuration

" -------------------------------------------------------------------------------------------------
" Plugins
" -------------------------------------------------------------------------------------------------
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
 silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
 \| PlugInstall --sync | source $MYVIMRC
\| endif

function! BuildComposer(info)
if a:info.status != 'unchanged' || a:info.force
  if has('nvim')
    !cargo build --release --locked
  else
    !cargo build --release --locked --no-default-features --features json-rpc
  endif
endif
endfunction

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'Konfekt/vim-alias'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" -------------------------------------------------------------------------------------------------
" General
" -------------------------------------------------------------------------------------------------

" Colorscheme
colorscheme nord

" auto set working directory to directory of current file
" set autochdir

" show line numbers by default
set number

" usual behavior of <Esc> even in :term windows
tnoremap <Esc> <C-\><C-n>

" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" make vim use system clipboard
set clipboard=unnamedplus

" filetype-specific
filetype on
filetype plugin on
filetype indent on

autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType c setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType h setlocal shiftwidth=4 tabstop=4 expandtab

" Custom functions
function MoveToPrevTab()
 "there is only one window
 if tabpagenr('$') == 1 && winnr('$') == 1
   return
 endif
 "preparing new window
 let l:tab_nr = tabpagenr('$')
 let l:cur_buf = bufnr('%')
 if tabpagenr() != 1
   close!
   if l:tab_nr == tabpagenr('$')
     tabprev
   endif
   sp
 else
   close!
   exe "0tabnew"
 endif
 "opening current buffer in new window
 exe "b".l:cur_buf
endfunc

" change without yanking
nnoremap c "_c
vnoremap c "_c

" replace currently selected text with default register
" without yanking it
vnoremap p "_dP

" -------------------------------------------------------------------------------------------------
" NERDTree
" -------------------------------------------------------------------------------------------------

"open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" map CTRL+n to :NERDTreeToggle
map <silent> <C-n> :NERDTreeToggle<CR>

" -------------------------------------------------------------------------------------------------
" vim-go
" -------------------------------------------------------------------------------------------------

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
" vim-go settings
let g:go_highlight_structs = 1
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_auto_type_info =1
let g:go_fmt_autosave = 1
let g:go_mod_fmt_autosave = 1
let g:go_gopls_enabled = 1
let g:go_gopls_staticcheck = v:null
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:go_metalinter_command = 'gopls'
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:coc_snippet_next = '<tab>'
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" -------------------------------------------------------------------------------------------------
" coc.nvim
" -------------------------------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
" set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Use :Prettier to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Markdown preview
let vim_markdown_preview_github=1
