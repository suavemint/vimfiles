let mapleader = ','
execute pathogen#infect()
set sessionoptions-=options
syntax on
set number
set backspace=indent,eol,start
" note that the following rval is made by hitting ctrl-v and then backspace...
" this remaps backspace to actualy BACKSPACE - not delete.
set t_kb=ctrl-vBACKSPACE
fixdel
au BufWinLeave * mkview
" au BufWinEnter * silent loadview
set nocompatible ruler laststatus=2 showcmd showmode number
"python customizations follow.
set ts=2
set sw=2
set smarttab
set expandtab
set softtabstop=2
set shiftwidth=2
set autoindent
set ai

set ignorecase smartcase
set cursorline
set showtabline=2

set hlsearch
set incsearch
highlight Search cterm=underline term=underline
" Turn off search highlight.
nnoremap <leader><space> :nohlsearch<CR>

" Highlight keyword pairs like do/end.
runtime macros/matchit.vim

" Enable slim syntax highlighting.
autocmd FileType slim setlocal foldmethod=indent
autocmd BufNewFile,BufRead *.slim set filetype=slim

" Set background and color scheme.
let g:solarized_termcolors=256
"if has('gui_running')
"    set background=light
"else
"    set background=dark
"endif
set background=dark
colorscheme solarized

autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
filetype on
autocmd FileType python set omnifunc=pythoncomplete#Complete
filetype plugin on
filetype indent on
set ofu=syntaxcomplete#Complete
set t_Co=256
autocmd FileType ruby compiler ruby
" autocmd FileType python,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e
" Python execution in separate shell via F5.
" autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
" autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" autocmd BufRead *.py nmap <F5> :!python %<CR>

" Flexible window resizing when they lose focus to another:
"
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

" Relink the move-to-window key commands.
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

" Make Esc kill open Command-T popover.
if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap = ['<ESC>', '<C-c>']
    endif

" Rails convenience key commands.
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets<cr>
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>

" " Open files with <leader>f
" map <leader>f :CommandTFlush<cr>\|:CommandT<cr>

" " Open files, limited to the directory of the current file, with <leader>gf
" " This requires the %% mapping found below.
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>

" " Switch between the last two files.
nnoremap <leader><leader> <c-^>

" " View or edit files in same directory as current file.
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" "" Run Rspecs in various ways.
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    exec ":!bundle exec rspec " . a:filename
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

" Run the corresponding rspec file.
map <leader>r :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>uc :call RunNearestTest()<cr>
" Run all test files
map <leader>a :call RunTests('spec')<cr>
""
