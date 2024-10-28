# wipdots
Periodic wip snapshots for temp usage

# Usage Tips

<Leader> is <space> and opens vim-whichkey

Open file for editing
* fzf... :Files (non dot files in directory) or :GFiles (git files)
* <Leader>o for file explorer

Search
* / to search text in curr buffer (n or N for next or prev)
* :BLines or <Leader>fb to fzf lines in the curr buffer (dbl click to go there) 

Buffers
* Switch buffer... <Leader><Leader> or <Leader>bb
*                  or <Leader>b for non fzf buffer selections
* Delete buffer... :bd

Windows
* Switch windows... <Leader>ARROW or Ctrl-ARROW
* Close, Split, etc... <Leader>w
* Maximizer Toggle... <Leader>m

Commenting
* <Leader>/ will comment or uncomment line or visual lines
* <Leader>// will comment line or visual lines even if already commented

Vim
* Sessions... <Leader>vss and <Leader>vsr to save or restore vim sessions
* $MYVIMRC... <Leader>vce and <Leader>vcr for config edit or reload
* Keymaps... <Leader>fml literal or <Leader>fmf fuzzy

Python LSP - CoC stuff
* <Leader>l prefix
* <Leader>r is shortcut for rename symbol
* <Leader>lo or <Leader>ll for lsp symbol outline with fzf (up arrow or start typing)
* <Leader>ld jump to defn
* <Leader>li incoming calls to highlighted fn 
* <Leader>lI outgoing calls from highlighted fn 
* <Leader>lf format
* <Leader>ly organize imports

