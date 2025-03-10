" set nocompatible
" 告诉 vim, 打开一个文件时, 尝试的编码种类
set fencs=utf-8,gbk,gb2312,ucs-bom,gb18030,cp936

filetype on                 " 侦测文件类型
set number                  " 开启行号显示
" set relativenumber number   " 设置相对行号"
" set mouse=a               " 复制代码不带行号
" set autochdir               " 自动切换到工作目录到当前文件的目录

" 配置 table 为 4 个空格
set ts=4
set cindent shiftwidth=4
set autoindent shiftwidth=4
set softtabstop=4
" Allow tabs in Makefiles.
autocmd FileType make,automake set noexpandtab shiftwidth=8 softtabstop=8
" python tabs config
autocmd FileType python set tabstop=4 |
                      \ set softtabstop=4 |
                      \ set shiftwidth=4 |
                      \ set expandtab
"set expandtab             " 将 tab 键转换为空格

" 检索高亮
set hlsearch
hi Search term=standout ctermfg=0 ctermbg=3
set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时, 仍保持对大小写敏感

" 语法高亮
syntax enable
syntax on
set re=0
" let g:solarized_termcolors=256

set showmatch               " 高亮显示匹配的括号
set cursorline              " 高亮行设置

" 右下角状态栏设置
set laststatus=2              "始终显示所有窗口的状态栏
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

"光标移动到buffer的顶部和底部时保持3行距离, 或set so=3
set scrolloff=3

" 行尾部的空格会显示红色
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
" Do not highlight spaces at the end of line while typing on that line.
autocmd InsertEnter * match WhitespaceEOL /\s\+\%#\@<!$/

set noeb                    " 去掉输入错误的提示声音
set autoread

" 默认复制到系统缓冲区中, ctrl+v 使用快速粘贴
set clipboard=unnamed
nmap <c-v> "+p

" 自定义命令
command TrimEndSpace :%s/\s\+$//g
command Tabs2Space :%s/\t/    /g
command JsonFormat :%! python3 -m json.tool

"source /Users/think3r/.vim/autoload/hexman.vim
"map <F6>  <Plug>HexManager

" 插件加载
call plug#begin('~/.vim/plugged')
    " Plug 'tweekmonster/startuptime.vim'   " vim 启动时间统计
    Plug 'preservim/nerdtree'               " 目录树
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'Vim-airline/vim-airline'          " vim-airline 标签栏插件
    Plug 'Vim-airline/vim-airline-themes'   " vim-airline 标签栏插件的主题插件
    Plug 'jiangmiao/auto-pairs'             " 括号自动匹配
    Plug 'luochen1990/rainbow'              " 彩色显示括号对
    " Syntastic 语法检查,  ale 支持 LSP 的异步语法检查
    Plug 'scrooloose/syntastic', { 'for' : ['c', 'cpp', 'go', 'java', 'objc', 'markdown', 'sh', 'make', 'json', 'xml'] }
    "Plug 'dense-analysis/ale'
    " 模糊匹配, 需要 vim 支持 python
    " Plug 'Yggdroot/LeaderF'
    Plug 'majutsushi/tagbar', { 'for' : ['c', 'cpp', 'go', 'java', 'objc'] }          " tagbar (依赖 ctags)
    Plug 'octol/vim-cpp-enhanced-highlight', { 'for' : ['c', 'cpp', 'make'] }         " C/C++ 语法高亮增强插件
call plug#end()

set t_Co=256
set background=dark
" colorscheme PaperColor " papercolor-theme
" colorscheme codedark


let g:airline_theme="dark"      " 设置主题
let g:airline_extensions = [ 'tabline']                 " 选择性加载指定的 airline 拓展
let g:airline#extensions#wordcount#enabled = 0          " 不显示文档总字数, 大文件加速
let g:airline#extensions#whitespace#enabled = 0         " 关闭状态显示空白符号计数
let g:airline_section_warning = ''                      " 取消显示warning部分
let g:airline#extensions#term#enabled = 0
let g:airline#extensions#tabline#enabled = 1            " 设置允许修改默认tab样式
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_section_y = '%{(&fenc!=""?&fenc:&enc).((exists("+bomb") && &bomb)?"+BOM":"")} [HEX=0x%02.2B]'
" let g:airline_section_b = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'

map <silent> <F3> :NERDTreeMirror<CR>
map <silent> <F3> :NERDTreeToggle<CR>

let g:syntastic_auto_loc_list = 0
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='►'
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:rainbow_active = 1
nmap <silent> <F2> :TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_left=1
let g:tagbar_autofocus = 1

" fzf 查看文件列表
nnoremap <silent> <C-o> :Files<CR>
" fzf buffer 列表
nnoremap <silent> <C-e> :Buffers<CR>
" fzf Ag 搜索
nnoremap <silent> <C-A> :Ag<CR>

