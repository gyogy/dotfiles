" Stop pretending you're vi
set nocompatible

" SYNTAX
syntax enable
filetype plugin on

" LINE NUMBERS
" Show line numbers
set number

" Toggle numbers between modes
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
    \ if &nu && mode() != "i" | set rnu | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set nornu | endif
augroup END

" TAB
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Misc
set noswapfile
set autoindent
set smartindent
set nohlsearch
set incsearch
set nowrap
set textwidth=79
set colorcolumn=80
set termguicolors

" TITLE BAR
set title
set titlestring=%f

" STATUS BAR
set laststatus=2
set statusline=%!getcwd()

" Open new splits to the right and bottom
set splitbelow
set splitright

" REMAPS
inoremap kj <esc>
vnoremap kj  <esc>
cnoremap kj <C-C>
" Quiker splits movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" set j timeout in insert mode
set timeoutlen=500

" FINDING FILES
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer

" Use a line cursor within insert mode and a block cursor everywhere else.
" "
" " Reference chart of values:
" "   Ps = 0  -> blinking block.
" "   Ps = 1  -> blinking block (default).
" "   Ps = 2  -> steady block.
" "   Ps = 3  -> blinking underline.
" "   Ps = 4  -> steady underline.
" "   Ps = 5  -> blinking bar (xterm).
" "   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

