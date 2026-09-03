
## 🚀 Performance Optimization Benchmarks

| Metric | Baseline (Before) | Optimized (After) | Improvement |
| :--- | :---: | :---: | :---: |
| **Dart Heap Usage** | 19.3 MB | **12.9 MB** | 📉 **-33.2%** |
| **Dart Heap Capacity** | 20.5 MB | **16.0 MB** | 📉 **-22.0%** |
| **Garbage Collections (GC)** | 57 events | **17 events** | 📉 **-70.2%** |
| **Janky Frames (Typing)** | 9 frames | **2 frames** | 📉 **-77.8%** |
| **Peak Raster Time** | 49.1 ms | **~25.0 ms** | ⚡ **-49.1%** |
| **Average FPS (Typing)** | 56 FPS | **59 FPS** | 📈 **+5.4%** |
| **Startup Time (First Frame)** | 1,926 ms | **1,722 ms** | ⚡ **-10.6%** |
| **Release APK Size** | 21.0 MB | **21.0 MB** | ⚖️ **Maintained** |

> **Environment:** Profiled using Flutter DevTools on Android `arm64` with the Impeller rendering engine.
















1- foreground state
<img width="389" height="821" alt="image" src="https://github.com/user-attachments/assets/c3d1381a-d77c-4837-b2fa-7933bb5a15b3" />

2- background, and terminated states
<img width="407" height="815" alt="image" src="https://github.com/user-attachments/assets/301378d9-7397-4d07-b61c-ff732dc9bb2a" />

