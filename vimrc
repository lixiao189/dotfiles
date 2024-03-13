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
Plug 'lifepillar/vim-solarized8'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'LunarWatcher/auto-pairs'
Plug 'sheerun/vim-polyglot' " syntax highlight
Plug 'charlespascoe/vim-go-syntax'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension'  }
Plug 'jlanzarotta/bufexplorer'
Plug 'rbgrouleff/bclose.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto complete
Plug 'liuchengxu/vim-which-key'
Plug 'github/copilot.vim'
Plug 'imsnif/kdl.vim' " KDL lang support
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
set splitright
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set timeoutlen=500
set nocompatible
set belloff=all
set foldmethod=indent
set foldlevel=100

" Indent settings
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smartindent

" GIT
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

" NerdTree
let g:loaded_netrw       = 1 " disable netrw
let g:loaded_netrwPlugin = 1

" LeaderF
let g:Lf_WindowPosition = 'popup'

" LSP settings
let g:coc_global_extensions = ['coc-marketplace', 'coc-snippets', 'coc-yank']
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

" Copilot
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" UI
set background=dark
set termguicolors
autocmd vimenter * ++nested colorscheme solarized8
set laststatus=2
set noshowmode
set showtabline=2
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE " transparent bg
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' '). get(g:, 'coc_status', '')
endfunction
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'cocstatus': 'StatusDiagnostic',
      \ },
      \ }
let g:lightline#bufferline#show_number = 1
if has("gui_running")
    set guifont=SF\ Mono:h12
endif

" Keybindings 
let g:mapleader = "\<Space>"
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
let g:Lf_ShortcutF = "<leader>ff"
nmap <unique> <leader>fr <Plug>LeaderfRgPrompt
nmap <leader>ln <Plug>(coc-rename)
nmap <leader>la  <Plug>(coc-codeaction-cursor)
nmap <leader>lf  :Format<CR>
nnoremap <silent><nowait> <leader>ld  :<C-u>CocList diagnostics<cr> " Show all diagnostics
nnoremap <silent><nowait> <leader>lo  :<C-u>CocList outline<cr> " Find symbol of current document
nnoremap <silent><nowait> <leader>ls  :<C-u>CocList -I symbols<cr> " Search workspace symbols
nmap <leader>lgd <Plug>(coc-definition)
nmap <leader>lgt <Plug>(coc-type-definition)
nmap <leader>lgi <Plug>(coc-implementation)
nmap <leader>lgr <Plug>(coc-references)

" WhichKey
let g:which_key_map = {}
let g:which_key_map.e = 'file explorer'
let g:which_key_map.y = 'yank history'
let g:which_key_map.f = { 'name' : '+leaderF' }
let g:which_key_map.f.f = 'find file'
let g:which_key_map.f.r = 'find regex'
let g:which_key_map.b = { 'name' : '+buffer' }
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
call which_key#register('<Space>', "g:which_key_map")

