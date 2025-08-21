-- Mason-conform: auto-install formatters defined in conform config (except ignored)
require("mason-conform").setup({
    ignore_install = {}, -- Add formatter names you want to skip
})
