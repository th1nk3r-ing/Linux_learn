" 告诉 vim，打开一个文件时，尝试的编码种类
set fencs=utf-8,gbk,gb2312,ucs-bom,gb18030,cp936

" 配置 table 为 4 个空格
set ts=4
set cindent shiftwidth=4
set autoindent shiftwidth=4

" 开启行号显示
set number

" 检索高亮
set hlsearch
hi Search term=standout ctermfg=0 ctermbg=3

" 语法高亮
syntax enable
syntax on

" 高亮显示匹配的括号
set showmatch

" 侦测文件类型 
filetype on

" 高亮行设置
set cursorline

" 右下角状态栏设置
set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" 关闭打开时的错误: Error detected while processing BufNewFile Autocommands for "*.groovy"..FileType Autocommands for "*"..Syntax Autocommands for "*"..function <SNR>6_SynSet[25]..script /opt/local/share/vim/vim82/syntax/groovy.vim: Line256
set re=0

" Vim复制代码不带行号
" se mouse=a
