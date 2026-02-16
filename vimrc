" Init plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin()
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-commentary'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'rbgrouleff/bclose.vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto complete
Plug 'liuchengxu/vim-which-key'
call plug#end()

" Editor settings
syntax on
set shortmess=atI
set number
set relativenumber
set noshowcmd noruler " Turn off this to improve nvim's performance
set nowrap
set mouse=a
set cul
set clipboard=unnamedplus
set incsearch  " Enable incremental search
set hlsearch   " Enable highlight search
set splitbelow
set splitright
set encoding=utf-8
set nobackup
set nowritebackup
set noswapfile
set updatetime=100
set signcolumn=yes
set timeoutlen=500
set wildmenu
set nocompatible
set belloff=all
set foldmethod=indent
set foldlevel=100

" Leader key
let g:mapleader = "\<Space>"

" Indent settings
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set cindent

" NerdTree
nnoremap <leader>e :NERDTreeToggle<CR>
let g:loaded_netrw       = 1 " disable netrw
let g:loaded_netrwPlugin = 1

" LSP settings
let g:coc_global_extensions = [
    \ 'coc-marketplace',
    \ 'coc-snippets',
    \ 'coc-clangd',
    \ 'coc-json',
    \ 'coc-pairs',
    \ 'coc-pyright',
    \ 'coc-rust-analyzer'
    \ ]
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

command! -nargs=0 Format :call CocActionAsync('format') " Add format command

augroup mygroup
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

nmap <leader>lr <Plug>(coc-rename)
nmap <leader>la  <Plug>(coc-codeaction-cursor)
nmap <leader>lf  :Format<CR>

nnoremap <silent><nowait> <leader>ld  :<C-u>CocList diagnostics<cr> " Show all diagnostics
nnoremap <silent><nowait> <leader>lo  :<C-u>CocList outline<cr> " Find symbol of current document
nnoremap <silent><nowait> <leader>ls  :<C-u>CocList -I symbols<cr> " Search workspace symbols

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Auto pairs
autocmd FileType markdown let b:coc_pairs_disabled = ['`']
autocmd FileType rust let b:coc_pairs_disabled = ["'"]

" Buffer
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap <leader>c :Bclose<CR>
nnoremap <leader>bc :BufOnly<CR>

" Git gutter
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gr <Plug>(GitGutterUndoHunk)
nmap <leader>gp <Plug>(GitGutterPreviewHunk)

" Clear search highlight on Esc
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" VIM easymotion
nmap <S-s> <Plug>(easymotion-sn)

" UI
let g:airline_symbols_ascii = 1
let g:airline#extensions#tabline#enabled = 1
set termguicolors
set background=dark
silent! colorscheme solarized8
set laststatus=2
set noshowmode
set showtabline=2

" Fzf.vim
command! -nargs=? -complete=dir FilesNoHidden call fzf#vim#files(<q-args>, {'source': 'rg --files -g "!.git/*"'})
command! -nargs=? -complete=dir FilesHidden call fzf#vim#files(<q-args>, {'source': 'rg --files --hidden --follow -g "!.git/*"'})
function! s:rg_with_cmd(cmd, prompt, query) abort
  let l:query = a:query
  if l:query ==# ''
    let l:reload = a:cmd . ' -- {q}'
    let l:opts = fzf#vim#with_preview({'options': ['--prompt', a:prompt, '--phony', '--query', '', '--bind', 'change:reload:' . l:reload]})
    call fzf#vim#grep('printf ""', 1, l:opts, 0)
    return
  endif
  call fzf#vim#grep(a:cmd . ' ' . shellescape(l:query), 1, fzf#vim#with_preview({'options': ['--prompt', a:prompt]}), 0)
endfunction
command! -nargs=* RgNoHidden call s:rg_with_cmd('rg --column --line-number --no-heading --color=always --smart-case -g "!.git/*"', 'RgNoHidden> ', <q-args>)
command! -nargs=* RgHidden call s:rg_with_cmd('rg --column --line-number --no-heading --color=always --smart-case --hidden --follow -g "!.git/*"', 'RgHidden> ', <q-args>)

" WhichKey
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <leader>ff :FilesNoHidden<CR>
nnoremap <silent> <leader>fF :FilesHidden<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fs :History<CR>
nnoremap <silent> <leader>fw :RgNoHidden<CR>
nnoremap <silent> <leader>fW :RgHidden<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader>fc :Commands<CR>
nnoremap <silent> <leader>fh :Helptags<CR>
nnoremap <silent> <leader>fm :Marks<CR>
nnoremap <silent> <leader>ft :Tags<CR>
let g:which_key_map = {}
let g:which_key_map.e = 'file explorer'
let g:which_key_map.f = { 'name' : '+find' }
let g:which_key_map.f.f = 'find file (no hidden)'
let g:which_key_map.f.F = 'find file (hidden)'
let g:which_key_map.f.b = 'find buffer'
let g:which_key_map.f.s = 'find MRU file'
let g:which_key_map.f.w = 'find string (no hidden)'
let g:which_key_map.f.W = 'find string (hidden)'
let g:which_key_map.f.g = 'find git file'
let g:which_key_map.f.l = 'find line'
let g:which_key_map.f.c = 'find command'
let g:which_key_map.f.h = 'find help'
let g:which_key_map.f.m = 'find mark'
let g:which_key_map.f.t = 'find tag'
let g:which_key_map.g = { 'name' : '+git' }
let g:which_key_map.g.s = 'stage hunk'
let g:which_key_map.g.r = 'reset hunk'
let g:which_key_map.g.p = 'preview'
let g:which_key_map.b = { 'name' : '+buffer' }
let g:which_key_map.l = { 'name' : '+lsp' }
let g:which_key_map.l.n = 'rename'
let g:which_key_map.l.a = 'code action'
let g:which_key_map.l.f = 'format'
let g:which_key_map.l.d = 'diagnostics'
let g:which_key_map.l.o = 'outline'
let g:which_key_map.l.s = 'symbols'
let g:which_key_map.l.g = { 'name' : '+goto' }
let g:which_key_map.l.g.d = 'definition'
let g:which_key_map.l.g.t = 'type definition'
let g:which_key_map.l.g.i = 'implementation'
let g:which_key_map.l.g.r = 'references'
silent! call which_key#register('<Space>', "g:which_key_map")

" Lang
autocmd FIletype c,cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
