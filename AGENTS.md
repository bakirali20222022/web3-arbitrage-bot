# Polygon Multi-DEX Arbitrage Engine — Final Configuration

## Architecture
```
Windows Scheduled Task "PolygonArbitrageBot" (boot auto-start)
  └─ run-bot.bat (:loop / 5s restart / 3GB RAM)
       └─ npx hardhat run scripts/arbitrage-engine.ts
            ├─ Provider: batchMaxCount:1, cacheTimeout:1000, staticNetwork:true
            ├─ 12× concurrent token scanning
            ├─ 6 DEX adapters (QuickSwap, SushiSwap, KyberSwap, 3× Curve)
            ├─ 25 tokens × 12 RPC calls = 300 calls/scan (~5s per cycle)
            └─ Unified notifications (Telegram + WhatsApp, set in .env)
```

## Contracts
| Contract | Address | Role |
|----------|---------|------|
| ArbitrageExecutor (V1) | `0xE6b1c26a03e9B37c0F0aa05B89F199e9992D41CE` | UniV2-only (QuickSwap, SushiSwap, KyberSwap) |
| MultiDexExecutor (V2) | `0xaBe780d28fADcf6642187Ae3b38f2A875d3583CE` | All DEXs including Curve |

## Service management (PowerShell)
- Start: `Start-ScheduledTask -TaskName 'PolygonArbitrageBot'`
- Stop:  `Stop-ScheduledTask -TaskName 'PolygonArbitrageBot'`
- Logs:  `Get-Content 'C:\flashloan-new\logs\service.log' -Tail 50`
- Reinstall: `powershell -ExecutionPolicy Bypass -File scripts/install-service.ps1`

## Key files
- `contracts/ArbitrageExecutor.sol` — V1 flash loan executor (UniV2)
- `contracts/MultiDexExecutor.sol` — V2 flash loan executor (UniV2, Curve, Balancer)
- `scripts/arbitrage-engine.ts` — Main scanning + execution loop
- `scripts/telegram.ts` — Telegram alert module
- `scripts/whatsapp.ts` — WhatsApp alert module (Chrome-based, QR auth on first run)
- `scripts/notifications.ts` — Unified notifier dispatching to both channels
- `scripts/deploy-v2-executor.ts` — Deploy MultiDexExecutor
- `scripts/install-service.ps1` — Register Windows scheduled task
- `scripts/uninstall-service.ps1` — Remove scheduled task
- `run-bot.bat` — Start/restart loop launcher
- `.env` — RPC URL, private key, Telegram, WhatsApp, executor addresses

## Current scan parameters
- 25 tokens, 6 DEXs, 10k USDC.e loan
- 12× concurrent, 300 RPC calls/cycle, ~5s per scan
- Min profit: 15 bps / $2
- Premium: 5 bps (Aave flash loan fee)
- RAM: 3072 MB (--max-old-space-size)
