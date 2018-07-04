set nocompatible
set ttyfast
set lazyredraw        " redraw only when we need to.
set background=dark
set t_Co=256          " modern terminal emulators support 256 colors
syntax on
set showcmd           " show command in bottom bar
set cursorline        " highlight current line
hi CursorLine cterm=NONE ctermbg=8
set switchbuf=useopen " don't duplicate an existing open buffer

set hlsearch
set showmatch
set matchtime=1

set expandtab
set tabstop=4
set shiftwidth=4
filetype plugin on
" filetype indent on
set backspace=indent,eol,start

set showmode
set ruler
