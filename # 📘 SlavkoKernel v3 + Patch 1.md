# 📘 SlavkoKernel v3 + Patch 1

**Version:** Gertner/SlavkoKernel-v3+patch1  
**Commit:** PATCH_2025_11_11  
**Milestone:** Replay fidelity upgrade  
**Flags:** scenario-awareness, stop-token-extension  
**Date:** 2025-11-11

---

## 🔹 Overview
SlavkoKernel je orkestracijski modul dizajniran za audit-ready replay discipline i scenario-aware orchestration.  
Patch 1 donosi:
- Poboljšanu fidelity u replay testovima  
- Prošireno rukovanje stop-token signalima  
- Aktivaciju scenario-awareness za kontekstualne orkestracije  

---

## 🔹 Repository Structure
/manifests        → Kernel + orchestration configs  
/milestones       → Milestone logs + replay markers  
/pulseboard       → Timeline pulses for orchestration replay  
/replay_tests     → Deterministic replay validation suite  
checksums.txt     → Baseline integrity  
expected_checksums.txt → Validation reference  
Modelfile         → Model orchestration descriptor  
run_local.ps1     → Local replay runner  

---

## 🔹 Installation & Setup
1. Clone repo:
   ```bash
   git clone https://github.com/gertn/slavkokernel-v3.git
   cd slavkokernel-v3