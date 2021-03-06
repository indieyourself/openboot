\ ========== Copyright Header Begin ==========================================
\ 
\ Hypervisor Software File: parse.fth
\ 
\ Copyright (c) 2006 Sun Microsystems, Inc. All Rights Reserved.
\ 
\  - Do no alter or remove copyright notices
\ 
\  - Redistribution and use of this software in source and binary forms, with 
\    or without modification, are permitted provided that the following 
\    conditions are met: 
\ 
\  - Redistribution of source code must retain the above copyright notice, 
\    this list of conditions and the following disclaimer.
\ 
\  - Redistribution in binary form must reproduce the above copyright notice,
\    this list of conditions and the following disclaimer in the
\    documentation and/or other materials provided with the distribution. 
\ 
\    Neither the name of Sun Microsystems, Inc. or the names of contributors 
\ may be used to endorse or promote products derived from this software 
\ without specific prior written permission. 
\ 
\     This software is provided "AS IS," without a warranty of any kind. 
\ ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, 
\ INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A 
\ PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE HEREBY EXCLUDED. SUN 
\ MICROSYSTEMS, INC. ("SUN") AND ITS LICENSORS SHALL NOT BE LIABLE FOR 
\ ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR 
\ DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES. IN NO EVENT WILL SUN 
\ OR ITS LICENSORS BE LIABLE FOR ANY LOST REVENUE, PROFIT OR DATA, OR 
\ FOR DIRECT, INDIRECT, SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE 
\ DAMAGES, HOWEVER CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, 
\ ARISING OUT OF THE USE OF OR INABILITY TO USE THIS SOFTWARE, EVEN IF 
\ SUN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
\ 
\ You acknowledge that this software is not designed, licensed or
\ intended for use in the design, construction, operation or maintenance of
\ any nuclear facility. 
\ 
\ ========== Copyright Header End ============================================
id: @(#)parse.fth 1.2 99/02/08
purpose: 
copyright: Copyright 1998 Sun Microsystems, Inc.  All Rights Reserved

: next-descriptor  ( addr1 -- next-addr )
   dup c@ +
;

: #remaining  ( addr1 addr2 cnt1 -- cnt2 )
   -rot swap - -
;

: interface-descript?  ( addr -- interface? )
   1+ c@  interface-descript =
;

: endpoint-descript?  ( addr -- endpoint? )
   1+ c@  endpoint-descript =
;

: my-alt0?  ( int# addr -- ok? )
   tuck i-descript-interface-id c@ =
   swap i-descript-alt-id c@ 0=
   and
;

: intn-alt0?  ( int# addr -- this-one? )
   dup interface-descript?
   -rot my-alt0?  and
;

\ loop through the descriptor as long as it is not interface n, alternative
\ setting 0.  When it is, return the start and remaining number of bytes in
\ the descriptor
: find-int-start  ( conf-adr ccnt intn -- intn-adr ccnt2 )
   -rot >r					( R: cnt )
   begin			( int# addr )  ( R: cnt )
      dup next-descriptor	( int# addr1 addr2 )
      tuck r> #remaining >r
      2dup intn-alt0?
   until
   nip r>
;

: next-endpoint-descriptor  ( addr --endp-descr )
   begin
      next-descriptor
      dup endpoint-descript?
   until
;

: find-ith-endpoint-start  ( int-descr i -- endp-descr )
   1+ 0 do  next-endpoint-descriptor  loop
;
