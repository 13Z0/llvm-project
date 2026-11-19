; REQUIRES: amdgpu-registered-target

; The data layout string below comes from an older LLVM. When clang reads the
; bitcode, it upgrades the string. The upgraded string describes the target
; layout, but it lists the specifications in a different order. Clang must
; accept it.
; RUN: llvm-as %s -o %t.bc
; RUN: %clang_cc1 -triple amdgcn-amd-amdhsa -target-cpu gfx900 -x ir %t.bc -emit-obj -o /dev/null

; A layout that differs from the target layout is still an error.
; RUN: sed 's/p3:32:32/p3:64:64/' %s | llvm-as -o %t.bad.bc
; RUN: not %clang_cc1 -triple amdgcn-amd-amdhsa -target-cpu gfx900 -x ir %t.bad.bc -emit-llvm-bc -o /dev/null 2>&1 | FileCheck %s
; CHECK: error: backend data layout '{{.*}}-p3:64:64-{{.*}}' does not match expected target description '{{.*}}-p3:32:32-{{.*}}'

target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"
target triple = "amdgcn-amd-amdhsa"

define void @func() {
  ret void
}
