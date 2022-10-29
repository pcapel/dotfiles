-- TODO: figure out how to run this
local async = require('plenary.async')

-- What does this do?
async.tests.add_to_env()

local tutil = require('yode-nvim.tests.util')
local R = require('yode-nvim.deps.lamda.dist.lamda')
local h = require('yode-nvim.helper')
local layout = storeBundle.layout

local eq = assert.are.same

describe('basic mosaic layout', function()
    local fileBufferId = 1
    local seditor1 = 2
    local seditor1StatusBufferId = 3
    local seditor2 = 4
    local seditor2StatusBufferId = 5
    local seditor3 = 6
    local seditor3StatusBufferId = 7
    local seditor1Win = 1002
    local seditor1WinStatus = 1003
    local seditor2Win = 1004
    local seditor2WinStatus = 1005
    local seditor3Win = 1006
    local seditor3WinStatus = 1007

    it('create floating seditors', function()
        eq({ seditors = {}, layout = { tabs = {} } }, store.getState())

        vim.cmd('e ./testData/basic.js')

        -- seditor 1
        vim.cmd('3,9YodeCreateSeditorFloating')

        tutil.assertBufferContentString([[
const getSeditorWidth = async (nvim) => {
    if (!mainWindowWidth) {
        mainWindowWidth = Math.floor((await nvim.getOption('columns')) / 2)
    }
    return mainWindowWidth
}]])

        eq({
            [fileBufferId] = './testData/basic.js',
            [seditor1] = 'yode://./testData/basic.js:2.js',
        }, tutil.getHumanBufferList())
        eq({
            id = 1,
            config = {},
            data = {},
            name = 'mosaic',
            isDirty = false,
        }, R.omit({ 'windows' }, store.getState().layout.tabs[1]))
        eq(
            {
                {
                    y = 1,
                    height = 7,
                    id = seditor1Win,
                    bufId = seditor1,
                    relative = 'editor',
                    data = { visible = true },
                    statusBufferId = seditor1StatusBufferId,
                    statusId = seditor1WinStatus,
                },
            },
            h.map(
                R.pick({
                    'id',
                    'data',
                    'height',
                    'relative',
                    'y',
                    'bufId',
                    'statusId',
                    'statusBufferId',
                }),
                store.getState().layout.tabs[1].windows
            )
        )

        vim.cmd('wincmd h')
        eq(fileBufferId, vim.fn.bufnr('%'))

        -- seditor 2
        vim.cmd('11,25YodeCreateSeditorFloating')

        tutil.assertBufferContentString([[
async function createSeditor(nvim, text, row, height) {
    const buffer = await nvim.createBuffer(false, false)
    const foo = 'bar'
    const width = await getSeditorWidth(nvim)
    const window = await nvim.openWindow(buffer, true, {
        relative: 'editor',
        row,
        col: width,
        width,
        height: height,
        focusable: true,
    })
    return window
}]])

        eq({
            [fileBufferId] = './testData/basic.js',
            [seditor1] = 'yode://./testData/basic.js:2.js',
            [seditor2] = 'yode://./testData/basic.js:4.js',
        }, tutil.getHumanBufferList())
        eq(
            {
                {
                    y = 1,
                    height = 15,
                    id = seditor2Win,
                    bufId = seditor2,
                    relative = 'editor',
                    data = { visible = true },
                    statusBufferId = seditor2StatusBufferId,
                    statusId = seditor2WinStatus,
                },
                {
                    y = 17,
                    height = 7,
                    id = seditor1Win,
                    bufId = seditor1,
                    relative = 'editor',
                    data = { visible = true },
                    statusBufferId = seditor1StatusBufferId,
                    statusId = seditor1WinStatus,
                },
            },
            h.map(
                R.pick({
                    'id',
                    'data',
                    'height',
                    'relative',
                    'y',
                    'bufId',
                    'statusId',
                    'statusBufferId',
                }),
                store.getState().layout.tabs[1].windows
            )
        )

        vim.cmd('wincmd h')
        eq(fileBufferId, vim.fn.bufnr('%'))

        -- seditor 3
        vim.cmd('49,58YodeCreateSeditorFloating')

        tutil.assertBufferContentString([[
plugin.registerCommand(
    'YodeCreateSeditor',
    async () => {
        await createSeditor(nvim, '1111', 0, 20 == 50)
        await createSeditor(nvim, '2222', 21, 10)
        await createSeditor(nvim, '3333', 32, 15)
    },
    { sync: false }
)]])

        eq({
            [fileBufferId] = './testData/basic.js',
            [seditor1] = 'yode://./testData/basic.js:2.js',
            [seditor2] = 'yode://./testData/basic.js:4.js',
            [seditor3] = 'yode://./testData/basic.js:6.js',
        }, tutil.getHumanBufferList())
        eq(
            {
                {
                    y = 1,
                    height = 10,
                    id = seditor3Win,
                    bufId = seditor3,
                    relative = 'editor',
                    data = { visible = true },
                    statusBufferId = seditor3StatusBufferId,
                    statusId = seditor3WinStatus,
                },
                {
                    y = 12,
                    height = 15,
                    id = seditor2Win,
                    bufId = seditor2,
                    relative = 'editor',
                    data = { visible = true },
                    statusBufferId = seditor2StatusBufferId,
                    statusId = seditor2WinStatus,
                },
                {
                    y = 28,
                    height = 7,
                    id = seditor1Win,
                    bufId = seditor1,
                    relative = 'editor',
                    data = { visible = true },
                    statusBufferId = seditor1StatusBufferId,
                    statusId = seditor1WinStatus,
                },
            },
            h.map(
                R.pick({
                    'id',
                    'data',
                    'height',
                    'relative',
                    'y',
                    'bufId',
                    'statusId',
                    'statusBufferId',
                }),
                store.getState().layout.tabs[1].windows
            )
        )
    end)

    it('selecting window by some id works', function()
        eq(
            {
                id = seditor1Win,
                bufId = seditor1,
            },
            R.pick(
                { 'id', 'bufId' },
                layout.selectors.getWindowBySomeId(vim.api.nvim_get_current_tabpage(), {
                    bufId = seditor1,
                })
            )
        )

        eq(
            {
                id = seditor1Win,
                bufId = seditor1,
            },
            R.pick(
                { 'id', 'bufId' },
                layout.selectors.getWindowBySomeId(vim.api.nvim_get_current_tabpage(), {
                    winId = seditor1Win,
                })
            )
        )

        eq(true, nil == layout.selectors.getWindowBySomeId(9, { winId = seditor1Win }))
    end)

    it("can't switch buffer to non seditor buffer in floating window", function()
        eq(seditor3Win, vim.fn.win_getid())
        eq(seditor3, vim.fn.bufnr('%'))

        vim.cmd('b ' .. fileBufferId)
        eq(seditor3Win, vim.fn.win_getid())
        eq(seditor3, vim.fn.bufnr('%'))
    end)

    it('shifting windows', function()
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinDown')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 17,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinDown')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 17,
                height = 7,
                id = seditor1Win,
            },
            {
                y = 25,
                height = 10,
                id = seditor3Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinTop')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinBottom')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 17,
                height = 7,
                id = seditor1Win,
            },
            {
                y = 25,
                height = 10,
                id = seditor3Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinUp')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 17,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinUp')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinUp')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 17,
                height = 7,
                id = seditor1Win,
            },
            {
                y = 25,
                height = 10,
                id = seditor3Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('YodeLayoutShiftWinDown')
        eq(seditor3Win, vim.fn.win_getid())
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))
    end)

    it('should use tab handles, not tab numbers', function()
        vim.cmd('tabnew')
        vim.cmd('tabclose')
        vim.cmd('tabnew')
        vim.cmd('b ' .. seditor1)
        vim.cmd('YodeCloneCurrentIntoFloat')

        eq({
            [fileBufferId] = './testData/basic.js',
            [seditor1] = 'yode://./testData/basic.js:2.js',
            [seditor2] = 'yode://./testData/basic.js:4.js',
            [seditor3] = 'yode://./testData/basic.js:6.js',
        }, tutil.getHumanBufferList())
        -- with tab numbers it would be {1, 2}
        eq({ 1, 3 }, R.keys(store.getState().layout.tabs))
    end)

    it('tab close is handled', function()
        vim.cmd('tabclose')
        eq({ 1 }, R.keys(store.getState().layout.tabs))
    end)

    a.it('changing content height, changes layout', function()
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('wincmd w')
        eq(seditor2Win, vim.fn.win_getid())
        vim.cmd('normal ggyypp')
        async.util.scheduler()

        tutil.assertBufferContentString([[
async function createSeditor(nvim, text, row, height) {
async function createSeditor(nvim, text, row, height) {
async function createSeditor(nvim, text, row, height) {
    const buffer = await nvim.createBuffer(false, false)
    const foo = 'bar'
    const width = await getSeditorWidth(nvim)
    const window = await nvim.openWindow(buffer, true, {
        relative: 'editor',
        row,
        col: width,
        width,
        height: height,
        focusable: true,
    })
    return window
}]])
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 17,
                id = seditor2Win,
            },
            {
                y = 30,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))

        vim.cmd('undo')
        async.util.scheduler()
        tutil.assertBufferContentString([[
async function createSeditor(nvim, text, row, height) {
    const buffer = await nvim.createBuffer(false, false)
    const foo = 'bar'
    const width = await getSeditorWidth(nvim)
    const window = await nvim.openWindow(buffer, true, {
        relative: 'editor',
        row,
        col: width,
        width,
        height: height,
        focusable: true,
    })
    return window
}]])
        eq({
            {
                y = 1,
                height = 10,
                id = seditor3Win,
            },
            {
                y = 12,
                height = 15,
                id = seditor2Win,
            },
            {
                y = 28,
                height = 7,
                id = seditor1Win,
            },
        }, h.map(R.pick({ 'y', 'height', 'id' }), store.getState().layout.tabs[1].windows))
    end)

    pending('resizing vim changes width of main and statusbar windows')

    a.it('delete floating buffer', function()
        local wins = {
            seditor1Win,
            seditor1WinStatus,
            seditor2Win,
            seditor2WinStatus,
            seditor3Win,
            seditor3WinStatus,
        }
        vim.cmd('tab split')
        vim.cmd('b ' .. seditor2)
        vim.cmd('YodeCloneCurrentIntoFloat')
        vim.cmd('b ' .. seditor1)
        vim.cmd('YodeCloneCurrentIntoFloat')
        vim.cmd('b ' .. fileBufferId)
        vim.cmd('wincmd w')
        eq({
            [fileBufferId] = './testData/basic.js',
            [seditor1] = 'yode://./testData/basic.js:2.js',
            [seditor2] = 'yode://./testData/basic.js:4.js',
            [seditor3] = 'yode://./testData/basic.js:6.js',
        }, tutil.getHumanBufferList())
        eq(seditor1, vim.fn.bufnr('%'))
        eq({ 1, 4 }, R.keys(store.getState().layout.tabs))
        eq({ [1] = false, [4] = false }, R.pluck('isDirty', store.getState().layout.tabs))
        eq(
            { seditor3, seditor2, seditor1 },
            R.pluck('bufId', store.getState().layout.tabs[1].windows)
        )
        eq({ seditor1, seditor2 }, R.pluck('bufId', store.getState().layout.tabs[4].windows))
        eq({ true, true, true, true, true, true }, h.map(R.unary(vim.api.nvim_win_is_valid), wins))

        vim.cmd('bd')
        async.util.scheduler()
        eq(fileBufferId, vim.fn.bufnr('%'))
        eq({ 1, 4 }, R.keys(store.getState().layout.tabs))
        eq({ [1] = true, [4] = false }, R.pluck('isDirty', store.getState().layout.tabs))
        eq({ seditor3, seditor2 }, R.pluck('bufId', store.getState().layout.tabs[1].windows))
        eq({ seditor2 }, R.pluck('bufId', store.getState().layout.tabs[4].windows))
        eq(
            { false, false, true, true, true, true },
            h.map(R.unary(vim.api.nvim_win_is_valid), wins)
        )

        vim.cmd('tabnext')
        eq({ [1] = false, [4] = false }, R.pluck('isDirty', store.getState().layout.tabs))
        vim.cmd('tabnext')

        vim.cmd('wincmd w')
        eq(seditor2, vim.fn.bufnr('%'))

        vim.cmd('bd')
        async.util.scheduler()
        eq(fileBufferId, vim.fn.bufnr('%'))
        eq({ 1, 4 }, R.keys(store.getState().layout.tabs))
        eq({ seditor3 }, R.pluck('bufId', store.getState().layout.tabs[1].windows))
        eq({}, R.pluck('bufId', store.getState().layout.tabs[4].windows))
        eq(
            { false, false, false, false, true, true },
            h.map(R.unary(vim.api.nvim_win_is_valid), wins)
        )

        -- TODO change window layout before deleting last buffer, when we have
        -- more of them. Should keep tab state. Assert layout name is still
        -- 'the other layout'. When user floats the next window, his selected
        -- layout should be still active!
        eq('mosaic', store.getState().layout.tabs[4].name)
    end)
end)
