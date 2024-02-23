module simple;

/+
 + This tutorial is derived from: http://cairographics.org/cookbook/win32quickstart/
 + Translated to D2 by Andrej Mitrovic, 2011.
 +/

import core.runtime;
import std.utf;

pragma(lib, "gdi32.lib");
import windows.windef;
import windows.winuser;
import windows.wingdi;

string appName     = "CairoWindow";
string description = "A simple win32 window with Cairo drawing";
HINSTANCE hinst;

import cairo.c.cairo;
import cairo.cairo;
import cairo.win32;

alias cairo.cairo.RGB RGB;  // conflicts with win32.wingdi.RGB

extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int iCmdShow)
{
    int result;


    try
    {
        Runtime.initialize();
        result = myWinMain(hInstance, hPrevInstance, lpCmdLine, iCmdShow);
        Runtime.terminate();
    }
    catch (Throwable o)
    {
        MessageBox(null, o.toString().toUTF16z, "Error", MB_OK | MB_ICONEXCLAMATION);
        result = 0;
    }

    return result;
}

int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int iCmdShow)
{
    hinst = hInstance;
    HACCEL hAccel;
    HWND hwnd;
    MSG  msg;
    WNDCLASS wndclass;

    wndclass.style         = CS_HREDRAW | CS_VREDRAW;
    wndclass.lpfnWndProc   = &WndProc;
    wndclass.cbClsExtra    = 0;
    wndclass.cbWndExtra    = 0;
    wndclass.hInstance     = hInstance;
    wndclass.hIcon         = LoadIcon(null, IDI_APPLICATION);
    wndclass.hCursor       = LoadCursor(null, IDC_ARROW);
    wndclass.hbrBackground = cast(HBRUSH) GetStockObject(WHITE_BRUSH);
    wndclass.lpszMenuName  = appName.toUTF16z;
    wndclass.lpszClassName = appName.toUTF16z;

    if (!RegisterClass(&wndclass))
    {
        MessageBox(null, "This program requires Windows NT!", appName.toUTF16z, MB_ICONERROR);
        return 0;
    }

    hwnd = CreateWindow(appName.toUTF16z,              // window class name
                        description.toUTF16z,          // window caption
                        WS_OVERLAPPEDWINDOW,           // window style
                        400,                 // initial x position
                        400,                 // initial y position
                        400,                 // initial x size
                        400,                 // initial y size
                        null,                          // parent window handle
                        null,                          // window menu handle
                        hInstance,                     // program instance handle
                        null);                         // creation parameters

    ShowWindow(hwnd, iCmdShow);
    UpdateWindow(hwnd);

    while (GetMessage(&msg, null, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return msg.wParam;
}

void roundedRectangle(Context ctx, int x, int y, int w, int h, int radius_x = 5, int radius_y = 5)
{
    enum ARC_TO_BEZIER = 0.55228475;

    if (radius_x > w - radius_x)
        radius_x = w / 2;

    if (radius_y > h - radius_y)
        radius_y = h / 2;

    // approximate (quite close) the arc using a bezier curve
    auto c1 = ARC_TO_BEZIER * radius_x;
    auto c2 = ARC_TO_BEZIER * radius_y;

    ctx.newPath();
    ctx.moveTo(x + radius_x, y);
    ctx.relLineTo(w - 2 * radius_x, 0.0);
    ctx.relCurveTo(c1, 0.0, radius_x, c2, radius_x, radius_y);
    ctx.relLineTo(0, h - 2 * radius_y);
    ctx.relCurveTo(0.0, c2, c1 - radius_x, radius_y, -radius_x, radius_y);
    ctx.relLineTo(-w + 2 * radius_x, 0);
    ctx.relCurveTo(-c1, 0, -radius_x, -c2, -radius_x, -radius_y);
    ctx.relLineTo(0, -h + 2 * radius_y);
    ctx.relCurveTo(0.0, -c2, radius_x - c1, -radius_y, radius_x, -radius_y);
    ctx.closePath();
}

extern (Windows)
LRESULT WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)
    {
        case WM_CREATE:
        {
            window = new Window(hwnd);
            return 0;
        }

        default:
    }

    if (window)
        return window.process(hwnd, message, wParam, lParam);
    else
        return DefWindowProc(hwnd, message, wParam, lParam);
}

Window window;

class Window
{
    int  x, y;
    HWND hwnd;
    HDC hdc;
    PAINTSTRUCT ps;
    RECT rc;
    HDC _buffer;
    HBITMAP hBitmap;
    HBITMAP hOldBitmap;

    this(HWND hwnd)
    {
        this.hwnd = hwnd;
    }

    LRESULT process(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
    {
        switch (message)
        {
            case WM_DESTROY:
                return OnDestroy(hwnd, message, wParam, lParam);

            case WM_PAINT:
                return OnPaint(hwnd, message, wParam, lParam);

            case WM_ERASEBKGND:
                return 0;

            default:
        }

        return DefWindowProc(hwnd, message, wParam, lParam);
    }

    auto OnPaint(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
    {
        hdc = BeginPaint(hwnd, &ps);
        GetClientRect(hwnd, &rc);

        auto left = rc.left;
        auto top = rc.top;
        auto right = rc.right;
        auto bottom = rc.bottom;

        auto width  = right - left;
        auto height = bottom - top;
        x = left;
        y = top;

        _buffer    = CreateCompatibleDC(hdc);
        hBitmap    = CreateCompatibleBitmap(hdc, width, height);
        hOldBitmap = SelectObject(_buffer, hBitmap);

        auto surf = new Win32Surface(_buffer);
        auto ctx = Context(surf);

        ctx.setSourceRGB(1, 1, 1);
        ctx.paint();

        roundedRectangle(ctx, 50, 50, 250, 250, 10, 10);

        auto clr = RGB(0.9411764705882353, 0.996078431372549, 0.9137254901960784);
        ctx.setSourceRGB(clr);
        ctx.fillPreserve();

        clr = RGB(0.7019607843137254, 1.0, 0.5529411764705883);
        ctx.setSourceRGB(clr);
        ctx.stroke();

        ctx.setSourceRGB(0, 0, 0);
        ctx.selectFontFace("Arial", FontSlant.CAIRO_FONT_SLANT_NORMAL, FontWeight.CAIRO_FONT_WEIGHT_NORMAL);
        ctx.setFontSize(10.0);
        auto txt = "Cairo is the greatest thing!";
        ctx.moveTo(5.0, 10.0);
        ctx.showText(txt);

        surf.finish();
        BitBlt(hdc, 0, 0, width, height, _buffer, x, y, SRCCOPY);

        SelectObject(_buffer, hOldBitmap);
        DeleteObject(hBitmap);
        DeleteDC(_buffer);

        EndPaint(hwnd, &ps);
        return 0;
    }

    auto OnDestroy(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
    {
        PostQuitMessage(0);
        return 0;
    }
}
