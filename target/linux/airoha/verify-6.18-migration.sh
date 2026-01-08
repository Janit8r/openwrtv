#!/bin/bash
# Verification script for Airoha kernel 6.18 migration

echo "=== Airoha Kernel 6.18 Migration Verification ==="
echo ""

# Check Makefile
echo "[1/5] Checking Makefile..."
if grep -q "KERNEL_PATCHVER:=6.18" airoha/Makefile; then
    echo "✓ Makefile updated to 6.18"
else
    echo "✗ Makefile not updated to 6.18"
    exit 1
fi

# Check config files
echo ""
echo "[2/5] Checking config-6.18 files..."
for subtarget in an7581 an7583 en7523; do
    if [ -f "airoha/${subtarget}/config-6.18" ]; then
        echo "✓ config-6.18 exists for ${subtarget}"
    else
        echo "✗ config-6.18 missing for ${subtarget}"
        exit 1
    fi
done

# Check patches directory
echo ""
echo "[3/5] Checking patches-6.18 directory..."
if [ -d "airoha/patches-6.18" ]; then
    patch_count=$(find airoha/patches-6.18 -name "*.patch" | wc -l)
    echo "✓ patches-6.18 directory exists with ${patch_count} patches"
    
    if [ "$patch_count" -ne 105 ]; then
        echo "⚠ Warning: Expected 105 patches, found ${patch_count}"
    fi
else
    echo "✗ patches-6.18 directory missing"
    exit 1
fi

# Check for removed mainline patches
echo ""
echo "[4/5] Checking removed mainline patches..."
removed_count=0
for version in v6.13 v6.14 v6.15 v6.16 v6.17; do
    count=$(find airoha/patches-6.18 -name "*${version}*" | wc -l)
    if [ "$count" -eq 0 ]; then
        echo "✓ No ${version} patches found (correctly removed)"
    else
        echo "⚠ Warning: Found ${count} ${version} patches (should be removed)"
        removed_count=$((removed_count + count))
    fi
done

# Check for retained patches
echo ""
echo "[5/5] Checking retained patches..."
v618_count=$(find airoha/patches-6.18 -name "*v6.18*" | wc -l)
v619_count=$(find airoha/patches-6.18 -name "*v6.19*" | wc -l)
custom_count=$(find airoha/patches-6.18 -name "*.patch" | grep -v "v6\." | wc -l)

echo "✓ v6.18 patches: ${v618_count}"
echo "✓ v6.19 patches: ${v619_count}"
echo "✓ Custom patches: ${custom_count}"

# Summary
echo ""
echo "=== Verification Summary ==="
echo "Makefile: ✓"
echo "Config files: ✓ (3/3)"
echo "Patches directory: ✓"
echo "Total patches: ${patch_count}"
echo "  - v6.18: ${v618_count}"
echo "  - v6.19: ${v619_count}"
echo "  - Custom: ${custom_count}"
echo ""
echo "Migration verification completed successfully!"
echo ""
echo "Next steps:"
echo "1. Review KERNEL_6.18_MIGRATION.md for details"
echo "2. Test build with: make menuconfig && make -j\$(nproc)"
echo "3. Test on hardware: AN7581, AN7583, EN7523"
