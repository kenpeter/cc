#!/usr/bin/env bash
# Run all agent team tests
# Usage: bash tests/run_all.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0

run_test() {
    local test_file="$1"
    local test_name
    test_name="$(basename "$test_file" .sh)"
    echo "--- Running: $test_name ---"
    if bash "$test_file"; then
        echo "✅ PASS: $test_name"
        PASS=$((PASS+1))
    else
        echo "❌ FAIL: $test_name"
        FAIL=$((FAIL+1))
    fi
    echo ""
}

echo "========================================="
echo "  Agent Team Test Suite"
echo "========================================="
echo ""

for test in "$SCRIPT_DIR"/test_*.sh; do
    [ -f "$test" ] && run_test "$test"
done

echo "========================================="
echo "  Results: $PASS passed, $FAIL failed"
echo "========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
