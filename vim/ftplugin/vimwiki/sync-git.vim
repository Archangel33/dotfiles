
let g:vimwikiroot= get(g:, 'vimwikiroot', "~/.vim/vimwiki")
let g:vimwikiroot= substitute(g:vimwikiroot,'/$','','')

augroup vimwiki-syncgit
    au!
    execute "au BufRead " . expand(g:vimwikiroot) . "/index.wiki !git pull "
    execute "au BufWritePost " . expand(g:vimwikiroot) . "/* !git add expand(\"<afile>\"); git commit -m \"auto commit & push.\"; git push "
augroup END
