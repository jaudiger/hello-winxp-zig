const w = @import("win32.zig");

fn wndProc(hwnd: w.HWND, msg: w.UINT, wParam: w.WPARAM, lParam: w.LPARAM) callconv(.winapi) w.LRESULT {
    switch (msg) {
        w.WM_PAINT => {
            var ps: w.PAINTSTRUCT = .{};
            const hdc = w.BeginPaint(hwnd, &ps) orelse return 0;
            var rc: w.RECT = .{ .left = 0, .top = 0, .right = 0, .bottom = 0 };
            _ = w.GetClientRect(hwnd, &rc);
            _ = w.DrawTextA(hdc, "Hello, World!", -1, &rc, w.DT_CENTER | w.DT_VCENTER | w.DT_SINGLELINE);
            _ = w.EndPaint(hwnd, &ps);
            return 0;
        },
        w.WM_DESTROY => {
            w.PostQuitMessage(0);
            return 0;
        },
        else => return w.DefWindowProcA(hwnd, msg, wParam, lParam),
    }
}

pub export fn WinMainCRTStartup() callconv(.winapi) noreturn {
    const hInstance: w.HINSTANCE = @ptrCast(w.GetModuleHandleA(null) orelse
        w.ExitProcess(1));

    const wc: w.WNDCLASSEXA = .{
        .style = w.CS_HREDRAW | w.CS_VREDRAW,
        .lpfnWndProc = wndProc,
        .hInstance = hInstance,
        .hCursor = w.LoadCursorA(null, w.IDC_ARROW),
        .hbrBackground = w.GetStockObject(w.WHITE_BRUSH),
        .lpszClassName = "HelloZigwin",
    };

    if (w.RegisterClassExA(&wc) == 0) w.ExitProcess(1);

    const hwnd = w.CreateWindowExA(
        0,
        "HelloZigwin",
        "Windows XP - Zig",
        w.WS_OVERLAPPEDWINDOW | w.WS_VISIBLE,
        w.CW_USEDEFAULT,
        w.CW_USEDEFAULT,
        640,
        480,
        null,
        null,
        hInstance,
        null,
    ) orelse w.ExitProcess(1);

    _ = w.ShowWindow(hwnd, w.SW_SHOW);
    _ = w.UpdateWindow(hwnd);

    var msg: w.MSG = .{};
    while (w.GetMessageA(&msg, null, 0, 0) != 0) {
        _ = w.TranslateMessage(&msg);
        _ = w.DispatchMessageA(&msg);
    }

    w.ExitProcess(0);
}
