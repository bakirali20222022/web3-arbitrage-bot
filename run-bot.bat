@echo off
cd /d "C:\flashloan-new"
set NODE_OPTIONS=--max-old-space-size=1024 --max-semi-space-size=64
:loop
echo [%date% %time%] Starting...
npx hardhat run "C:\flashloan-new\scripts\arbitrage-engine.ts" --network polygon >> "C:\flashloan-new\logs\service.log" 2>&1
echo [%date% %time%] Stopped. Restarting in 5s... >> "C:\flashloan-new\logs\service.log"
timeout /t 5
goto loop
