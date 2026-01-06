local M = {}

M.is_local = function()
  local ssh_client = os.getenv "SSH_CLIENT"
  local ssh_connection = os.getenv "SSH_CONNECTION"
  local ssh_tty = os.getenv "SSH_TTY"

  return ssh_client == nil and ssh_connection == nil and ssh_tty == nil
end

return M
