"""backemf_extract.py - lee las capturas BMP del MaxiScope y saca (f, amplitud).

Ensayo: back-EMF en circuito abierto, 2026-09-07. Motor desconectado del VESC,
sonda entre fase A y fase B, ventana de 500 ms, rango +-20 V.

Salida: 04_model/results/backemf_peaks.json, una entrada por captura.
Uso:  ./.venv/Scripts/python.exe 04_model/scripts/backemf_extract.py   (desde la raiz)
"""

import numpy as np, glob, os, json
from PIL import Image

ROW_TOP, ROW_BOT = 6.0, 854.0
COL_L, COL_R = 43.0, 1616.5
V_PER_ROW = -40.0 / (ROW_BOT - ROW_TOP)
MS_PER_COL = 500.0 / (COL_R - COL_L)
XMIN = 46
P = 3
SQ3 = np.sqrt(3)


def trace(path):
    im = np.asarray(Image.open(path).convert("RGB")).astype(int)
    R, G, B = im[:, :, 0], im[:, :, 1], im[:, :, 2]
    o = (R > 190) & (G > 70) & (G < 190) & (B < 110)
    o[:, :XMIN] = False
    o[int(ROW_BOT) + 2:, :] = False
    cols = np.where(o.any(0))[0]
    v = np.array([20.0 + (np.where(o[:, c])[0].mean() - ROW_TOP) * V_PER_ROW
                  for c in cols])
    t = (cols - COL_L) * MS_PER_COL * 1e-3            # s
    # rejilla uniforme: las columnas tienen huecos y la FFT los necesita uniformes
    tu = np.linspace(t[0], t[-1], len(t))
    return tu, np.interp(tu, t, v)


def measure(t, v):
    n = len(v)
    v = v - v.mean()
    df = 1.0 / (t[-1] - t[0])
    win = np.hanning(n)
    mag = np.abs(np.fft.rfft(v * win)) / (win.sum() / 2)
    fr = np.fft.rfftfreq(n, t[1] - t[0])
    k = np.argmax(mag[1:]) + 1
    a, b, c = mag[k - 1], mag[k], mag[k + 1]
    d = 0.5 * (a - c) / (a - 2 * b + c)
    f0 = fr[k] + d * df
    A1 = b - 0.25 * (a - c) * d
    harm = []
    for m in range(2, 10):
        j = int(round(m * f0 / df))
        if j + 2 < len(mag):
            harm.append(mag[j - 1:j + 2].max())
    thd = np.sqrt(np.sum(np.square(harm))) / A1
    # cruces por cero, como control independiente de la FFT
    s = np.sign(v)
    s[s == 0] = 1
    f_zc = np.sum(s[:-1] * s[1:] < 0) / 2 / (t[-1] - t[0])
    return f0, A1, thd, f_zc, np.abs(v).max()


rows = []
for grp in ["low_speed", "mid_speed", "high_speed"]:
    for f in sorted(glob.glob(f"06_data/2026-09-07_back-emf/raw/{grp}/*.BMP")):
        t, v = trace(f)
        f0, A1, thd, f_zc, vpk = measure(t, v)
        rows.append(dict(grp=grp, file=os.path.basename(f), f=f0, f_zc=f_zc,
                         A1=A1, vpk=vpk, thd=thd,
                         lam=A1 / (SQ3 * 2 * np.pi * f0), rpm=f0 * 60 / P))

json.dump(rows, open(os.path.join(os.path.dirname(__file__), "..", "results",
                                  "backemf_peaks.json"), "w"))

hdr = f"{'grupo':<11}{'n':>3}{'f FFT':>8}{'f cruces':>9}{'rpm mec':>9}{'A1 [V]':>8}{'Vpk':>7}{'THD':>7}{'lambda [mWb]':>16}"
print(hdr); print("-" * len(hdr))
for grp in ["low_speed", "mid_speed", "high_speed"]:
    s = [r for r in rows if r["grp"] == grp]
    g = lambda k: np.array([r[k] for r in s])
    print(f"{grp:<11}{len(s):>3}{g('f').mean():>8.2f}{g('f_zc').mean():>9.2f}"
          f"{g('rpm').mean():>9.0f}{g('A1').mean():>8.3f}{g('vpk').mean():>7.2f}"
          f"{g('thd').mean():>7.1%}{g('lam').mean()*1e3:>11.3f} ±{g('lam').std()*1e3:.3f}")

lam = np.array([r["lam"] for r in rows])
print(f"\nTODAS ({len(lam)}): lambda = {lam.mean()*1e3:.3f} ± {lam.std()*1e3:.3f} mWb "
      f"(dispersion {100*lam.std()/lam.mean():.1f} %)")
print(f"VESC              : 16.016 mWb  ->  desviacion {100*(lam.mean()-0.016016)/0.016016:+.1f} %")

# regresion A1 vs f forzada por el origen y libre
f = np.array([r["f"] for r in rows]); A = np.array([r["A1"] for r in rows])
sl = (f @ A) / (f @ f)
print(f"\nAjuste por el origen : A1 = {sl:.5f}*f  ->  lambda = {sl/(SQ3*2*np.pi)*1e3:.3f} mWb")
m, b0 = np.polyfit(f, A, 1)
print(f"Ajuste libre         : A1 = {m:.5f}*f {b0:+.3f}  ->  lambda = {m/(SQ3*2*np.pi)*1e3:.3f} mWb")
print(f"  ordenada en el origen {b0:+.3f} V  (deberia ser ~0)")
print(f"  R^2 = {1 - np.sum((A-(m*f+b0))**2)/np.sum((A-A.mean())**2):.4f}")
