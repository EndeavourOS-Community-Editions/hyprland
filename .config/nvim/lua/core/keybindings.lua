vim.g.mapleader = " "

map("n", "<leader>zm", ":ZenMode<CR>")
map("n", "<leader>nt", ":Neotree reveal left<CR>")
map("n", "<leader>ntf", ":Neotree reveal float<CR>")
map("n", "<leader>a", ":AerialToggle<CR>")
map("n", "m", ":noh<CR>")
map("n", "/", ":set hlsearch<CR>/")
map("n", "i", ":set nohlsearch<CR>i")
map("n", "a", ":set nohlsearch<CR>a")
map("n", "I", ":set nohlsearch<CR>I")
map("n", "A", ":set nohlsearch<CR>A")
map("i", "<C-d>", "<left><c-o>/[\"';)>}\\]]<cr><c-o>:noh<cr><right>")
map("n", "ff", ":Telescope git_files hidden=true<CR>")
map("n", "fg", ":Telescope live_grep<CR>")
map("n", "fb", ":Telescope buffers<CR>")
map("n", "fh", ":Telescope help_tags<CR>")
map("i", "<C-b>", "<C-o>0")
map("i", "<C-a>", "<C-o>A")
map("v", "<C-b>", "^")
map("v", "<C-a>", "$")
map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")


