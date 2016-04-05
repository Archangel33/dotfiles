" Modeline and Notes {{{
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=9 foldmethod=marker spell:
" }}}

" empty sections to be filled {{{
" 1 important {{{

" }}}

" 2 moving around {{{

" }}}

" 3 tags {{{

" }}}

" 4 displaying text {{{

" }}}

" 5 syntax, highlighting and spelling {{{

" }}}

" 6 multiple windows {{{

" }}}

" 7 multiple tab pages {{{

" }}}

" 8 terminal {{{

" }}}

" 9 using the mouse {{{

" }}}

" 10 GUI {{{

" }}}

" 11 printing {{{

" }}}

" 12 messages and info {{{

" }}}

" 13 selecting text {{{

" }}}

" 14 editing text {{{

" }}}

" 15 tabs and indenting {{{

" }}}

" 16 folding {{{

" }}}

" 17 diff mode {{{

" }}}

" 18 mapping {{{

" }}}

"19 reading and writing files {{{

" }}}

"20 the swap file {{{

" }}}

"21 command line editing {{{

" }}}

"22 executing external commands {{{

" }}}

"23 running make and jumping to errors {{{

" }}}

"24 system specific {{{

" }}}

"25 language specific {{{

" }}}

"26 multi-byte characters {{{

" }}}

"27 various {{{

" }}}
" }}} sections

" Environment {{{

" Identify platform {{{
silent function! OSX()
return has('macunix')
endfunction
silent function! LINUX()
return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
return  (has('win32') || has('win64'))
endfunction
" }}}

" Basics {{{
set nocompatible        " Must be first line
if !WINDOWS()
    set shell=/bin/sh
endif
" }}}

" Windows Compatible {{{
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
" }}}

" Arrow Key Fix {{{
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
endif
" }}}

" Define File locations {{{
let g:vimrcDir="~/.vim/rc/"
let g:vimrcBundles="~/.vim/rc/vimrc.bundles"
let g:vimrc="~/.vimrc"
" }}}

" Use bundles config {{{
if filereadable(expand(g:vimrcBundles))
    execute "source " . g:vimrcBundles
endif
" }}}
" }}} Environment

" General {{{

set background=dark         " Assume a dark background

if !has('gui')
    set term=$TERM          " Make arrow and other keys work
endif
filetype plugin indent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
scriptencoding utf-8

if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" Automatically switch to the current file directory when
" a new buffer is opened
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
" Always switch to the current file directory

"set autowrite                       " Automatically write a file when leaving a modified buffer
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set spell                           " Spell checking on
set hidden                          " Allow buffer switching without saving
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
" ResCur {{{
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END
" }}}

" Setting up the directories {{{
set backup                  " Backups are nice ...
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" }}}

" }}}

" Vim UI {{{

if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    let g:solarized_termcolors=16
    "let g:solarized_termtrans=1
    "let g:solarized_contrast="normal"
    "let g:solarized_visibility="normal"
    colorscheme solarized             " Load a colorscheme
endif

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
    " Selected characters/lines in visual mode
endif

if has('statusline')
    set laststatus=2

    " build statusline
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set foldlevelstart=10           " set foldlevel on buffer open
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set encoding=utf8
" set cursor to be a block
set gcr=a:block
" mode aware cursors
set gcr+=o:hor50-Cursor
set gcr+=n:Cursor
set gcr+=i-ci-sm:InsertCursor
set gcr+=r-cr:ReplaceCursor-hor20
set gcr+=c:CommandCursor
set gcr+=v-ve:VisualCursor
set gcr+=a:blinkon0

hi Cursor        ctermfg=15 guifg=#fdf6e3 ctermbg=2   guibg=#859900
hi InsertCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=3   guibg=#b58900
hi VisualCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=5   guibg=#d33682
hi ReplaceCursor ctermfg=15 guifg=#fdf6e3 ctermbg=1   guibg=#dc322f
hi CommandCursor ctermfg=15 guifg=#fdf6e3 ctermbg=9   guibg=#cb4b16

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set cursorline                  " Highlight current line

hi clear LineNr          " Current line number row will have same background color in relative mode
hi clear CursorLineNr    " Remove highlight color from current line number
hi CursorLine ctermbg=0

" if compiled with colorcolumn
if (exists('+colorcolumn'))
    set colorcolumn=80
    hi ColorColumn ctermbg=0
endif

hi clear SignColumn      " SignColumn should match background
"hi GitGutterAdd
"hi GitGutterChange
"hi GitGutterDelete
"hi GitGutterChangeDelete

" }}}

" Formatting {{{

set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

autocmd FileType ruby let b:noStripTrailingWhitespace=1
autocmd FileType ruby let b:noAutoStripTrailingWhitespace=1
autocmd FileType * autocmd BufWritePre <buffer> call StripTrailingWhitespace()

"autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,vim,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()

" Filetype lines best in a plugin but here for now.
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
" Workaround vim-commentary for Haskell
autocmd FileType haskell setlocal commentstring=--\ %s
" Workaround broken colour highlighting in Haskell
autocmd FileType haskell,rust setlocal nospell

" }}}

" Key (re)Mappings {{{

" The default leader is '\', I prefer ',' as it's in a standard
" location.
let mapleader = ','
let maplocalleader = '_'

" Easier moving in tabs and windows
" The lines conflict with the default digraph mapping of <C-K>
noremap <C-J> <C-W>j<C-W>_
noremap <C-K> <C-W>k<C-W>_
noremap <C-L> <C-W>l<C-W>_
noremap <C-H> <C-W>h<C-W>_
" Adjust viewports to the same size
noremap <leader>= <C-w>=

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Default vim behaviour is to act relative to text line in both cases
" Same for 0, home, end, etc
function! WrapRelativeMotion(key, ...)
    let vis_sel=""
    if a:0
        let vis_sel="gv"
    endif
    if &wrap
        execute "normal!" vis_sel . "g" . a:key
    else
        execute "normal!" vis_sel . a:key
    endif
endfunction

" Map g* keys in Normal, Operator-pending, and Visual+select
noremap $ :call WrapRelativeMotion("$")<CR>
noremap <End> :call WrapRelativeMotion("$")<CR>
noremap 0 :call WrapRelativeMotion("0")<CR>
noremap <Home> :call WrapRelativeMotion("0")<CR>
noremap ^ :call WrapRelativeMotion("^")<CR>
" Overwrite the operator pending $/<End> mappings from above
" to force inclusive motion with :execute normal!
onoremap $ v:call WrapRelativeMotion("$")<CR>
onoremap <End> v:call WrapRelativeMotion("$")<CR>
" Overwrite the Visual+select mode mappings from above
" to ensure the correct vis_sel flag is passed to function
vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

" The following two lines conflict with moving to top and
" bottom of the screen
noremap <S-H> gT
noremap <S-L> gt

" Stupid shift key fixes
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Code folding options
nnoremap <leader>f0 :set foldlevel=0<CR>
nnoremap <leader>f1 :set foldlevel=1<CR>
nnoremap <leader>f2 :set foldlevel=2<CR>
nnoremap <leader>f3 :set foldlevel=3<CR>
nnoremap <leader>f4 :set foldlevel=4<CR>
nnoremap <leader>f5 :set foldlevel=5<CR>
nnoremap <leader>f6 :set foldlevel=6<CR>
nnoremap <leader>f7 :set foldlevel=7<CR>
nnoremap <leader>f8 :set foldlevel=8<CR>
nnoremap <leader>f9 :set foldlevel=9<CR>

" clear the current search results.
nnoremap <silent> <leader>/ :nohlsearch<CR>
" toggle hilighting of search results
" nmap <silent> <leader>/ :set invhlsearch<CR>

" Find merge conflict markers
noremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Shortcuts
" Change Working Directory to that of the current file
cnoremap cwd lcd %:p:h
cnoremap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cnoremap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
noremap <leader>ew :e %%
noremap <leader>es :sp %%
noremap <leader>ev :vsp %%
noremap <leader>et :tabe %%

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nnoremap <leader>ff [I:let nr = input("GoTo: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier horizontal scrolling
noremap zl zL
noremap zh zH

" Easier formatting
nnoremap <silent> <leader>q gwip

" Set leader o to insert lines before or after current line
" without exiting Normal mode
nnoremap <leader>o o<ESC>
nnoremap <leader>O O<ESC>

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

"  -- / == to left/right through tabs
noremap -- :bp<CR>
noremap == :bn<CR>
noremap <leader>h <C-w>h
noremap <leader>j <C-w>j
noremap <leader>k <C-w>k
noremap <leader>l <C-w>l

" }}}

" Plugins {{{

" TextObj Sentence {{{
if count(g:bundle_groups, 'writing')
    augroup textobj_sentence
        autocmd!
        autocmd FileType markdown call textobj#sentence#init()
        autocmd FileType textile call textobj#sentence#init()
        autocmd FileType text call textobj#sentence#init()
    augroup END
endif
" }}}

" TextObj Quote {{{
if count(g:bundle_groups, 'writing')
    augroup textobj_quote
        autocmd!
        autocmd FileType markdown call textobj#quote#init()
        autocmd FileType textile call textobj#quote#init()
        autocmd FileType text call textobj#quote#init({'educate': 0})
    augroup END
endif
" }}}

" Misc {{{
if isdirectory(expand("~/.vim/bundle/matchit.zip"))
    let b:match_ignorecase = 1
endif
" }}}

" OmniComplete {{{
" To disable omni complete, add the following if statement:
"if has("autocmd") && exists("+omnifunc")
"    autocmd Filetype *
"                \if &omnifunc == "" |
"                \setlocal omnifunc=syntaxcomplete#Complete |
"                \endif
"endif

hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

" Some convenient mappings
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,preview,longest
" }}}

" Ctags {{{
set tags+=./tags;/,~/.vimtags,.vim/rc/tags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" }}}

" AutoCloseTag {{{
" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }}}

" SnipMate {{{
" Setting the author var
let g:snips_author = 'Michael Reed <Michael.Reed33@gmail.com>'
" }}}

" NerdTree {{{
if isdirectory(expand("~/.vim/bundle/nerdtree"))
    map <C-e> <plug>NERDTreeTabsToggle<CR>
    map <leader>e :NERDTreeFind<CR>
    nmap <leader>nt :NERDTreeFind<CR>

    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    let g:nerdtree_tabs_open_on_gui_startup=0
endif
" }}}

" Tabularize {{{
if isdirectory(expand("~/.vim/bundle/tabular"))
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    nmap <Leader>a=> :Tabularize /=><CR>
    vmap <Leader>a=> :Tabularize /=><CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif
" }}}

" Session List {{{
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
    nmap <leader>sl :SessionList<CR>
    nmap <leader>ss :SessionSave<CR>
    nmap <leader>sc :SessionClose<CR>
endif
" }}}

" JSON {{{
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
let g:vim_json_syntax_conceal = 0
" }}}

" PyMode {{{
" Disable if python support not present
if !has('python') && !has('python3')
    let g:pymode = 0
endif

if isdirectory(expand("~/.vim/bundle/python-mode"))
    let g:pymode_lint_checkers = ['pyflakes']
    let g:pymode_trim_whitespaces = 0
    let g:pymode_options = 0
    let g:pymode_rope = 0
endif
" }}}

" ctrlp {{{
if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
    let g:ctrlp_working_path_mode = 'ra'
    nnoremap <silent> <D-t> :CtrlP<CR>
    nnoremap <silent> <D-r> :CtrlPMRU<CR>
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

    if executable('ag')
        let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
    elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
    elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
        " On Windows use "dir" as fallback command.
    elseif WINDOWS()
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
    else
        let s:ctrlp_fallback = 'find %s -type f'
    endif
    if exists("g:ctrlp_user_command")
        unlet g:ctrlp_user_command
    endif
    let g:ctrlp_user_command = {
                \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
                \ }

    if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
        " CtrlP extensions
        let g:ctrlp_extensions = ['funky']

        "funky
        nnoremap <Leader>fu :CtrlPFunky<Cr>
    endif
endif
" }}}

" TagBar {{{
if isdirectory(expand("~/.vim/bundle/tagbar/"))
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
endif
" }}}

" Rainbow {{{
if isdirectory(expand("~/.vim/bundle/rainbow/"))
    let g:rainbow_active = 0 "0 if you want to enable it later via :RainbowToggle
endif
" }}}

" Fugitive {{{
if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif
" }}}

" UndoTree {{{
if isdirectory(expand("~/.vim/bundle/undotree/"))
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
endif
" }}}

" indent_guides {{{
if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
endif
" }}}

" Wildfire {{{
let g:wildfire_objects = {
            \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
            \ "html,xml" : ["at"],
            \ }
" }}}

" vim-airline {{{
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
" segments add the following to your .vimrc.before.local file:
"   let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.

" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
if isdirectory(expand("~/.vim/bundle/vim-airline/"))
    let g:airline_theme = 'solarized'
    let g:airline_powerline_fonts = 1
    let g:airline_inactive_collapse = 1
    let g:airline#extensions#tabline#enabled = 1

endif
" }}}

" }}} Plugins

" GUI Settings {{{

" GVIM- (here instead of .gvimrc)
if has('gui_running')
    set guioptions-=T           " Remove the toolbar
    set lines=40                " 40 lines of text instead of 24
    if LINUX() && has("gui_running")
        set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
    elseif OSX() && has("gui_running")
        set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
    elseif WINDOWS() && has("gui_running")
        set guifont=Sauce_Code_Powerline:h9:cANSI,Menlo:h10,Consolas:h10,Courier_New:h10
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    endif
    "set term=builtin_ansi       " Make arrow and other keys work
endif

" }}}

" Functions {{{

" Initialize directories {{{
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    " Specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories
    let common_dir = $HOME . '/.vim/' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }}}

" Initialize NERDTree as needed {{{
function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction
" }}}

" Strip whitespace {{{
function! StripTrailingWhitespace()
    " Only if b:noStripTrailingWhitespace variable isn't set
    if exists('b:noStripTrailingWhitespace')
        return
    endif
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! TrimTrailingWhitespace call StripTrailingWhitespace()
command! StripTrailingWhitespace call StripTrailingWhitespace()

" }}}

" MkDir & Confirm {{{
" define function to confirm creating a directory if it doesn't exist
function! MkDirAndConfirm(path, dir)
    silent doautocmd BufWritePre

    " Directory exists, :write and return
    if isdirectory(a:dir)
        execute 'write ' . a:path
        silent doautocmd BufWritePost
        return
    endif

    " Ask for confirmation to create this directory
    echohl Question
    echo "Create directory '". a:dir . "' [y/N]? "
    echohl None

    let response = nr2char(getchar())
    " mkdir() and :write if we want to make the directory
    if response ==? "y"
        call mkdir(a:dir, "p")
        execute 'write ' . a:path
        silent doautocmd BufWritePost
    endif
endfunction
" call MkDirAndConfirm on buff write
autocmd BufWriteCmd * call MkDirAndConfirm(expand("<amatch>:p"), expand("<amatch>:p:h"))
"}

" Shell command {{{
function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }}}

" Edit .vimrc {{{
function! s:ExpandFilenameAndExecute(command, file)
    execute a:command . " " . expand(a:file, ":p")
endfunction

function! s:EditConfig()
    call <SID>ExpandFilenameAndExecute("tabedit", g:vimrc)
    call <SID>ExpandFilenameAndExecute("vsplit", g:vimrcBundles)
endfunction

" edit and save vimrc files
noremap <leader>ev :call <SID>EditConfig()<CR>
noremap <leader>sv :source ~/.vimrc<CR>
" }}} vimrc
" }}} functions

" Misc {{{
" folding
augroup vimrc
    au BufReadPre * setlocal foldmethod=indent
    au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" this may need to go somewhere like '~/.vim/bundle/[nerdTree dir]/[nerdTree
" plugin]/[my mappings].vim'
"
"let g:NERDTreeCustomQuickCommands = '1'
"
"call NERDTreeAddKeyMap({
"\ 'key': 'cqc',
"            \ 'scope': 'all',
"            \ 'callback': 'NERDTreeCustomQuickCommandsToggle',
"            \ 'quickhelpText': 'Toggle custom commands'})
"
"function! NERDTreeCustomQuickCommandsToggle()
"    let g:NERDTreeCustomQuickCommands = g:NERDTreeCustomQuickCommands ? 0 : 1
"    echomsg (g:NERDTreeCustomQuickCommands ? 'Enabled' : 'Disabled') . 'Custom Quick Commands'
"endfunction
"
"call NERDTreeAddKeyMap({
"            \ 'key': 'a',
"            \ 'scope': 'DirNode',
"            \ 'callback': 'NERDTreeCustomNewFile',
"            \ 'quickhelpText': 'create new file and edit'})
"
"function! NERDTreeCustomNewFile(dirnode)
"    let l:path=a:dirnode.path.str()
"    " todo: add logic to ask for a file name and use that to open a new buffer
"endfunction
" }}} Misc
