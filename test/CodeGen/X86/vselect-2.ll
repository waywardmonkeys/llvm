; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE41

define <4 x i32> @test1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test1:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test1:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
  %select = select <4 x i1><i1 true, i1 true, i1 false, i1 false>, <4 x i32> %A, <4 x i32> %B
  ret <4 x i32> %select
}

define <4 x i32> @test2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test2:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test2:
; SSE41:       # BB#0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; SSE41-NEXT:    retq
  %select = select <4 x i1><i1 false, i1 false, i1 true, i1 true>, <4 x i32> %A, <4 x i32> %B
  ret <4 x i32> %select
}

define <4 x float> @test3(<4 x float> %A, <4 x float> %B) {
; SSE2-LABEL: test3:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test3:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendpd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; SSE41-NEXT:    retq
  %select = select <4 x i1><i1 true, i1 true, i1 false, i1 false>, <4 x float> %A, <4 x float> %B
  ret <4 x float> %select
}

define <4 x float> @test4(<4 x float> %A, <4 x float> %B) {
; SSE2-LABEL: test4:
; SSE2:       # BB#0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test4:
; SSE41:       # BB#0:
; SSE41-NEXT:    blendpd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE41-NEXT:    retq
  %select = select <4 x i1><i1 false, i1 false, i1 true, i1 true>, <4 x float> %A, <4 x float> %B
  ret <4 x float> %select
}
