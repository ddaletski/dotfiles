-- TODO: 
--  - installers filter (remove unavailable)
--  - installers priority (npm should definetly go after pacman)

local installers = {
    --apt = {
    --  probe = "",
    --  install = ""
    --},
    --brew = {
      --probe = "",
      --install = ""
    --},
    pacman = {
        exists = "pacman -Q {package}",
        probe = "pacman -Si {package}",
        install = "sudo pacman -S --noconfirm {package}"
    },
    pip = {
        exists = "pip show {package}",
        probe = "pip index versions {package}",
        install = "pip install {package}"
    },
    npm = {
        exists = "npm list --location=global {package}",
        probe = "npm show {package}",
        install = "npm install --location=global {package}"
    }
}

-- check if package is already installed
--
-- args:
-- 1. package: string - package name
local function check_installed(package)
    for _, opts in pairs(installers) do
        local exists_cmd = opts.exists:gsub("{package}", package)

        if os.execute(exists_cmd .. " &> /dev/null") == 0 then
            return true
        end
    end

    return false
end

-- check if a package can be installed
--
-- args:
--  1. package: string - package name
--
-- returns (ok, installer, command):
--  1. ok: bool - a package can be installed
--  2. installer: string? - an installer that can be used
--  3. command: string? - a command to install the package with the installer
local function can_be_installed(package)
    for installer, opts in pairs(installers) do
        local probe_cmd = opts.probe:gsub("{package}", package)
        local install_cmd = opts.install:gsub("{package}", package)

        if os.execute(probe_cmd .. " &> /dev/null") == 0 then
            return true, installer, install_cmd
        end
    end

    return false, nil, nil
end

-- install a given package
--
-- args:
-- 1. package: string - package name
-- 2. opts: table of
--     - executable: string - executable name for the package to fast-check installation
function InstallSystemPackage(package, opts)
    if opts.executable ~= nil then
        local command = opts.executable
        assert(type(command) == "string")

        if os.execute(command .. " &> /dev/null") == 0 then
            return
        end
    end

    if check_installed(package) then
        return
    end

    local ok, installer, command = can_be_installed(package)

    if not ok then
        print(string.format("'%s' can't be installed because it wasn't found in any of available package managers",
            package))
        return
    end

    local prompt = string.format("package '%s' found in '%s'. Install? (y/N): ", package, installer)
    local install = false

    -- ask for confirmation
    vim.ui.input(
        {
            prompt = prompt,
        },
        function(input)
            install = string.lower(input or "") == "y"
        end
    )

    if install then
        -- editable command
        vim.ui.input(
            {
                prompt = "execute: ",
                default = command
            },
            function(input)
                os.execute(input)
            end
        )
    end
end
