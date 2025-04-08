nnoremap <leader>vw :vnew \| setlocal buftype=nofile \| read !find . -type f -name "*.swp" -o -name "*.swo" -o -name "*.swn" -o -name "*.swm" -o -name "*.swl" -o -name "*.swh" -o -name "*.un~"<CR>
