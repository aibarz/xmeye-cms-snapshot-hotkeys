# XMEye CMS Snapshot Hotkeys

Small AutoHotkey v1 utilities for legacy XMEye/CMS clients on Windows.

They provide fast snapshot hotkeys for a 2x2 camera layout, automatically close Microsoft Photos after a capture, and can request a clean CMS shutdown.

> Unofficial community utility. Not affiliated with XMEye or the CMS software vendor.

## Tested setup

- Windows 10
- CMS/XMEye 3.1.0.9
- AutoHotkey v1
- 4-camera 2x2 layout
- CMS maximized on a secondary monitor
- Microsoft Photos opening on the primary monitor
- Numpad snapshot hotkeys for all four camera panes

The current build is stable enough for practical use, although the old CMS context menu can still occasionally leave a small visual glitch. Pressing the same hotkey again normally recovers it.

## Files

- `CMS_Control.ahk` — main snapshot hotkeys.
- `CerrarFotos.ahk` — closes `Microsoft.Photos.exe` every 50 ms to reduce focus stealing and lag after snapshots.
- `Cerrar_CMS_Limpio.ahk` — asks Windows to close `CMS.exe` normally, without `/F`.
- `docs/troubleshooting.md` — implementation notes, known limitations and approaches that proved unreliable.

## Snapshot hotkeys

| Camera pane | Numpad key | Tested client coordinates |
|---|---:|---:|
| 1 | 1 | `455, 234` |
| 2 | 2 | `1009, 234` |
| 3 | 3 | `455, 632` |
| 4 | 4 | `1009, 632` |

The script uses `CoordMode, Mouse, Client`, so these are **CMS client-area coordinates**, not absolute screen coordinates. They may need adjustment for different window sizes, layouts, resolutions or DPI scaling.

## How it works

The legacy CMS did not behave reliably with synthetic `ControlClick` operations. The stable approach therefore uses a real mouse movement and a real right click:

1. Move the mouse to the center of the selected pane.
2. Right-click.
3. Wait for the standard Windows popup menu (`#32768`).
4. Send `S` and `Enter` with `SendEvent` to activate **Snapshot**.
5. Wait conditionally for the menu to close before accepting another capture.

This avoids fixed sleeps in the normal path and keeps captures reasonably fast.

## Installation

1. Install **AutoHotkey v1**.
2. Download the three `.ahk` files.
3. Run `CMS_Control.ahk`.
4. Run `CerrarFotos.ahk` if Microsoft Photos opens after every snapshot.
5. Keep CMS in the expected 2x2 layout.

If CMS is running as administrator, run the AutoHotkey scripts as administrator too.

## Known limitations

- The current version uses fixed client coordinates for the tested 2x2 layout.
- Different CMS layouts or DPI scaling may require coordinate changes.
- The context menu may occasionally remain visible during very rapid capture sequences.
- Microsoft Photos behavior can vary between Windows builds.
- The scripts target the legacy desktop CMS application whose process is `CMS.exe`.

A future improvement would calculate pane centers dynamically from the CMS child controls while preserving the same real-mouse snapshot mechanism.

## License

MIT License. See [`LICENSE`](LICENSE).

---

# Español

Pequeñas utilidades para AutoHotkey v1 destinadas a clientes antiguos de XMEye/CMS en Windows.

Permiten realizar capturas rápidas de cuatro cámaras mediante el teclado numérico, cerrar automáticamente Microsoft Photos después de cada captura y solicitar un cierre limpio de CMS.

> Utilidad comunitaria no oficial. No está afiliada con XMEye ni con el fabricante del software CMS.

## Configuración probada

- Windows 10
- CMS/XMEye 3.1.0.9
- AutoHotkey v1
- Distribución 2x2 de cuatro cámaras
- CMS maximizado en un monitor secundario
- Microsoft Photos abriéndose en el monitor principal
- Capturas de las cuatro cámaras mediante Numpad 1–4

La versión actual resulta suficientemente estable para uso real. El antiguo menú contextual de CMS puede dejar ocasionalmente algún pequeño glitch visual; volver a pulsar la tecla correspondiente suele recuperarlo.

## Archivos

- `CMS_Control.ahk` — control principal de capturas.
- `CerrarFotos.ahk` — cierra `Microsoft.Photos.exe` cada 50 ms para reducir lag y pérdida de foco.
- `Cerrar_CMS_Limpio.ahk` — solicita el cierre normal de `CMS.exe`, sin usar `/F`.
- `docs/troubleshooting.md` — notas técnicas, limitaciones y métodos que no resultaron fiables.

## Funcionamiento

El método estable utiliza movimiento real del ratón y clic derecho real. Tras abrir el menú contextual espera la ventana estándar `#32768`, envía `S` + `Enter` mediante `SendEvent` y espera de forma condicional a que el menú desaparezca.

Las coordenadas incluidas corresponden a la configuración probada. Si cambia el tamaño de la ventana, la distribución de cámaras, la resolución o el escalado DPI, probablemente habrá que ajustarlas.

Si CMS se ejecuta como administrador, ejecuta también los scripts de AutoHotkey como administrador.

## Licencia

MIT. Consulta [`LICENSE`](LICENSE).
