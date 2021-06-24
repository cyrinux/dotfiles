local function setup()
    -- default mode
    key = xplr.config.modes.builtin.default.key_bindings.on_key

    key.a = key["ctrl-a"]
    key["ctrl-f"] = nil
    key.e = xplr.config.modes.builtin.action.key_bindings.on_key.e
    key.o = xplr.config.modes.builtin.go_to.key_bindings.on_key.x

    key["ctrl-a"] = nil
    key["ctrl-w"] = nil
    key["ctrl-r"] = nil
    key["ctrl-i"] = nil
    key["ctrl-o"] = nil
    key.v = nil
    key.V = nil

    key["!"] = {
        help = "shell",
        messages = {
            { Call = { command = "zsh", args = { "-i" } } },
            "ExplorePwdAsync",
            "PopMode",
        },
    }

    key.D = {
        help = "disk usage",
        messages = {
            { Call = { command = "ncdu" } },
            "ClearScreen",
        },
    }

    key.n = {
        help = "go to Downloads",
        messages = { { ChangeDirectory = "/home/cyril/Downloads/" } },
    }

    key.Q = {
        help = "quit cd",
        messages = { "PrintPwdAndQuit" },
    }

    -- action mode
    key = xplr.config.modes.builtin.action.key_bindings.on_key

    key.e = nil

    key.o = {
        help = "visit path",
        messages = {
            "PopMode",
            { SwitchModeCustom = "visit_path" },
            { SetInputBuffer = "" },
        },
    }

    -- delete mode
    key = xplr.config.modes.builtin.delete.key_bindings.on_key

    key.d = {
        help = "delete",
        messages = {
            {
                BashExecSilently = [===[
                    while IFS= read -r line; do rmtrash -rf -- "${line:?}"; done < "${XPLR_PIPE_RESULT_OUT:?}"
                    echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
                ]===],
            },
            "PopMode",
        },
    }

    key.D = {
        help = "force delete",
        messages = {
            {
                BashExecSilently = [===[
                    while IFS= read -r line; do rm -rf -- "${line:?}"; done < "${XPLR_PIPE_RESULT_OUT:?}"
                    echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
                ]===],
            },
            "PopMode",
        },
    }

    -- go to
    key = xplr.config.modes.builtin.go_to.key_bindings.on_key

    key.k = key.g
    key.j = xplr.config.modes.builtin.default.key_bindings.on_key.G
    key.x = nil

    -- search mode
    key = xplr.config.modes.builtin.search.key_bindings.on_key

    key["ctrl-p"] = key["tab"]
    key["tab"] = key.right
    key["ctrl-j"] = key.down
    key["ctrl-k"] = key.up
    key["ctrl-n"] = nil
end

return { setup = setup }
