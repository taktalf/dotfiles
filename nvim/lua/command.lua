vim.api.nvim_create_user_command(
  'T',
  function(opts)
    vim.cmd('split')
    vim.cmd('terminal ' .. opts.args)
  end,
  { nargs = '*' }
)

vim.api.nvim_create_user_command(
  'VT',
  function(opts)
    vim.cmd('vsplit')
    vim.cmd('terminal ' .. opts.args)
  end,
  { nargs = '*' }
)

-- Check if the 'jq' executable is available
if vim.fn.executable('jq') == 1 then
  -- Define a function that uses 'jq' with optional arguments
  local function jq(args)
    args = args or '.'
    vim.cmd('%!jq ' .. args)
  end

  -- Create a Vim command 'Jq' that calls the 'jq' function
  vim.api.nvim_create_user_command('Jq', function(opts)
    jq(opts.args)
  end, { nargs = '?' })  -- nargs = '?' means the command accepts zero or one argument
end
