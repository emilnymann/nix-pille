_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      dependencies.ripgrep.enable = true;
      plugins = {
        snacks = {
          enable = true;
          settings = {
            dashboard = {
              enabled = true;
              preset = {
                header = ''
                  @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@!
                  @@@@ @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@@
                  @@!@!@@@  @@!  @@!  !@@  @@!  @@@  @@!  @@! @@! @@!
                  !@!!@!@!  !@!  !@!  @!!  !@!  @!@  !@!  !@! !@! !@!
                  @!@ !!@!  !!@   !@@!@!   @!@  !@!  !!@  @!! !!@ @!@
                  !@!  !!!  !!!    @!!!    !@!  !!!  !!!  !@!   ! !@!
                  !!:  !!!  !!:   !: :!!   :!:  !!:  !!:  !!:     !!:
                  :!:  !:!  :!:  :!:  !:!   ::!!:!   :!:  :!:     :!:
                  ::   ::   ::   ::  :::    ::::     ::  :::     ::
                  ::    :   :     :   ::      :      :     :      :
                '';
                keys = [
                  {
                    icon = " ";
                    key = "f";
                    desc = "Find File";
                    action = ":lua Snacks.dashboard.pick('files')";
                  }
                  {
                    icon = " ";
                    key = "n";
                    desc = "New File";
                    action = ":ene | startinsert";
                  }
                  {
                    icon = " ";
                    key = "s";
                    desc = "Find Text";
                    action = ":lua Snacks.dashboard.pick('live_grep')";
                  }
                  {
                    icon = " ";
                    key = "r";
                    desc = "Recent Files";
                    action = ":lua Snacks.dashboard.pick('oldfiles')";
                  }
                  {
                    icon = " ";
                    key = "c";
                    desc = "Config";
                    action = ":lua Snacks.dashboard.pick('files', { cwd = '/etc/nixos/modules/features/neovim-ide'})";
                  }
                  {
                    icon = " ";
                    key = "q";
                    desc = "Quit";
                    action = ":qa";
                  }
                ];
              };
              sections = [
                {section = "header";}
                {
                  section = "keys";
                  gap = 1;
                  padding = 1;
                }
                {
                  __raw = ''
                    (function()
                      local uv = vim.uv or vim.loop
                      local cache = {}

                      local function summary()
                        local root = Snacks.git.get_root()
                        if not root then
                          return nil
                        end

                        local now = uv.now()
                        local cached = cache[root]
                        if cached and (now - cached.ts) < 5000 then
                          return cached.value
                        end

                        local out = vim.fn.system({
                          "git",
                          "-C",
                          root,
                          "status",
                          "--short",
                          "--branch",
                          "--renames",
                        })

                        if vim.v.shell_error ~= 0 then
                          return nil
                        end

                        local lines = vim.split(vim.trim(out), "\n", { plain = true })
                        local header = lines[1] or ""
                        header = header:gsub("^## ", "")

                        local branch = header:gsub("%.%.%.[^ ]+", "")
                        local tracking = header:match("%[(.-)%]")
                        branch = vim.trim(branch:gsub(" %b[]", ""))

                        if branch == "" then
                          branch = "detached"
                        end

                        local changes = math.max(#lines - 1, 0)
                        local value = branch

                        if tracking and tracking ~= "" then
                          value = value .. " [" .. tracking .. "]"
                        end

                        value = value .. (changes == 0 and " • clean" or (" • " .. changes .. " change" .. (changes == 1 and "" or "s")))

                        cache[root] = {
                          ts = now,
                          value = value,
                        }

                        return value
                      end

                      return function()
                        local value = summary()
                        if not value then
                          return {}
                        end

                        return {
                          {
                            icon = " ",
                            desc = value,
                            key = "g",
                            action = function()
                              Snacks.lazygit()
                            end,
                            padding = 1,
                          },
                        }
                      end
                    end)()
                  '';
                }
              ];
            };
          };
        };

        lualine = {
          settings = {
            options = {
              disabled_filetypes = ["snacks_dashboard"];
            };
          };
        };
      };
    };
  };
}
