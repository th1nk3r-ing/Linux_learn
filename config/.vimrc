" 告诉 vim，打开一个文件时，尝试 utf8,gbk 两种编码
set fencs=utf-8,gbk

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

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a

" 高亮行设置
set cursorline
