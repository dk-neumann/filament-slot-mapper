# Filament Slot Mapper

A single-page tool for working out which LEDs on a [WLED](https://kno.wled.ge/)-driven strip
sit under each filament spool slot on a shelving rack. It produces `filament-slots.json`,
the slot map used by the companion [Filament Locator](https://github.com/dk-neumann/filament-locator) app.

**Using Filament Locator?** The mapper is built into it at `http://<locator-host>:7920/mapper`,
where it saves the map straight to the app. This repository is the standalone version.

## Rack layout it assumes

- Up to **3 racks**, each with **8 shelves** (A at the bottom to H at the top) and **5 slots** per shelf,
  numbered 1–5 from left to right. A slot is named `rack-shelf-position`, e.g. `2-C-3`.
- One LED strip (300 LEDs per rack) zigzags across the shelves, and racks can be daisy-chained.
  Each rack's starting LED, whether its strip starts at the top or bottom, and which way its
  first shelf runs are all set in the page.

The shelf/slot counts and LEDs per rack are constants near the top of the script
(`SHELVES`, `SLOTS`, `RACK_COUNT`, `LEDS_PER_RACK`).

## Running it

The page talks to WLED's JSON API directly from the browser. Browsers block that from a page
opened as a local file, so serve it over HTTP. Either:

```bash
python -m http.server 8765 --bind 0.0.0.0
```

then open `http://<this-computer>:8765/slot-mapper.html` from any device on your network
(handy for using a tablet at the rack), or on Windows run `start-mapper.ps1`, which serves
it at `http://localhost:8321` for this PC only.

## Mapping

1. Enter your WLED controller's IP or hostname and tap **Test**.
2. Set **Racks in use**, then for each rack tab set its layout and tap **Apply layout guess**.
3. For each shelf, step the cursor to the LED at the left end of the shelf and tap **L = cursor**;
   do the same for the right end with **R = cursor**. The 5 slots are spaced evenly between them.
4. Tap **Light shelf** or **Light rack** to check (slot 1 red, 2 green, 3 blue, 4 amber, 5 purple).
   Adjust the default slot width, or fine-tune single slots under **Selected slot**.
5. Tap **Export** to save `filament-slots.json`, and copy it into the locator's `data/` folder.

Progress auto-saves in the browser. **Import** and **Load saved map from PC** replace only the
racks contained in the file; other racks are kept.

## License

MIT — see [LICENSE](LICENSE).
