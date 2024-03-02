" Install node
if executable('node') == 0
    silent execute '!curl -sL install-node.vercel.app/lts | bash'
endif

" Init plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugins
call plug#begin()
Plug 'joshdick/onedark.vim' 
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot' " syntax highlight
Plug 'ctrlpvim/ctrlp.vim' " Fuzz findings
Plug 'vim-scripts/bufexplorer.zip'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary' " Add comments quickly
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto complete
Plug 'liuchengxu/vim-which-key'
Plug 'github/copilot.vim'
call plug#end()

" Editor settings
syntax on
set shortmess=atI
set number
set nowrap
set relativenumber
set mouse=a
set cul
set incsearch  " Enable incremental search
set hlsearch   " Enable highlight search
set splitbelow
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

" Git
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

" WhichKey
let g:mapleader = "\<Space>"
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

" NerdTree
nnoremap <leader>e :NERDTreeToggle<CR>

" Lsp settings
let g:coc_global_extensions = ['coc-marketplace', 'coc-snippets', 'coc-pairs']
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr> " Show all diagnostics
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr> " Find symbol of current document
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr> " Search workspace symbols
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Copilot
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" UI
colorscheme onedark
set termguicolors
set background=dark
let g:onedark_hide_endofbuffer=1
let g:onedark_termcolors=256
if has("gui_running")
    set guifont=SF\ Mono:h13
    set guioptions-=r
    set guioptions-=L
endif

" Indent settings
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

" Key bindings
nnoremap <silent> <Esc> :let @/ = ""<CR>
