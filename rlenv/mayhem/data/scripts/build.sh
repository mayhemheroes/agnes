#!/bin/bash
set -euo pipefail

# RLENV Build Script
# This script rebuilds the application from source located at /rlenv/source/agnes/
#
# Original image: ghcr.io/mayhemheroes/agnes:master
# Git revision: 93904e5cd767f1d5e93393cdd9947e31bb1688fe
# Target: ./agnes-fuzz (libFuzzer-instrumented C binary)

# ============================================================================
# Environment Variables
# ============================================================================
export CC=clang
export CFLAGS="-g -fsanitize=fuzzer"

# ============================================================================
# REQUIRED: Change to Source Directory
# ============================================================================
cd /rlenv/source/agnes/fuzz

# ============================================================================
# Clean Previous Build (recommended)
# ============================================================================
# Remove old build artifacts to ensure fresh rebuild
rm -f agnes-fuzz
rm -f *.o

# ============================================================================
# Build Commands (NO NETWORK, NO PACKAGE INSTALLATION)
# ============================================================================
# Build the fuzzer using the Makefile
# Command: clang -g -fsanitize=fuzzer -o agnes-fuzz agnes-fuzz.c ../agnes.c
make

# ============================================================================
# Set Permissions
# ============================================================================
chmod 777 agnes-fuzz 2>/dev/null || true

# 777 allows validation script (running as UID 1000) to overwrite during rebuild
# 2>/dev/null || true prevents errors if chmod not available

# ============================================================================
# REQUIRED: Verify Build Succeeded
# ============================================================================
if [ ! -f agnes-fuzz ]; then
    echo "Error: Build artifact not found at agnes-fuzz"
    exit 1
fi

# Verify executable bit
if [ ! -x agnes-fuzz ]; then
    echo "Warning: Build artifact is not executable"
fi

# Verify file size (fuzzer should be reasonably sized)
SIZE=$(stat -c%s agnes-fuzz 2>/dev/null || stat -f%z agnes-fuzz 2>/dev/null || echo 0)
if [ "$SIZE" -lt 1000 ]; then
    echo "Warning: Build artifact is suspiciously small ($SIZE bytes)"
fi

echo "Build completed successfully: agnes-fuzz ($SIZE bytes)"
