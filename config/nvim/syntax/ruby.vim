" -- Kalkomey specific
let s:path = tr(expand('%:p'), '\', '/')
echo tr(expand('%:p'), '\', '/')

if s:path =~# 'ams/app/controllers/.*\.rb$'
  syn keyword rubyFunction selected_links
  syn keyword rubyFunction contract_resource
endif

