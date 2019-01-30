set nocompatible
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ciaranm/inkpot'
Plugin 'dracula/vim'
Plugin 'autoload_cscope.vim'
Plugin 'sheerun/vim-polyglot'

call vundle#end()            " required
filetype plugin indent on    " required
set backspace=indent,eol,start
" show existing tab with 4 spaces width
set tabstop=4
"
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

inoremap jk <esc>
set colorcolumn=80
highlight ColorColumn ctermbg=darkgrey guibg=darkgrey
syntax on
set incsearch
set ruler
 
colo dracula
let g:dracula_italic = 0
let g:dracula_bold = 0
let g:dracula_underline = 0
let g:dracula_undercurl = 0

" Search and replace word under cursor using F4
" nnoremap <F4> :%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/i

" Shortcut for ctags autocomplete
inoremap <c-x><c-]> <c-]>

" Search recursively up directories until tags is found
" Requires that tags is generated manually the first time
set tags=tags;$HOME/sram
" Set PROJ_ROOT to directory holding the tags file
if (len(tagfiles()) > 0)
    let $PROJ_ROOT = fnamemodify(tagfiles()[0], ':p:h')
    " Set path to include all child directories below PROJ_ROOT
    " Allows :find and similar functions to jump to other known files regardless
    " of working directory
    set path=$PROJ_ROOT/**
    let $CSCOPE_DB = $PROJ_ROOT."/cscope.out"
    let $CSCOPE_FILES = $PROJ_ROOT."/cscope.files"
    cs add $CSCOPE_DB
    " Regenerate ctags and cscope databases from any child of project directory
    nmap <c-c><c-c> :!find $PROJ_ROOT -iname '*.c' -o -iname '*.mk' -o -iname '*.h' > $CSCOPE_FILES<CR>
      \:!cscope -RCbk -i $CSCOPE_FILES -f $CSCOPE_DB<CR>
      \:cs reset<CR>
      \:!ctags -R -o $PROJ_ROOT/tags.tmp $PROJ_ROOT<CR>
      \:!mv $PROJ_ROOT/tags.tmp $PROJ_ROOT/tags<CR>
endif

" regex  instead of whole word completion
nnoremap <leader>f :find 
" restrict the matching to files under the directory
" of the current file, recursively
nnoremap <leader>F :find <C-R>=expand('%:p:h').'/**/'<CR>

" same as the two above but opens the file in an horizontal window
nnoremap <leader>s :sfind 
nnoremap <leader>S :sfind <C-R>=expand('%:p:h').'/**/'<CR>

" same as the two above but with a vertical window
nnoremap <leader>v :vert sfind 
nnoremap <leader>V :vert sfind <C-R>=expand('%:p:h').'/**/*'<CR>

" Find my personal tag.
command! LDUB noautocmd vimgrep /ldub/j $PROJ_ROOT/**/*.c | cw
" Find TODO tag
command! TODO noautocmd vimgrep /TODO\|todo/j $PROJ_ROOT/**/*.c | cw

" Make current file the working directory for this window
command! WD noautocmd lcd %:p:h
" Make current file the working directory for all windows
command! WDS noautocmd cd %:p:h

" For filename collisions, provide a dropdown list of found files.
command! -nargs=1 FF let i=1|let mm=findfile(<q-args>, '', -1)|for f in mm| echo i.':'.f|let i+=1 |endfor|let choice=input('FF: ')|exec 'e ' . mm[choice-1]

nnoremap <c-p> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>
set wildmenu
set wildmode=list:full
