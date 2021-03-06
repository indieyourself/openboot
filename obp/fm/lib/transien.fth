\ transien.fth 2.10 99/05/04
\ Copyright 1985-1990 Bradley Forthware

\ Transient vocabulary
\
\ transient  ( -- )		Compile following definitions into the
\				transient dictionary
\				Nested 'transient's are *not* allowed
\ resident  ( -- )		Compile following definitions into the resident
\				dictionary.

decimal
0 value transize
0 value transtart

0 value there
0 value hedge
0 value ouser
   \ Two dictionary pointers exist, for transient space and
   \ resident space.  "Here" always points to the set currently being used.
   \ "There" points to the "other" one.
   \ "limit" is top of current space, "hedge" is top of other space
   \ "ouser" is the other user area allocation pointer.
0 value transient?

hex
: set-transize  ( transient-size user-transient-size -- )
   over  0=  if                          ( 0 user-transient-size )
      transize  if                       ( 0 user-transient-size )
         transtart transize +  is limit  ( 0 user-transient-size )
      then                               ( 0 user-transient-size )
      drop  is transize                  ( )
      exit
   then

   there transtart <> abort" Cannot change transient area unless unused."

   user-size swap - is ouser

   is transize
   limit is hedge			\ Top of transient space
   hedge transize -  is transtart
   transtart   is there
   transtart   is limit
;
decimal
\   \t16 decimal 30000 set-transize
\   \t32 decimal 40000 set-transize

: exchange  ( -- )  \ switch "here" with "there"
   here   there dp !       is there
   limit  hedge is limit   is hedge

   #user @  ouser #user !  is ouser
   \ XXX need to support limit checking for user area too.
;

: in-any-dictionary?  ( adr -- flag )
   dup origin here between    ( adr flag )
   transize  if
      swap  transtart dup transize +  between  or
   else
      nip
   then
;
' in-any-dictionary?  is in-dictionary?

false value suppress-transient?
: transient  ( -- )
   suppress-transient?  if  exit  then
   transient? abort" Nested transient's not allowed"
   true is transient?
   exchange
;
: resident  ( -- )  transient?  if  false is transient?  exchange  then  ;

: headerless:  ( r-xt -- )  origin+  create 0 setalias  ;
: header:      ( r-xt -- )  drop [compile] \ ; immediate
