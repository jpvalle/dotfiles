return {
  "pearofducks/ansible-vim",
  ft = { "ansible", "yaml.ansible" },
  init = function()
    -- Map template paths to the syntax of the rendered file (jinja2 is appended automatically).
    vim.g.ansible_template_syntaxes = {
      [".*\\.container\\.j2"] = "ini",
      [".*\\.cfg\\.j2"] = "ini",
      [".*\\.yml\\.j2"] = "yaml",
      [".*\\.yaml\\.j2"] = "yaml",
      [".*postgresql.*\\.conf\\.j2"] = "conf",
      [".*\\.conf\\.j2"] = "conf",
      [".*ssh_config\\.j2"] = "sshconfig",
      [".*\\.cron\\.j2"] = "cron",
    }
  end,
  config = function()
    require("ansible").setup()
  end,
}
