# 🚀 Quick Reference

## 📁 Environment Configuration

### `.env.ngrok` (Primary Configuration)
- **Setup:** `make dev-up`
- **Domains:** abc123.ngrok-free.app (dynamic ngrok tunnels)
- **DIDs:** `did:web:abc123.ngrok-free.app:hongkong-university`
- **Use:** Development, demos, external access, device testing

## ⚡ Common Commands

```bash
# Setup & Teardown
make dev-up         # Start complete environment (ngrok + Docker)
make dev-down       # Stop ngrok and Docker services
make cleanup        # Full cleanup (remove all configs)

# Launch Apps
make hk-gov         # HK Governance Portal
make macau-gov      # Macau Governance Portal
make sg-gov         # Singapore Governance Portal
make verifier       # Nova Corp Verifier
make student-ios    # Student Vault App (iOS)
make student-android # Student Vault App (Android)

# Docker Management
make docker-ps      # Check container status
make docker-logs    # View all logs
make docker-rebuild # Rebuild and restart
```

## 📊 Check Current Status

```bash
# Check if environment is configured
ls -la deployment/.env*

# Check ngrok dashboard
open http://localhost:4040

# Check Docker containers
make docker-ps
```

## 🔍 Debugging

### Check Ngrok Domains
```bash
cat deployment/.env.ngrok | grep NGROK_DOMAIN
```

### View Ngrok Dashboard
```bash
open http://localhost:4040
```

### Check Docker Status
```bash
make docker-ps
# Or directly:
docker ps | grep university-issuer
```

## 📝 Important Notes

### Ngrok Behavior
- Free plan: Domains change on every restart of ngrok
- DIDs are regenerated when domains change
- `.env.ngrok` captures domains at start to prevent mid-setup regeneration

### Token Persistence
- Ngrok token saved to `.env.ngrok` for reuse
- No need to re-enter on subsequent runs
- Clean with: `make cleanup`

## 🐛 Troubleshooting

### "Port already in use"
```bash
make cleanup
make dev-up
```

### "No env file found"
```bash
make dev-up
```

### Ngrok won't start
```bash
# Check if already running
ps aux | grep ngrok

# Kill existing process
pkill -f ngrok

# Restart
make dev-up
```

## ✅ Verification

Run automated checks:
```bash
./deployment/scripts/verify_restructure.sh
```

Expected: **15/15 tests passed**

## 📚 Full Documentation

- [ENVIRONMENT_RESTRUCTURE.md](./ENVIRONMENT_RESTRUCTURE.md) - Detailed changes
- [RESTRUCTURE_COMPLETE.md](./RESTRUCTURE_COMPLETE.md) - Completion summary

## 🎬 Quick Start

New to the project? Start here:

```bash
# 1. Clean any previous setup
make cleanup

# 2. Start the environment
make dev-up

# 3. Launch apps (in separate terminals)
make hk-gov
make verifier
make student-ios

# 4. Success! 🎉
```

---

**Need help?** Check the full documentation or run verification script.
