"""backemf_fit.py - ajusta lambda_m a partir de backemf_peaks.json y genera la figura.

Requiere haber ejecutado antes backemf_extract.py.
Uso:  ./.venv/Scripts/python.exe 04_model/scripts/backemf_fit.py   (desde la raiz)
"""

import numpy as np, json, os
import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(__file__)
rows = json.load(open(os.path.join(HERE, "..", "results", "backemf_peaks.json")))
SQ3 = np.sqrt(3)
P = 3

good = [r for r in rows if r["A1"] > 0.5]
bad = [r for r in rows if r["A1"] <= 0.5]
print(f"capturas totales : {len(rows)}")
print(f"validas          : {len(good)}")
print(f"descartadas      : {len(bad)}  (motor ya parado, A1 < 0.5 V)")

f = np.array([r["f"] for r in good])
A = np.array([r["A1"] for r in good])
lam = np.array([r["lam"] for r in good])
thd = np.array([r["thd"] for r in good])
fz = np.array([r["f_zc"] for r in good])

print(f"\nrango de frecuencia : {f.min():.1f} .. {f.max():.1f} Hz  ({f.max()/f.min():.1f}:1)")
print(f"rango mecanico      : {f.min()*60/P:.0f} .. {f.max()*60/P:.0f} rpm")
print(f"acuerdo FFT/cruces  : error medio {np.mean(np.abs(f-fz)/f)*100:.2f} %")

print(f"\nlambda por captura  : {lam.mean()*1e3:.3f} ± {lam.std()*1e3:.3f} mWb "
      f"(dispersion {100*lam.std()/lam.mean():.1f} %)")

sl = (f @ A) / (f @ f)
lam_o = sl / (SQ3 * 2 * np.pi)
res = A - sl * f
print(f"\nAJUSTE FORZADO POR EL ORIGEN")
print(f"  A1 = {sl:.5f} * f      ->  lambda = {lam_o*1e3:.3f} mWb")
print(f"  R^2 = {1 - np.sum(res**2)/np.sum((A-A.mean())**2):.5f}")

m, b0 = np.polyfit(f, A, 1)
sm = np.sqrt(np.sum((A-(m*f+b0))**2)/(len(f)-2))
sb = sm*np.sqrt(np.sum(f**2)/(len(f)*np.sum((f-f.mean())**2)))
print(f"\nAJUSTE LIBRE (test de sesgo)")
print(f"  A1 = {m:.5f}*f {b0:+.4f}   ->  lambda = {m/(SQ3*2*np.pi)*1e3:.3f} mWb")
print(f"  ordenada = {b0:+.4f} ± {sb:.4f} V   ({abs(b0/sb):.1f} sigma de cero)")

VESC = 0.016016
print(f"\n{'='*58}")
print(f"  MEDIDO (ajuste por el origen) : {lam_o*1e3:.2f} mWb")
print(f"  VESC (deteccion FOC)          : {VESC*1e3:.2f} mWb")
print(f"  desviacion                    : {100*(lam_o-VESC)/VESC:+.1f} %")
print(f"{'='*58}")

Kt_v = 1.5*P*VESC
Kt_m = 1.5*P*lam_o
print(f"\nKt VESC   = {Kt_v:.4f} Nm/A     -> 120 A = {Kt_v*120:.2f} Nm")
print(f"Kt MEDIDO = {Kt_m:.4f} Nm/A     -> 120 A = {Kt_m*120:.2f} Nm")
print(f"\nTHD (contenido armonico) : {thd.mean()*100:.1f} % de media, "
      f"min {thd.min()*100:.1f} % max {thd.max()*100:.1f} %")

fig, ax = plt.subplots(1, 2, figsize=(12.5, 5))
xx = np.linspace(0, f.max()*1.05, 50)
ax[0].plot(xx, sl*xx, "-", color="#1D4E9C", lw=1.6,
           label=f"ajuste por el origen\n$\\lambda_m$ = {lam_o*1e3:.2f} mWb")
ax[0].plot(xx, SQ3*2*np.pi*VESC*xx, "--", color="#c44", lw=1.4,
           label=f"VESC ({VESC*1e3:.2f} mWb)")
ax[0].plot(f, A, "o", ms=5, color="#222", label=f"{len(f)} capturas")
ax[0].set_xlabel("frecuencia electrica [Hz]"); ax[0].set_ylabel("amplitud fundamental $V_{AB}$ [V]")
ax[0].set_title("Back-EMF: amplitud vs frecuencia"); ax[0].legend(); ax[0].grid(alpha=.3)
ax[0].set_xlim(0, None); ax[0].set_ylim(0, None)

ax[1].plot(f, lam*1e3, "o", ms=5, color="#222")
ax[1].axhline(lam_o*1e3, color="#1D4E9C", lw=1.6, label="media medida")
ax[1].axhline(VESC*1e3, color="#c44", ls="--", lw=1.4, label="VESC")
ax[1].set_xlabel("frecuencia electrica [Hz]"); ax[1].set_ylabel("$\\lambda_m$ [mWb]")
ax[1].set_title("$\\lambda_m$ captura a captura (test de linealidad)")
ax[1].legend(); ax[1].grid(alpha=.3); ax[1].set_ylim(14, 18)
plt.tight_layout()
out = "04_model/results/back_emf_resultado.png"
plt.savefig(out, dpi=115)
print(f"\nfigura -> {out}")
