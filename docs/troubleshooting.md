# Troubleshooting and implementation notes

This project targets an old Win32 CMS/XMEye desktop client. The stable solution is intentionally simple because several apparently cleaner automation methods were less reliable in practice.

## 1. Why not `ControlClick`?

Early versions tried to address the camera panes directly with `ControlClick` and child controls such as:

- `AfxWnd423`
- `AfxWnd425`
- `AfxWnd427`
- `AfxWnd429`

The controls could be found, but right-clicking them synthetically was not reliable enough to trigger the complete Snapshot workflow.

The current version therefore moves the real mouse cursor to the pane and performs a real right click.

## 2. Context menu class

The CMS popup menu is exposed as the standard Windows popup-menu class:

```text
#32768
```

The script waits for that menu before sending the Snapshot shortcut.

## 3. Why `SendEvent`?

Several input approaches were tested. The reliable sequence was:

```text
right click -> wait for #32768 -> SendEvent S -> SendEvent Enter
```

`SendInput`, low-level key simulation and direct menu manipulation were less reliable with the tested CMS build.

## 4. Why no fixed sleep after every capture?

A fixed sleep makes rapid captures unnecessarily slow. The current script instead uses:

```ahk
WinWaitClose, ahk_class #32768, , 0.10
```

If the menu disappears immediately, the script continues immediately. The short timeout only prevents a new capture from being chained while the previous popup menu is still present.

## 5. Microsoft Photos steals focus

Some Windows configurations open Microsoft Photos after every snapshot. That can introduce visible lag and steal focus from CMS.

`CerrarFotos.ahk` checks for `Microsoft.Photos.exe` every 50 ms and closes it when present.

This helper is intentionally separate from the main snapshot script so that the known-good capture logic remains isolated.

## 6. Administrator rights

If `CMS.exe` is running elevated, AutoHotkey may be unable to control it unless the `.ahk` scripts are also started as administrator.

## 7. Two-monitor setup

The current version has been tested with:

- CMS maximized on a secondary monitor.
- Microsoft Photos appearing on the primary monitor.
- All four Numpad hotkeys working.

Because the script uses:

```ahk
CoordMode, Mouse, Client
```

coordinates are relative to the CMS client area rather than to the desktop origin. Moving CMS to another monitor does not by itself invalidate the coordinates, provided the CMS client geometry and camera layout remain equivalent.

## 8. Fixed coordinates

The stable build currently uses:

```text
Camera 1: 455, 234
Camera 2: 1009, 234
Camera 3: 455, 632
Camera 4: 1009, 632
```

These values belong to the tested 2x2 layout. Different resolutions, DPI scaling, window dimensions or pane layouts may require recalibration.

## 9. Occasional context-menu glitch

During very fast capture sequences, the legacy CMS can occasionally leave the context menu visible or fail to complete one capture cleanly.

In the tested setup, pressing the same hotkey again normally recovers the workflow. Because the current version is otherwise highly reliable, no aggressive menu-closing logic is included by default.

## 10. Clean CMS shutdown

`Cerrar_CMS_Limpio.ahk` runs:

```cmd
taskkill /IM CMS.exe
```

It deliberately omits `/F`, allowing the application to perform its normal close/confirmation path.

## 11. Explorer restart warning

Restarting `Explorer.exe` while this old CMS application is minimized has produced cases where the CMS window/taskbar entry became difficult or impossible to recover cleanly.

Avoid restarting Explorer while CMS is running unless you are prepared to restart CMS as well.

## 12. Possible future improvement

A more portable version could obtain each pane position dynamically with `ControlGetPos`, calculate its center, and then keep the exact same reliable interaction mechanism:

```text
ControlGetPos -> calculate center -> real mouse move -> real right click
-> wait #32768 -> SendEvent S -> SendEvent Enter -> conditional WinWaitClose
```

This would remove most dependence on fixed coordinates without reintroducing `ControlClick`.

## Development rule

When changing the stable capture script, modify one variable at a time and preserve the previous known-good version. With old GUI software, several individually reasonable changes can interact in unexpected ways.
