" Init plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin()
Plug 'bluz71/vim-nightfly-colors'
Plug 'Donaldttt/fuzzyy'
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'LunarWatcher/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'rbgrouleff/bclose.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto complete
Plug 'liuchengxu/vim-which-key'

Plug 'wuelnerdotexe/vim-astro'
call plug#end()

" Editor settings
syntax on
set shortmess=atI
set number
set noshowcmd noruler " Turn off this to improve nvim's performance
set nowrap
set mouse=a
set cul
set incsearch  " Enable incremental search
set hlsearch   " Enable highlight search
set splitbelow
set splitright
set encoding=utf-8
set nobackup
set nowritebackup
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

" Autopairs 
let g:AutoPairsMapBS = 1

" NerdTree
nnoremap <leader>e :NERDTreeToggle<CR>
let g:loaded_netrw       = 1 " disable netrw
let g:loaded_netrwPlugin = 1

" LSP settings
let g:coc_global_extensions = ['coc-marketplace', 'coc-snippets']
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

nmap <leader>ln <Plug>(coc-rename)
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

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Coc git
nmap <leader>hs :CocCommand git.chunkStage<cr>
nmap <leader>hu :CocCommand git.chunkUndo<cr>
nmap <leader>hi :CocCommand git.chunkInfo<cr>

" UI
let g:airline_symbols_ascii = 1
let g:airline#extensions#tabline#enabled = 1
set termguicolors
set background=dark
silent! colorscheme nightfly
set laststatus=2
set noshowmode
set showtabline=2

" WhichKey
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
let g:which_key_map = {}
let g:which_key_map.e = 'file explorer'
let g:which_key_map.f = { 'name' : '+find' }
let g:which_key_map.f.f = 'find file'
let g:which_key_map.f.b = 'find buffer'
let g:which_key_map.f.m = 'find MRU file'
let g:which_key_map.f.s = 'find string'
let g:which_key_map.h = { 'name' : '+hunks' }
let g:which_key_map.h.s = 'stage'
let g:which_key_map.h.u = 'undo'
let g:which_key_map.h.i = 'info'
let g:which_key_map.c = { 'name' : '+comment' }
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
let g:astro_typescript = 'enable' " Astro lang settings

