if exists("b:current_syntax")
    finish
endif

" syntax definitions
syntax region logTime start=+^\d\{2}\.\d\{2}\.\d\{4} \d\{2}:\d\{2}:\d{3}+ end=+ +me=e-1
" basic log keywords
syntax keyword logError "\vERROR"
syntax keyword logWarn "\vWARN"
syntax keyword logInfo "\vINFO"
syntax keyword logDebug "\vDEBUG"
syntax keyword logException "\v[Ee]xception:?"

"syntax match logStackTraceFileName \"\v([\w,\s-]+\.)+[\w,\s-]+"
syntax match logStackTraceFileLoc "\v[(].*\..*:\d+[)]" contained "contains=logStackTraceFileName

syntax region logStackTrace start=+\v^.*[Ee]xception:?+ end=+\v^[^\t]+me=e-1

" set highlights {{{
" log dateTime
highlight default link logTime Comment

" log level
highlight default link logError ErrorMsg
highlight default link logWarn WarningMsg
highlight default link logInfo Normal
highlight default link logDebug Normal

" log trace
highlight default link logStackTrace ERROR
highlight default link logStackTraceFileLoc TODO
"}}}

let b:current_syntax = "log"
